//
//  ConfirmSessionViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class ConfirmSessionViewController: UIViewController {
    
    var database: DatabaseReference!
    
    var pendingSession: Dictionary<String,String>!
    var sessionID: String!

    var confirmed: Bool = true
    
   
    @IBOutlet weak var learnerNameLabel: UILabel!
   
    @IBOutlet weak var dateLabel: UILabel!
 
    
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var denyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        learnerNameLabel.text = self.pendingSession["learner name"]
        dateLabel.text = self.pendingSession["date time"]
        locationLabel.text = self.pendingSession["location"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        if button.titleLabel?.text == "Deny" {
            self.confirmed = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
 
}
