//
//  SlideView.swift
//  mapSearch
//
//  Created by Jakub Slawecki on 02/11/2019.
//  Copyright © 2019 Jakub Slawecki. All rights reserved.
//

import UIKit

// MARK: State of the SlideView
enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open:
            return .closed
        case .closed:
            return .open
        }
    }
}

protocol SlideViewDelegate: AnyObject {
    func slideViewOpeaningAnimation()
    func slideViewClosingAnimation()
    
    func didFinichOpeaningSlideView()
    func didFinishClosingSlideView()
}

class SlideView: UIView, UIGestureRecognizerDelegate {
    weak var delegate: SlideViewDelegate?
    
    private var runningAnimators  = [UIViewPropertyAnimator]()
    private var animationProgress = [CGFloat]()
    
    var currentState: State = .closed
    var popupOffset: CGFloat!
    
    lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        //recognizer.cancelsTouchesInView = false
        return recognizer
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup () {
        addGestureRecognizer(panRecognizer)
        popupOffset = frame.height
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.6)
            runningAnimators.forEach { $0.pauseAnimation() }
            animationProgress = runningAnimators.map { $0.fractionComplete }
        case .changed:
            let translation = recognizer.translation(in: self)
            var fraction = -translation.y / popupOffset
            
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
        case .ended:
            let yVelocity = recognizer.velocity(in: self).y
            let shouldClose = yVelocity > 0
            
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if  shouldClose &&  runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if  shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose &&  runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
        default:
            ()
        }
    }
    
    func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        guard runningAnimators.isEmpty else { return }
        
        //MARK: Animator #1
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
                //opeaningAnimation / closingAnimation
            case .open:
                self.delegate?.slideViewOpeaningAnimation()
            case .closed:
                self.delegate?.slideViewClosingAnimation()
            }
        })
        
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }
            
            switch self.currentState {
                //didFinishClosingView/ didFinichOpeaningView
            case .open:
                self.delegate?.didFinichOpeaningSlideView()
            case .closed:
                self.delegate?.didFinishClosingSlideView()
            }
            self.runningAnimators.removeAll()
        }
        
        
        //MARK: start all animators
        transitionAnimator.startAnimation()
        
        //MARK: keep track of all running animators
        runningAnimators.append(transitionAnimator)
        
    }
}
