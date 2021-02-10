//
//  UdacityPostRequest.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 08.02.21.
//

import Foundation

struct UdacityPostRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
