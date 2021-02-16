//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 23.01.21.
//

import Foundation
import UIKit

class LocationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: Constants.Identifiers.tableViewCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.tableViewCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        loadStudentInformation()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        loadStudentInformation()
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UdacityClient.logout(completionHandler: handleLogout(success:error:))
    }
    
    func loadStudentInformation() {
        UdacityClient.getStudentInformation(completionHandler: handleGetStudentInformation(studentLocations:error:))
    }

    func handleLogout(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            alertMessage(title: Constants.Alarm.logoutFailed, message: error!.localizedDescription)
        }
    }
    
    func handleGetStudentInformation(studentLocations: [StudentInformation], error: Error?)
    {
        if error != nil {
            alertMessage(title: Constants.Alarm.fetchingInformationFailed, message: error!.localizedDescription)
        } else {
            UdacityClient.studentInformation = studentLocations
            self.tableView.reloadData()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.studentInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.tableViewCellIdentifier) as! LocationTableViewCell
        
        let student = UdacityClient.studentInformation[indexPath.row]
        
        cell.tableViewCellStudentName?.text = "\(student.firstName) \(student.lastName)"
        cell.tableViewCellStudentLink?.text = student.mediaURL
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // this is not yet fixed!
        let student = UdacityClient.studentInformation[indexPath.row]
        if student.mediaURL.contains("https") {
            UIApplication.shared.open(URL(string: student.mediaURL)!)
        } else {
            let alert = UIAlertController(title: "Invalid URL", message: "The URL you are trying to open is not valid. Please try another one", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
