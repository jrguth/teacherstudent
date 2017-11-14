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
    
    @IBOutlet weak var teacherRatingLabel: UILabel!
    @IBOutlet weak var learnerRatingLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
        /*
        self.database.observeSingleEvent(of: .value, with: {snapshot in
            
            self.teacherRatingLabel.text = String(snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).childSnapshot(forPath: "teacher rating").value as! Double)
            self.learnerRatingLabel.text = String(snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).childSnapshot(forPath: "student rating").value as! Double)
    
            if (snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).hasChild("upcoming sessions")){
                let upcomingSessions: [String] = Array((snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).childSnapshot(forPath: "upcoming sessions").value as! Dictionary<String,String>).keys)
                self.upcomingSessionsIDs = upcomingSessions
                for id in self.upcomingSessionsIDs {
                    let session = snapshot.childSnapshot(forPath: "confirmed sessions").childSnapshot(forPath: id).value as! Dictionary<String,String>
                    self.upcomingSessions[id] = session
                }
                self.tableView.reloadData()
            }
        })*/
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
     self.database.observeSingleEvent(of: .value, with: {snapshot in
     
         self.teacherRatingLabel.text = String(snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).childSnapshot(forPath: "teacher rating").value as! Double)
         self.learnerRatingLabel.text = String(snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).childSnapshot(forPath: "student rating").value as! Double)
     
         if (snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: self.userID).hasChild("upcoming sessions")){
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
     })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingSessionsIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UpcomingSessionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier:"UpcomingSessionTableViewCell", for: indexPath) as! UpcomingSessionTableViewCell
        
        if(self.upcomingSessionsIDs.count > 0){
            let key = Array(self.upcomingSessions.keys)[indexPath.row]
            cell.infoLabel.text = "Session with " + self.upcomingSessions[key]!["other name"]!
        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
