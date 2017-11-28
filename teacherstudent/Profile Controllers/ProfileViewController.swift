//
//  ProfileViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var database: DatabaseReference!
    var userID: String!
    var upcomingSessionsIDs: [String] = [String]()
    var upcomingSessions: Dictionary<String, Dictionary<String,String>> = Dictionary<String, Dictionary<String,String>>()
    
    var learnerName: String?
    var isUnwinding: Bool!
    
    @IBOutlet weak var teacherRatingLabel: UILabel!
    @IBOutlet weak var learnerRatingLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
        
        self.isUnwinding = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
     self.database.observeSingleEvent(of: .value, with: {snapshot in
        
        self.teacherRatingLabel.text = String(format: "%.2f", Double(snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).childSnapshot(forPath: "teacher rating").value as! Double))
        
        self.learnerRatingLabel.text = String(format: "%.2f", Double(snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).childSnapshot(forPath: "student rating").value as! Double))

         if (snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).hasChild("upcoming sessions")){
            if (!self.isUnwinding){
                let upcomingSessions: [String] = Array((snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).childSnapshot(forPath: "upcoming sessions").value as! Dictionary<String,String>).keys)
                self.upcomingSessionsIDs = upcomingSessions
                for id in self.upcomingSessionsIDs {
                    var session = snapshot.childSnapshot(forPath: "confirmed sessions").childSnapshot(forPath: id).value as! Dictionary<String,String>
                    
                    if (snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).childSnapshot(forPath: "upcoming sessions").childSnapshot(forPath: id).value as! String == "Teacher") {
                        session["other name"] = session["learner name"]
                    } else {
                        session["other name"] = session["teacher name"]
                    }
                    self.upcomingSessions[id] = session
                }
                self.tableView.reloadData()
            }
            
         }
     })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.isUnwinding) {
            let alert = UIAlertController(title: nil, message: "Session successfully completed. Pending approval from \(self.learnerName!)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            self.isUnwinding = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingSessionsIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UpcomingSessionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier:"UpcomingSessionTableViewCell", for: indexPath) as! UpcomingSessionTableViewCell
        
        if(self.upcomingSessionsIDs.count > 0){
            //let key = Array(self.upcomingSessions.keys)[indexPath.row]
            let session: Dictionary<String,String> = self.upcomingSessions[Array(self.upcomingSessions.keys)[indexPath.row]]!
            let date: String = session["date time"]!
            
            if (self.userID == session["teacher id"]) {
                cell.infoLabel.text = "Teaching session with " + session["other name"]! + " \(date)"
            } else {
                cell.infoLabel.text = "Learning session with " + session["other name"]! + " \(date)"
            }
            //let date = self.upcomingSessions[key]!["date time"]!
            //cell.infoLabel.text = "Session with " + self.upcomingSessions[key]!["other name"]! + " \(date)"
            
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CompleteSessionViewController {
            let cell = sender as? UpcomingSessionTableViewCell
            let indexPath: IndexPath = tableView.indexPath(for: cell!)!
            let id = [String](self.upcomingSessions.keys)[indexPath.row]
            
            destination.sessionID = id
            destination.session = self.upcomingSessions[id]!
        }
    }
    
    @IBAction func unwindToProfileView (sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? CompleteSessionViewController {
            self.isUnwinding = true

            let rating: Double = sourceVC.rating!
            let sessionID: String = sourceVC.sessionID
            var session: Dictionary<String,Any> = sourceVC.session as Dictionary<String,Any>
            
            let learnerRef = self.database.child("users/\(session["learner id"]!)")
            let teacherRef = self.database.child("users/\(session["teacher id"]!)")
            let completedSessionRef = self.database.child("completed sessions/\(sessionID)")
            //let sessionPendingCompletionRef = self.database.child("users/\(session["learner id"]!)/sessions pending approval").childByAutoId()
            
            self.database.observeSingleEvent(of: .value, with: {snapshot in
                
                let sumStudentRatings = snapshot.childSnapshot(forPath: "users/\(session["learner id"] as! String)/sum student ratings").value as! Double + rating
                let numSessions = snapshot.childSnapshot(forPath: "users/\(session["learner id"] as! String)/student sessions").value as! Int + 1
                
                learnerRef.child("student sessions").setValue(numSessions)
                learnerRef.child("sum student ratings").setValue(sumStudentRatings)
                learnerRef.child("student rating").setValue(Double(sumStudentRatings / Double(numSessions)))
                
                session["student rating"] = rating
                completedSessionRef.setValue(session)
                learnerRef.child("sessions pending completion/\(completedSessionRef.key)").setValue(session["teacher name"])
                
                teacherRef.child("upcoming sessions/\(sessionID)").removeValue()
                learnerRef.child("upcoming sessions/\(sessionID)").removeValue()
            })
            self.learnerName = session["learner name"] as? String
            self.upcomingSessionsIDs.remove(at: self.upcomingSessionsIDs.index(of: sessionID)!)
            self.upcomingSessions.removeValue(forKey: sessionID)
            
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
