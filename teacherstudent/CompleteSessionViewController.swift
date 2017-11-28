//
//  CompleteSessionViewController.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/26/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CompleteSessionViewController: UIViewController {

    var userID: String!
    var sessionID: String!
    var session: Dictionary<String,String> = Dictionary<String,String>()
    
    var rating: Double?
    
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var otherPersonLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var outOfTenLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userID = Auth.auth().currentUser?.uid
        
        self.skillLabel.text = self.session["skill"]
        self.otherPersonLabel.text = self.session["other name"]
        self.dateLabel.text = self.session["date time"]
        self.locationLabel.text = self.session["location"]
        
        if (self.userID == self.session["learner id"]) {
            self.infoLabel.isHidden = true
            self.ratingTextField.isHidden = true
            self.outOfTenLabel.isHidden = true
            self.submitButton.isHidden = true
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let rating = Double(self.ratingTextField.text!), rating >= 0, rating <= 10 {
            self.rating = rating
            self.performSegue(withIdentifier: "unwindToProfileView", sender: self)
        } else {
            let alert = UIAlertController(title: "Woops!", message: "Please input a valid number between one and ten.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
