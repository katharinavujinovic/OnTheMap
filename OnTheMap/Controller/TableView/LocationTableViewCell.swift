//
//  LocationTableViewCell.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 02.02.21.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewCellStudentName: UILabel!
    @IBOutlet weak var tableViewCellStudentLink: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // open the Link
    }
    
}
