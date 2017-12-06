//
//  pendingSessionsViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//


import UIKit
import Firebase

class PendingSessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var database: DatabaseReference!
    var receivedRef: DatabaseReference!
    var sentRef: DatabaseReference!
    
    var pendingReceivedSessionIDs: [String] = [String]()
    var pendingReceivedSessions: Dictionary<String,Dictionary<String,String>> = Dictionary<String,Dictionary<String,String>>()
    
    var pendingSentSessionIDs: [String] = [String]()
    var pendingSentSessions: Dictionary<String,Dictionary<String,String>> = Dictionary<String,Dictionary<String,String>>()

    var userID: String?
    
    var isUnwinding: Bool!
    var confirmed: Bool!
    var learnerName: String!
    var teacherName: String!
    
    var unwindType: PendingSessionsViewController.UnwindType!
    
    var initialLoad: Bool!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sentTableView: UITableView!
    
    enum UnwindType {
        case ConfirmRequest
        case CancelRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.initialLoad = true
        
        self.isUnwinding = false
        self.confirmed = false
        self.learnerName = ""
        
        self.userID = Auth.auth().currentUser?.uid
        
        self.database.observeSingleEvent(of: .value, with: {snapshot in
            
            if(snapshot.hasChild("users/\(self.userID!)/session requests")) {
                self.pendingReceivedSessionIDs = [String]((snapshot.childSnapshot(forPath: "users/\(self.userID!)/session requests").value as! Dictionary<String,String>).keys)
                for id in self.pendingReceivedSessionIDs {
                    let request = snapshot.childSnapshot(forPath: "session requests/\(id)").value as! Dictionary<String,String>
                    self.pendingReceivedSessions[id] = request
                }
                self.tableView.reloadData()
            }
            
            if(snapshot.hasChild("users/\(self.userID!)/sent requests")){
                self.pendingSentSessionIDs = [String]((snapshot.childSnapshot(forPath:"users/\(self.userID!)/sent requests").value as! Dictionary<String,String>).keys)
                for id in self.pendingSentSessionIDs {
                    let request = snapshot.childSnapshot(forPath: "session requests/\(id)").value as! Dictionary<String,String>
                    self.pendingSentSessions[id] = request
                }
                self.sentTableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(self.isUnwinding){
            
            switch (self.unwindType!) {
            case .ConfirmRequest:
                if(self.confirmed){
                    let alertController = UIAlertController(title: nil, message: "Your session with \(self.learnerName!) has been confirmed!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: nil, message: "You have successfully denied session request from \(self.learnerName!)", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case .CancelRequest:
                let alert = UIAlertController(title: nil, message: "Session request with \(self.teacherName!) has been cancelled.",
                    preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        self.isUnwinding = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return pendingReceivedSessionIDs.count
        } else if tableView == self.sentTableView {
            return self.pendingSentSessionIDs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = self.tableView.dequeueReusableCell(withIdentifier:"PendingSessionTableViewCell", for: indexPath) as! PendingSessionTableViewCell
            
            if(self.pendingReceivedSessionIDs.count > 0){
                let key = Array(self.pendingReceivedSessions.keys)[indexPath.row]
                cell.sessionInfoLabel.text = "Request from " + self.pendingReceivedSessions[key]!["learner name"]!
            }
            return cell
        } else if tableView == self.sentTableView {
            let cell = self.sentTableView.dequeueReusableCell(withIdentifier:"SentRequestTableViewCell", for: indexPath) as! SentRequestTableViewCell
            
            if(self.pendingSentSessionIDs.count > 0){
                let key = Array(self.pendingSentSessions.keys)[indexPath.row]
                cell.requestLabel.text = "Sent to " + self.pendingSentSessions[key]!["teacher name"]!
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConfirmSessionViewController {
            let cell = sender as? PendingSessionTableViewCell
            let indexPath = tableView.indexPath(for: cell!)
            let key = Array(self.pendingReceivedSessions.keys)[(indexPath?.row)!]
            
            destination.sessionID = key
            destination.pendingSession = self.pendingReceivedSessions[key]
        } else if let destination = segue.destination as? CancelRequestViewController {
            let cell = sender as? SentRequestTableViewCell
            let indexPath = sentTableView.indexPath(for: cell!)
            let key = [String](self.pendingSentSessions.keys)[(indexPath?.row)!]
            
            destination.sessionID = key
            destination.pendingSession = self.pendingSentSessions[key]
        }
    }
    
    @IBAction func unwindToPendingSessionsView (sender: UIStoryboardSegue){
        if let source = sender.source as? ConfirmSessionViewController {
            
            self.isUnwinding = true
            self.unwindType = .ConfirmRequest
            
            let confirmed: Bool = source.confirmed
            
            let pendingSession: Dictionary<String,String> = source.pendingSession
            let sessionID = source.sessionID
            self.learnerName = pendingSession["learner name"]
        
            if (confirmed) {
                self.confirmed = true
                let confirmedSessionsRef = self.database.child("confirmed sessions")
                let teacherRef = self.database.child("users").child(pendingSession["teacher id"]!)
                let learnerRef = self.database.child("users").child(pendingSession["learner id"]!)
                
                self.database.observeSingleEvent(of: .value, with: {snapshot in
                    
                    confirmedSessionsRef.child(sessionID!).setValue(pendingSession)
                    
                    teacherRef.child("upcoming sessions/\(sessionID!)").setValue("Teacher")
                    learnerRef.child("upcoming sessions/\(sessionID!)").setValue("Student")
                })
            } else {
                self.confirmed = false
            }
            self.database.child("users/\(pendingSession["teacher id"]!)/session requests/\(sessionID!)").removeValue()
            self.database.child("users/\(pendingSession["learner id"]!)/sent requests/\(sessionID!)").removeValue()

            self.database.child("session requests/\(sessionID!)").removeValue()
            
            let index = self.pendingReceivedSessionIDs.index(of: sessionID!)
            self.pendingReceivedSessionIDs.remove(at: index!)
            self.pendingReceivedSessions.removeValue(forKey: sessionID!)
            self.tableView.reloadData()
        }
        else if let source = sender.source as? CancelRequestViewController {
            
            self.isUnwinding = true
            self.unwindType = .CancelRequest
            
            let pendingSession: Dictionary<String,String> = source.pendingSession
            let sessionID = source.sessionID
            
            let requestsRef = self.database.child("session requests")
            let teacherRef = self.database.child("users/\(pendingSession["teacher id"]!)")
            let learnerRef = self.database.child("users/\(pendingSession["learner id"]!)")
            
            requestsRef.child(sessionID!).removeValue()
            teacherRef.child("session requests/\(sessionID!)").removeValue()
            learnerRef.child("sent requests/\(sessionID!)").removeValue()
            
            self.teacherName = pendingSession["teacher name"]!
            
            let index = self.pendingSentSessionIDs.index(of: sessionID!)
            self.pendingSentSessionIDs.remove(at: index!)
            self.pendingSentSessions.removeValue(forKey: sessionID!)
            
            self.sentTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
