//
//  MessageTableViewCell.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/28/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var receivedLabel: UILabel!
    @IBOutlet weak var sentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
