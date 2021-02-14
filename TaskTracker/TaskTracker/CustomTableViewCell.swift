//
//  CustomTableViewCell.swift
//  TaskTracker
//
//  Created by Daria Eremina on 14.02.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var heading: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var statusBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
