//
//  CancelRequestViewController.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/20/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit

class CancelRequestViewController: UIViewController {

    var pendingSession: Dictionary<String,String>!
    var sessionID: String!
    
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.skillLabel.text = self.pendingSession["skill"]
        self.teacherLabel.text = self.pendingSession["teacher name"]
        self.dateLabel.text = self.pendingSession["date time"]
        self.locationLabel.text = self.pendingSession["location"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
