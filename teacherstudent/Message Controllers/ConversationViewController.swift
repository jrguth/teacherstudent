//
//  ConversationViewController.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/28/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var database: DatabaseReference!
    
    var userID: String!
    var conversationID: String!
    
    var conversation: [Dictionary<String,String>] = [Dictionary<String,String>]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
        
        refreshMessages()
    }

    private func refreshMessages() {
        self.database.child("conversations/\(self.conversationID!)").observeSingleEvent(of: .value, with: {snapshot in
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                let message = child.value as! Dictionary<String,String>
                self.conversation.append(message)
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        
        for message in self.conversation {
            let text = message["message"]
            if (self.userID == message["sender"]){
                cell.sentLabel.text = text!
                cell.receivedLabel.isHidden = true
            } else {
                cell.receivedLabel.text = text!
                cell.sentLabel.isHidden = true
            }
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
