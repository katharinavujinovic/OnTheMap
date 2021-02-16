//
//  Alarm.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 16.02.21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

