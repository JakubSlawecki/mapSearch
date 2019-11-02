//
//  MainCreateRequestViewModel.swift
//  mapSearch
//
//  Created by Jakub Slawecki on 02/11/2019.
//  Copyright © 2019 Jakub Slawecki. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

protocol MainCreateRequestViewModelDelegate: AnyObject {
    func centerMapViewOnLocation(with region: MKCoordinateRegion)
    func setupLocationManagerAndSearchCompleter()
    func startActivityIndicator(value: Bool)
    func addressHasChanged(newValue: Address)
    func showLocationAuthorizationAlert()
    func closeDetailCreateTicketViewController()
    func reloadAddressSearchResultsTableView()
    //func changeStateOfTicketCreationContainerViewToClose()
    func showDetailCreateTicketViewControllerOrShowAddressOnMap()
    func reloadDetailCreateTicketTableView()
    func isEditContactViewControllerVisible(bool: Bool)
    func isEditStartDateViewControllerVisible(bool: Bool)
    func updateEditDateLabel(newValue: Date)
    func opeanTicketCreateContainerView()
}

class MainCreateRequestViewModel {
   weak var delegate: MainCreateRequestViewModelDelegate?
        
        let searchCompleter = MKLocalSearchCompleter()
        let locationManager = CLLocationManager()
        let regionInMeters: Double = 500
        var location = CLLocation()
        var mapView: MKMapView?
        
        var searchResults: [MKLocalSearchCompletion] = [] {
            didSet {
                delegate?.reloadAddressSearchResultsTableView()
            }
        }
        
        var ticket = Ticket()
        
        //MARK: Ticket components
        var address: Address {
            get { self.ticket.address }
            set {
                self.ticket.address = newValue
                delegate?.addressHasChanged(newValue: newValue)
                searchCompleter.queryFragment = "\(address.street) \(address.number), \(address.city) \(address.zip)"
            }
        }
        
        var geoLocation: Location {
            get { self.ticket.location }
            set {
                self.ticket.location = newValue
            }
        }
        
        var numberOfEnginners: Int {
            get { self.ticket.engineers }
            set {
                self.ticket.engineers = newValue
                delegate?.reloadDetailCreateTicketTableView()
            }
        }

        var numberOfDaysInSeconds: Int {
            get { self.ticket.duration }
            set {
                self.ticket.duration = newValue
                delegate?.reloadDetailCreateTicketTableView()
            }
        }
        
        var date: Date  {
            get { self.ticket.startDate }
            set {
                self.ticket.startDate = newValue
                delegate?.reloadDetailCreateTicketTableView()
            }
        }
        
        var editDate = Date() {
            didSet {
                delegate?.updateEditDateLabel(newValue: editDate)
            }
        }
        
        var timeOfADay = TimesOfADay.am
        
        var contact: Contact {
            get { self.ticket.contact ?? Contact() }
            set {
                editContact = newValue
                self.ticket.contact = newValue
                delegate?.reloadDetailCreateTicketTableView()
            }
        }
        
        var editContact = Contact()
        

        //MARK: Button Actions
        func myLocationButtonPressed() {
            if let location = locationManager.location {
                centerViewOnUserLocation(with: location)
            }
        }
        
        
        // MARK: Check Location Services and Location Authorization
        func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                delegate?.setupLocationManagerAndSearchCompleter()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                searchCompleter.filterType = .locationsAndQueries
                checkLocationAuthorization()
            } else {
                delegate?.showLocationAuthorizationAlert()
            }
        }
        
        func showLocationAuthorizationAlert(on viewController: UIViewController){
            let alert = UIAlertController(title: "Location Services disabled",
                                          message: "Please enable Location Services in Settings",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            viewController.present(alert, animated: true, completion: nil)
        }
        
        var sendTicketRequest: ((Ticket) -> Void)?
    }


    enum TimesOfADay {
        case am, pm
    }
