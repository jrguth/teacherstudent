//
//  TeacherTableViewCell.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/12/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit

class TeacherTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var completedSessionsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
