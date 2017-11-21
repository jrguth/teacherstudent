//
//  SentRequestsViewController.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/20/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit
import Firebase

class SentRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var database: DatabaseReference!
    var userID: String?
    
    var isUnwinding: Bool!
    var teacherName: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    var pendingSessionIDs: [String] = [String]()
    var pendingSessions: Dictionary<String,Dictionary<String,String>> = Dictionary<String,Dictionary<String,String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
        self.isUnwinding = false
        
        self.database.observeSingleEvent(of: .value, with: {snapshot in
            
            if(snapshot.hasChild("users/\(self.userID!)/sent requests")){
                self.pendingSessionIDs = [String]((snapshot.childSnapshot(forPath:"users/\(self.userID!)/sent requests").value as! Dictionary<String,String>).keys)
                for id in self.pendingSessionIDs {
                    let request = snapshot.childSnapshot(forPath: "session requests/\(id)").value as! Dictionary<String,String>
                    self.pendingSessions[id] = request
                }
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.isUnwinding) {
            let alert = UIAlertController(title: nil, message: "Session request with \(self.teacherName!) has been cancelled.",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        self.isUnwinding = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pendingSessionIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SentRequestTableViewCell = self.tableView.dequeueReusableCell(withIdentifier:"SentRequestTableViewCell", for: indexPath) as! SentRequestTableViewCell
        
        if(self.pendingSessionIDs.count > 0){
            let key = Array(self.pendingSessions.keys)[indexPath.row]
            cell.requestLabel.text = "Session request sent to " + self.pendingSessions[key]!["teacher name"]!
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CancelRequestViewController {
            let cell = sender as? SentRequestTableViewCell
            let indexPath = tableView.indexPath(for: cell!)
            let key = [String](self.pendingSessions.keys)[(indexPath?.row)!]
            
            destination.sessionID = key
            destination.pendingSession = self.pendingSessions[key]
        }
    }
    
    @IBAction func unwindToSentRequestsView (sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? CancelRequestViewController {
            
            self.isUnwinding = true
            
            let pendingSession: Dictionary<String,String> = sourceVC.pendingSession
            let sessionID: String = sourceVC.sessionID
            
            let requestsRef = self.database.child("session requests")
            let teacherRef = self.database.child("users/\(pendingSession["teacher id"]!)")
            let learnerRef = self.database.child("users/\(pendingSession["learner id"]!)")
            
            requestsRef.child(sessionID).removeValue()
            teacherRef.child("session requests/\(sessionID)").removeValue()
            learnerRef.child("sent requests/\(sessionID)").removeValue()
            
            self.teacherName = pendingSession["teacher name"]!
            
            let index: Int = self.pendingSessionIDs.index(of: sessionID)!
            self.pendingSessionIDs.remove(at: index)
            self.pendingSessions.removeValue(forKey: sessionID)
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
