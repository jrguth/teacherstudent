//
//  teacherViewConroller.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TeacherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var database: DatabaseReference!
    var userID: String!
    
    var mySkills: [String] = [""]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database.database().reference()
        database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
        
        let ref = self.database.child("users").child(self.userID).child("skills")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let skills = snapshot.value as! [String]
            self.mySkills = skills
            self.tableView.reloadData()
        }){(error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySkills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SkillTableViewCell =  self.tableView.dequeueReusableCell(withIdentifier: "SkillTableViewCell", for: indexPath) as! SkillTableViewCell
        cell.skillLabel.text = mySkills[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCellEditingStyle.delete {
            let skill = mySkills[indexPath.row]
            mySkills.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.database.child("users").child(self.userID).child("skills").setValue(mySkills)
            self.database.child("teachers").child(skill).child(self.userID).removeValue()
        }
    }
    
    @IBAction func unwindToTeacherView (sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SkillViewController, let skill = sourceViewController.selectedSkill {
            
            let newIndexPath = IndexPath(row: mySkills.count, section: 0)
            mySkills.append(skill)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            self.database.child("users").child(self.userID).child("skills").setValue(mySkills)
            
            
            let teacherRef = self.database.child("teachers").child(skill).child(self.userID)
            self.database.child("users").child(self.userID).observeSingleEvent(of: .value, with: {(snapshot) in
                let name = snapshot.childSnapshot(forPath: "name").value as! String
                let teacherRating = snapshot.childSnapshot(forPath: "teacher rating").value as! Double
                let teacherSessions = snapshot.childSnapshot(forPath: "teacher sessions").value as! Int
                
                teacherRef.child("name").setValue(name)
                teacherRef.child("teacher rating").setValue(teacherRating)
                teacherRef.child("teacher sessions").setValue(teacherSessions)
            }){(error) in
                print(error.localizedDescription)
            }
        }
    }
}
