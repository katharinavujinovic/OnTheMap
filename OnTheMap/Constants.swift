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
    }
}


