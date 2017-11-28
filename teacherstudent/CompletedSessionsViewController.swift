//
//  CompletedSessionsViewController.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/26/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit
import Firebase

class CompletedSessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var database: DatabaseReference!
    var userID: String?
    var teacherName: String?
    
    var completedSessionIDs: [String] = [String]()
    var completedSessions: Dictionary<String,Dictionary<String,Any>> = Dictionary<String,Dictionary<String,Any>>()
    
    @IBOutlet weak var tableView: UITableView!
    
    var isUnwinding: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
        
        self.isUnwinding = false
        
        self.database.observeSingleEvent(of: .value, with: {snapshot in
            if(snapshot.hasChild("users/\(self.userID!)/sessions pending completion")){
                self.completedSessionIDs = [String]((snapshot.childSnapshot(forPath: "users/\(self.userID!)/sessions pending completion").value as! Dictionary<String,String>).keys)
                for id in self.completedSessionIDs {
                    let session = snapshot.childSnapshot(forPath: "completed sessions/\(id)").value as! Dictionary<String,Any>
                    self.completedSessions[id] = session
                }
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.isUnwinding) {
            let alert = UIAlertController(title: nil, message: "Session with \(self.teacherName!) has been finalized.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        self.isUnwinding = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completedSessionIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CompletedSessionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CompletedSessionTableViewCell", for: indexPath) as! CompletedSessionTableViewCell
        
        if(self.completedSessionIDs.count > 0){
            let key = Array(self.completedSessions.keys)[indexPath.row]
            cell.infoLabel.text = "Session completed by \(self.completedSessions[key]!["teacher name"] as! String). Tap to finalize"
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FinalizeSessionViewController {
            let cell = sender as? CompletedSessionTableViewCell
            let indexPath = tableView.indexPath(for: cell!)
            let key = [String](self.completedSessions.keys)[(indexPath?.row)!]
            
            destination.sessionID = key
            destination.session = self.completedSessions[key]
        }
    }
    
    @IBAction func unwindToCompletedSessions (sender: UIStoryboardSegue) {
        if let source = sender.source as? FinalizeSessionViewController {
            self.isUnwinding = true
            
            let rating: Double = source.rating!
            let sessionID: String = source.sessionID
            var session: Dictionary<String,Any> = source.session as Dictionary<String,Any>
            
            let learnerRef = self.database.child("users/\(session["learner id"]!)")
            let teacherRef = self.database.child("users/\(session["teacher id"]!)")
            let teacherRatingRef = self.database.child("teachers/\(session["skill"]!)/\(session["teacher id"]!)")
            let completedSessionRef = self.database.child("completed sessions/\(sessionID)")
            let confirmedSessionRef = self.database.child("confirmed sessions")
            
            self.database.observeSingleEvent(of: .value, with: {snapshot in
                let sumTeacherRatings = snapshot.childSnapshot(forPath: "users/\(session["teacher id"] as! String)/sum teacher ratings").value as! Double + rating
                let numSessions = snapshot.childSnapshot(forPath: "users/\(session["teacher id"] as! String)/teacher sessions").value as! Int + 1
                
                teacherRef.child("teacher sessions").setValue(numSessions)
                teacherRef.child("sum teacher ratings").setValue(sumTeacherRatings)
                
                teacherRatingRef.child("teacher sessions").setValue(numSessions)
                teacherRatingRef.child("teacher rating").setValue(Double(sumTeacherRatings / Double(numSessions)))
                
                teacherRef.child("teacher rating").setValue(Double(sumTeacherRatings / Double(numSessions)))
                
                session["teacher rating"] = rating
                completedSessionRef.setValue(session)
                
                learnerRef.child("sessions pending completion/\(sessionID)").removeValue()
                
                confirmedSessionRef.child(sessionID).removeValue()
            })
            self.teacherName = session["teacher name"] as? String
            self.completedSessionIDs.remove(at: self.completedSessionIDs.index(of: sessionID)!)
            self.completedSessions.removeValue(forKey: sessionID)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
