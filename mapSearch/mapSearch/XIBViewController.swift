//
//  XIBViewController.swift
//  mapSearch
//
//  Created by Jakub Slawecki on 02/11/2019.
//  Copyright © 2019 Jakub Slawecki. All rights reserved.
//

import UIKit

public class XIBViewController: UIViewController {
    
    internal init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
