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
    
    var conversations: Dictionary<String,String> = Dictionary<String,String>()
    var userID: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        self.database.observeSingleEvent(of: .value, with: {snapshot in
            print(snapshot.childSnapshot(forPath: "users/\(self.userID!)/conversations"))
            
            if (snapshot.hasChild("users/\(self.userID!)/conversations")) {
                self.conversations = snapshot.childSnapshot(forPath: "users/\(self.userID!)/conversations").value as! Dictionary<String,String>
                self.tableView.reloadData()
            }
        })
        
    }
    
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
            let id = Array(self.conversations.keys)[(indexPath?.row)!]
            
            destination.conversationID = id
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // testing
}



