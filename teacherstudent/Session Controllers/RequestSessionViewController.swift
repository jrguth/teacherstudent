//
//  RequestSessionViewController.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/13/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit
import Firebase

class RequestSessionViewController: UIViewController {

    var database: DatabaseReference!
    
    var userID: String?
    var teacherUserID: String?
    
    var userName: String?
    var teacherName: String?
    var skill: String?
    
    @IBOutlet weak var skillLabel: UILabel!

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
 
    @IBOutlet weak var teacherNameLabel: UILabel!

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        database.child("users").child(self.userID!).observeSingleEvent(of: .value, with: {snapshot in
            self.userName = snapshot.childSnapshot(forPath: "name").value as? String
        })
        
        self.skillLabel.text = self.skill
        self.teacherNameLabel.text = self.teacherName
        
        self.datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 1, to: datePicker.date)
        self.datePickerChanged(self.datePicker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        
        dateTimeLabel.text = formatter.string(from: datePicker.date)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitRequest(_ sender: UIButton) {
        let ref = self.database.child("session requests").childByAutoId()
        
        ref.child("learner id").setValue(self.userID)
        ref.child("teacher id").setValue(self.teacherUserID)
        ref.child("skill").setValue(self.skill)
        ref.child("learner name").setValue(self.userName)
        ref.child("teacher name").setValue(self.teacherName)
        ref.child("date time").setValue(self.dateTimeLabel.text!)
        ref.child("location").setValue(self.locationTextField.text!)
        
        let teacherRef = self.database.child("users").child(self.teacherUserID!)
        let learnerRef = self.database.child("users").child(self.userID!)
        
        self.database.observeSingleEvent(of: .value, with: {snapshot in
            
            var received: Dictionary<String,String>
            if snapshot.hasChild("users/\(self.teacherUserID!)/session requests") {
                received = snapshot.childSnapshot(forPath: "users/\(self.teacherUserID!)/session requests").value as! Dictionary<String,String>
            } else {
                received = Dictionary<String,String>()
            }
            
            var sent: Dictionary<String,String>
            if snapshot.hasChild("users/\(self.userID!)/sent requests") {
                sent = snapshot.childSnapshot(forPath: "users/\(self.userID!)/sent requests").value as! Dictionary<String,String>
            } else {
                sent = Dictionary<String,String>()
            }
            
            received[ref.key] = self.userID
            sent[ref.key] = self.teacherUserID
            
            teacherRef.child("session requests").setValue(received)
            learnerRef.child("sent requests").setValue(sent)
        })
        
        /*
        let teacherRef = database.child("users").child(self.teacherUserID!)
        teacherRef.observeSingleEvent(of: .value, with: {snapshot in
            var requests: [String]
            if snapshot.hasChild("session requests"){
                requests = snapshot.childSnapshot(forPath: "session requests").value as! [String]
            } else {
                requests = [String]()
            }
            requests.append(ref.key)
            teacherRef.child("session requests").setValue(requests)
        })
        
        let learnerRef = self.database.child("users").child(self.userID!)
        learnerRef.observeSingleEvent(of: .value, with: {snapshot in
            var sentRequests: [String]
            if snapshot.hasChild("sent requests") {
                sentRequests = snapshot.childSnapshot(forPath: "sent requests").value as! [String]
            } else {
                sentRequests = [String]()
            }
            sentRequests.append(ref.key)
            learnerRef.child("sent requests").setValue(sentRequests)
        })*/
        
        let alert = UIAlertController(title: nil, message: "Request sent!", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {action in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
