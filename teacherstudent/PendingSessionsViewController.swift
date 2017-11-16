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
    var pendingSessionIDs: [String] = [String]()
    var pendingSessions: Dictionary<String,Dictionary<String,String>> = Dictionary<String,Dictionary<String,String>>()
    var userID: String?
    
    var isUnwinding: Bool!
    var confirmed: Bool!
    var learnerName: String!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.title = "Pending Sessions"
        
        self.isUnwinding = false
        self.confirmed = false
        self.learnerName = ""
        
        self.userID = Auth.auth().currentUser?.uid
        
        database.observeSingleEvent(of: .value, with: {snapshot in
            
            if(snapshot.hasChild("users/\(self.userID!)/session requests")){
                self.pendingSessionIDs = snapshot.childSnapshot(forPath:"users/\(self.userID!)/session requests").value as! [String]
                for id in self.pendingSessionIDs {
                    let request = snapshot.childSnapshot(forPath: "session requests/\(id)").value as! Dictionary<String,String>
                    //request["session id"] = id
                    self.pendingSessions[id] = request
                }
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(self.isUnwinding){
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
        }
        self.isUnwinding = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingSessionIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PendingSessionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier:"PendingSessionTableViewCell", for: indexPath) as! PendingSessionTableViewCell
        
        if(self.pendingSessionIDs.count > 0){
            let key = Array(self.pendingSessions.keys)[indexPath.row]
            cell.sessionInfoLabel.text = "Session request from " + self.pendingSessions[key]!["learner name"]!
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConfirmSessionViewController {
            let cell = sender as? PendingSessionTableViewCell
            let indexPath = tableView.indexPath(for: cell!)
            let key = Array(self.pendingSessions.keys)[(indexPath?.row)!]
            
            destination.sessionID = key
            destination.pendingSession = self.pendingSessions[key]
        }
    }
    
    @IBAction func unwindToPendingSessionsView (sender: UIStoryboardSegue){
        if let source = sender.source as? ConfirmSessionViewController {
            
            self.isUnwinding = true
            
            let confirmed: Bool = source.confirmed
            
            let pendingSession: Dictionary<String,String> = source.pendingSession
            let sessionID = source.sessionID
            self.learnerName = pendingSession["learner name"]
            
            let pendingSessionsRef = self.database.child("session requests")
            
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
            let requestsRef = self.database.child("users").child(pendingSession["teacher id"]!)
            requestsRef.child("session requests").observeSingleEvent(of: .value, with: {snapshot in
                var requests: [String] = snapshot.value as! [String]
                let index = requests.index(of: sessionID!)
                requests.remove(at: index!)
                requestsRef.child("session requests").setValue(requests)
            })
            
            pendingSessionsRef.child(sessionID!).removeValue()
            
            let index = self.pendingSessionIDs.index(of: sessionID!)
            self.pendingSessionIDs.remove(at: index!)
            self.pendingSessions.removeValue(forKey: sessionID!)
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
