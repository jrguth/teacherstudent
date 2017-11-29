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
    var isMEssagable:Bool!
    
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
    
    @IBOutlet weak var messagetosend: UITextField!
    @IBAction func sendbutton(_ sender: UIButton) {
        if(isMEssagable){
            
        let myRef = self.database.child("users/\(self.userID!)/conversations")
        let conversationref = self.database.child("conversations").childByAutoId()
        let messageRef = conversationref.childByAutoId()
        
        let teacherRef = self.database.child("users/\(self.teacherUserID!)/conversations")
        
        let message = messagetosend.text!
        let key = messageRef.key
        
        
        conversationref.child("\(key)/message").setValue(message)
        conversationref.child("\(key)/sender").setValue(self.userID!)
        myRef.child(conversationref.key).setValue(nameLabel.text!)
        
        self.database.observeSingleEvent(of: .value, with: {snapshot in
            let myName = snapshot.childSnapshot(forPath: "users/\(self.userID!)/name").value as! String
            teacherRef.child(conversationref.key).setValue(myName)
        })
            messagetosend.isHidden = true
            sender.isHidden = true
            sender.isEnabled = false
            
        let aleart = UIAlertController(title: "message sent", message: "check message board for conversation", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        aleart.addAction(action)
        self.present(aleart, animated: true, completion: nil)
        isMEssagable = false
            // send back to bool array in teacher database to blank out feild and send 2nd time through
        
        }
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
