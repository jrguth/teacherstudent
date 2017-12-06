//
//  MessageViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var database: DatabaseReference!
    var conversationsRef: DatabaseReference!
    
    var conversationIDs: [String] = [String]()
    var conversations: Dictionary<String,String> = Dictionary<String,String>()
    var userID: String?
    
    var initialLoad: Bool!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        self.initialLoad = true
        self.userID = Auth.auth().currentUser?.uid
        
        self.conversationsRef = self.database.child("users/\(self.userID!)/conversations")
        
        self.conversationsRef.observe(.childAdded, with: {snapshot in

            let otherID = snapshot.key
            let otherName = snapshot.childSnapshot(forPath: "with").value as! String
            let conversationID = snapshot.childSnapshot(forPath: "conversation id").value as! String
            
            self.conversationIDs.append(conversationID)
            self.conversations[otherID] = otherName
            
            if (!self.initialLoad) {
                self.tableView.reloadData()
            }
        })
        
        self.conversationsRef.observeSingleEvent(of: .value, with: {snapshot in
            var conversationListIDs: [String] = [String]()
            var conversationList: Dictionary<String,String> = Dictionary<String,String>()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                let otherID = child.key
                let otherName = child.childSnapshot(forPath: "with").value as? String
                conversationList[otherID] = otherName!
                conversationListIDs.append((child.childSnapshot(forPath: "conversation id").value as? String)!)
            }
            self.conversations = conversationList
            self.conversationIDs = conversationListIDs
            self.tableView.reloadData()
            self.initialLoad = false
        })
        
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        self.database.observeSingleEvent(of: .value, with: {snapshot in
            
            if (snapshot.hasChild("users/\(self.userID!)/conversations")) {
                let conversationList = snapshot.childSnapshot(forPath: "users/\(self.userID!)/conversations").value as! Dictionary<String,String>
                self.conversationIDs = [String](conversationList.values)
                
                for id in conversationList.keys {
                    self.conversations[id] = snapshot.childSnapshot(forPath: "users/\(id)/name").value as? String
                }
                self.tableView.reloadData()
            }
        })
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ConversationTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCell", for: indexPath) as! ConversationTableViewCell
        
        if (self.conversations.count > 0) {
            let key = Array(self.conversations.keys)[indexPath.row]
            cell.infoLabel.text = "Conversation with " + self.conversations[key]!
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConversationViewController {
            let cell = sender as? ConversationTableViewCell
            let indexPath = tableView.indexPath(for: cell!)
            let id = self.conversationIDs[(indexPath?.row)!]
            
            destination.conversationID = id
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // testing
}



