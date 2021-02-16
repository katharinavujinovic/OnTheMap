//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 04.02.21.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var setLocationTableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var activityWeel: UIActivityIndicatorView!
    @IBOutlet weak var checkedImage: UIImageView!
    
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkedImage.isHidden = true
        locationSearchBar.delegate = self
        searchCompleter.delegate = self
        locationSearchBar?.delegate = self
        setLocationTableView?.delegate = self
        setLocationTableView?.dataSource = self
        
    }
    
    // To dismiss the Keyboard when return is pressed
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) {
        locationSearchBar.resignFirstResponder()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        UdacityClient.UserPinInformation.mediaURL = linkTextField.text ?? ""
        if UdacityClient.UserPinInformation.latitude != 0.0 {
            performSegue(withIdentifier: Constants.Identifiers.submitPinSegueIdentifier, sender: self)
        } else {
            alertMessage(title: Constants.Alarm.selectLocationTitle, message: Constants.Alarm.selectLocationMessage)
        }
    }
    
    

}

//MARK: - TableView

extension AddLocationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.Identifiers.locationtableViewIdentifier)
        
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
        return cell
    }
    
    // to refresh the searchresults based on what it typed into the searchbar
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setLocationTableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            
            UdacityClient.UserPinInformation.mapString = name
            self.locationSearchBar.text = UdacityClient.UserPinInformation.mapString
            UdacityClient.UserPinInformation.latitude = coordinate.latitude
            UdacityClient.UserPinInformation.longitude = coordinate.longitude
            
            if UdacityClient.UserPinInformation.latitude != 0.0 {
                self.checkedImage.isHidden = false
            }
        }
        
        searchBarShouldEndEditing(locationSearchBar)
        activityWeel.stopAnimating()
    }
    
}

//MARK: - SearchBar

extension AddLocationViewController: UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        activityWeel.startAnimating()
        checkedImage.isHidden = true
        setLocationTableView.reloadData()
    }
}
