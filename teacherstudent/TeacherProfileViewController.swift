//
//  TeacherProfileViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TeacherProfileViewController: UIViewController {
    
    var database: DatabaseReference!
    var teacherUserID: String?
    var userID: String?
    var skill: String?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teacherRatingLabel: UILabel!
    @IBOutlet weak var completedSessionsLabel: UILabel!
    
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database.database().reference()
        database.keepSynced(true)
        self.userID = Auth.auth().currentUser?.uid
        
        let ref = database.child("users").child(self.teacherUserID!)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            self.nameLabel.text = snapshot.childSnapshot(forPath: "name").value as? String
            self.teacherRatingLabel.text = String(snapshot.childSnapshot(forPath: "teacher rating").value as! Double) + " / 10"
            self.completedSessionsLabel.text = String(snapshot.childSnapshot(forPath: "teacher sessions").value as! Int)
            
            let dict: Dictionary<String,String> = snapshot.childSnapshot(forPath: "availability").value as! Dictionary<String,String>
            self.mondayLabel.text = dict["Monday"]
            self.tuesdayLabel.text = dict["Tuesday"]
            self.wednesdayLabel.text = dict["Wednesday"]
            self.thursdayLabel.text = dict["Thursday"]
            self.fridayLabel.text = dict["Friday"]
            self.saturdayLabel.text = dict["Saturday"]
            self.sundayLabel.text = dict["Sunday"]
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RequestSessionViewController
        destination.userID = self.userID
        destination.teacherUserID = self.teacherUserID
        destination.teacherName = self.nameLabel.text
        destination.skill = self.skill
    }
}
