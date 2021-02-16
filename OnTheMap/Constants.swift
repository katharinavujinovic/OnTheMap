//
//  Constants.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 23.01.21.
//

import Foundation

class Constants {
    
    struct Identifiers {
        static let tableViewCellIdentifier = "LocationTableViewCell"
        static let locationtableViewIdentifier = "SelectLocationTableViewCell"
        static let loginSegueIdentifier = "LoginSegue"
        static let addPinSegueIdentifier = "AddPinSegue"
        static let submitPinSegueIdentifier = "SubmitLocationSegue"
    }
    
    struct Message {

        static let email = "Enter Email"
        static let password = "Enter Password"
        static let enterLocation = "Please enter a location"
    }
    
    struct Alarm {
        static let invalidLoginTitle = "Invalid Login"
        static let invalidLoginMessage = "Please enter a valid Email and Password"
        static let enterEmailTitle = "No Email or Password"
        static let logoutFailed = "Logout Failed"
        static let fetchingInformationFailed = "Fetching of Student Informations failed"
        static let postingInformationFailed = "Couldn't Post your Location"
        static let selectLocationTitle = "Pleace enter a Location"
        static let selectLocationMessage = "No Coordinations for your Pin could be determined. Please enter a Location"
    }
}


