//
//  ConversationViewController.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/28/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var database: DatabaseReference!
    var conversationRef: DatabaseReference!
    
    var userID: String!
    var conversationID: String!
    
    var conversation: [Dictionary<String,String>] = [Dictionary<String,String>]()
    
    var initialLoad: Bool!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
        
        self.conversationRef = self.database.child("conversations/\(self.conversationID!)")
        self.initialLoad = true
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        
        self.conversationRef.observe(.childAdded, with: {snapshot in
            var dict: [String: String]! = [String: String]()
            dict["message"] = snapshot.childSnapshot(forPath: "message").value as? String
            dict["sender"] = snapshot.childSnapshot(forPath: "sender").value as? String
            self.conversation.append(dict!)
            
            if (!self.initialLoad) {
                self.tableView.reloadData()
            }
        })
        
        self.conversationRef.observeSingleEvent(of: .value, with: {snapshot in
            var messages: [Dictionary<String,String>] = [Dictionary<String,String>]()
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                let message = child.value as! Dictionary<String,String>
                messages.append(message)
            }
            self.conversation = messages
            self.tableView.reloadData()
            self.initialLoad = false
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        
        let message = self.conversation[indexPath.row]
            
        let text = message["message"]
        if (self.userID == message["sender"]){
            cell.sentLabel.text = text!
            cell.receivedLabel.isHidden = true
        } else {
            cell.receivedLabel.text = text!
            cell.sentLabel.isHidden = true
        }
        
        cell.receivedLabel.sizeToFit()
        cell.sentLabel.sizeToFit()
        
        
        return cell
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let messageText = self.messageTextField.text!
        if !messageText.isEmpty {
            let message = ["message": messageText, "sender": self.userID!]
            self.conversationRef.childByAutoId().setValue(message)
            self.messageTextField.text = ""
        } else {
            let alert = UIAlertController(title: nil, message: "please enter text to send a message", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated:true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
