//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 05.02.21.
//

import Foundation
import UIKit
import MapKit

class SubmitLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var selectedLocationMap: MKMapView!
    @IBOutlet weak var setPinButton: UIButton!
    
    
    override func viewDidLoad() {
        showPin()
        super.viewDidLoad()
    }
    
    func showPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: UdacityClient.UserPinInformation.latitude, longitude: UdacityClient.UserPinInformation.longitude)
        pin.title = "\(UdacityClient.UserInformation.firstName) \(UdacityClient.UserInformation.lastName)"
        pin.subtitle = UdacityClient.UserPinInformation.mediaURL
        
        selectedLocationMap.addAnnotation(pin)
        
        let region = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        selectedLocationMap.setRegion(region, animated: true)
    }
    
    
    @IBAction func setPinButtonPressed(_ sender: Any) {
        UdacityClient.postLocation(uniqueKey: UdacityClient.Auth.uniqueKey, firstName: UdacityClient.UserInformation.firstName, lastName: UdacityClient.UserInformation.lastName, mapString: UdacityClient.UserPinInformation.mapString, mediaURL: UdacityClient.UserPinInformation.mediaURL, latitude: UdacityClient.UserPinInformation.latitude, longitude: UdacityClient.UserPinInformation.longitude, completionHandler: handlePOSTRequest(success:error:))
    }
    
    func handlePOSTRequest(success: Bool, error: Error?) {
        if success {
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            print(error!)
        }
        
    }
}
