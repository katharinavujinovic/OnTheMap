//
//  LocationMapViewController.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 23.01.21.
//

import Foundation
import MapKit

class LocationMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        loadStudentInformation()
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        loadStudentInformation()
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        UdacityClient.logout(completionHandler: handleLogout(success:error:))
    }
    /*
     https://www.iosapptemplates.com/blog/swift-programming/mapkit-tutorial
     */
    
    func loadStudentInformation() {
        UdacityClient.getStudentInformation(completionHandler: handleGetStudentInformation(studentLocations:error:))
    }

    func handleLogout(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            print(error!)
        }
    }
    
    func handleGetStudentInformation(studentLocations: [StudentInformation], error: Error?)
    {
        if error != nil {
            print(error!)
        } else {
            UdacityClient.studentInformation = studentLocations
            populateMap()
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func populateMap() {
        
        for dictionary in UdacityClient.studentInformation {
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = dictionary.firstName + dictionary.lastName
            annotation.subtitle = dictionary.mediaURL
            
            annotations.append(annotation)
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            if let validURL = annotationView.annotation?.subtitle! {
                if validURL.contains("https") {
                UIApplication.shared.open(URL(string: validURL)!)
                } else {
                    let alert = UIAlertController(title: "Invalid URL", message: "The URL you are trying to open is not valid. Please try another one", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
  }

}

