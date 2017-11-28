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

class MessageViewController: UIViewController/*, UITableViewDelegate, UITableViewDataSource*/ {
    
    var database: DatabaseReference!
    
    var conversations: Dictionary<String,String> = Dictionary<String,String>()
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.database.observeSingleEvent(of: .value, with: {snapshot in
            if (snapshot.hasChild("users/\(self.userID!)/conversations")) {
                self.conversations = snapshot.childSnapshot(forPath: "users/\(self.userID!)/conversations").value as! Dictionary<String,String>
            }
        })
    }
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // testing
}



