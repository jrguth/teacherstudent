//
//  FinalizeSessionViewController.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/26/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit

class FinalizeSessionViewController: UIViewController {

    var sessionID: String!
    var session: Dictionary<String,Any>!
    var rating: Double?
    
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var receivedRatingLabel: UILabel!
    
    @IBOutlet weak var ratingTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skillLabel.text = self.session["skill"] as? String
        self.teacherLabel.text = self.session["teacher name"] as? String
        self.dateLabel.text = self.session["date time"] as? String
        self.locationLabel.text = self.session["location"] as? String
        self.receivedRatingLabel.text = self.session["student rating"] as? String
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let rating = Double(self.ratingTextField.text!), rating >= 0, rating <= 10 {
            self.rating = rating
            self.performSegue(withIdentifier: "unwindToCompletedSessions", sender: self)
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
}
