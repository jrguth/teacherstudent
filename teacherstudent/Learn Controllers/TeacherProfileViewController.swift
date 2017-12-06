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
    var myName: String!
    
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
    
    @IBOutlet weak var sendMessageLabel: UILabel!
    @IBOutlet weak var messageToSend: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database.database().reference()
        database.keepSynced(true)
        self.userID = Auth.auth().currentUser?.uid
        
        self.messageToSend.layer.borderWidth = 1.0
        
        self.database.child("users/\(self.userID!)/name").observeSingleEvent(of: .value, with: {snapshot in
            self.myName = snapshot.value as? String
        })
        
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
            
            if snapshot.hasChild("conversations/\(self.userID!)") {
                self.sendMessageLabel.text = "You already have a conversation with \(self.nameLabel.text!). Open the conversation in the messages tab to request a session."
                self.messageToSend.isHidden = true
                self.sendButton.isHidden = true
            }
        })
    }
    
    @IBAction func sendbutton(_ sender: UIButton) {
        let myRef = self.database.child("users/\(self.userID!)/conversations")
        let teacherRef = self.database.child("users/\(self.teacherUserID!)/conversations")
        let conversationRef = self.database.child("conversations").childByAutoId()
        let conversationKey = conversationRef.key
        let messageRef = conversationRef.childByAutoId()

        let message = self.messageToSend.text!
        let key = messageRef.key
        
        conversationRef.child("\(key)/message").setValue(message)
        conversationRef.child("\(key)/sender").setValue(self.userID!)
        
        var newConversation: Dictionary<String,String> = Dictionary<String,String>()
        
        newConversation["conversation id"] = conversationKey
        newConversation["with"] = self.nameLabel.text!
        myRef.child(self.teacherUserID!).setValue(newConversation)
        
        newConversation["with"] = self.myName
        teacherRef.child(self.userID!).setValue(newConversation)
        
        /*
        myRef.child("\(self.teacherUserID!)/conversation id").setValue(conversationKey)
        myRef.child("\(self.teacherUserID!)/with").setValue(self.nameLabel.text!)
        teacherRef.child("\(self.userID!)/conversation id").setValue(conversationKey)
        teacherRef.child("\(self.userID!)/with").setValue(self.myName)*/
        
        
        /*
        self.database.observeSingleEvent(of: .value, with: {snapshot in
            let myName = snapshot.childSnapshot(forPath: "users/\(self.userID!)/name").value as! String
            teacherRef.child("\(conversationRef.key)/other name").setValue(myName)
            teacherRef.child("\(conversationRef.key)/other id").setValue(self.userID!)
        })*/

        self.sendMessageLabel.isHidden = true
        self.messageToSend.isHidden = true
        self.sendButton.isHidden = true
        
        let alert = UIAlertController(title: "Message sent", message: "Check your messages tab to view the conversation and/or request a session with \(self.nameLabel.text!)", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
