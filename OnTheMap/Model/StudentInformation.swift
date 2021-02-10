//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 23.01.21.
//

import Foundation
import MapKit

struct StudentInformation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
