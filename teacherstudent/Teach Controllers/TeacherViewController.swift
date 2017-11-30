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
    var isUnwinding: Bool!
    var alreadyAdded: Bool!
    
    var mySkills: Dictionary<String,String> = Dictionary<String,String>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.isUnwinding = false
        self.alreadyAdded = false
        
        self.userID = Auth.auth().currentUser?.uid
        
        let ref = self.database.child("users").child(self.userID)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.hasChild("skills"))
            
            if snapshot.hasChild("skills"){
                let skills = snapshot.childSnapshot(forPath: "skills").value as! Dictionary<String,String>
                self.mySkills = skills
                self.tableView.reloadData()
            }
        }){(error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.isUnwinding){
            if (!self.alreadyAdded){
                let alert = UIAlertController(title: nil, message: "Skill successfully added!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: nil, message: "You are already a teacher for that skill!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.isUnwinding = false
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
        
        let skill = Array(self.mySkills.keys)[indexPath.row]
        cell.skillLabel.text = skill
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let skill = Array(self.mySkills.keys)[indexPath.row]
            
            self.mySkills.removeValue(forKey: skill)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.database.child("users").child(self.userID).child("skills").setValue(mySkills)
            self.database.child("teachers").child(skill).child(self.userID).removeValue()
        }
    }
    
    @IBAction func unwindToTeacherView (sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SkillViewController, let skill = sourceViewController.selectedSkill {
            
            self.isUnwinding = true
            
            if (!self.mySkills.keys.contains(skill)){
                self.alreadyAdded = false
                let newIndexPath = IndexPath(row: mySkills.count, section: 0)
                
                // ADD LOCATION HERE: string value of lat long either from address or their location
                self.mySkills[skill] = "location"
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
                    
                    
                    teacherRef.child("Lat").setValue(sourceViewController.lat)
                    teacherRef.child("Long").setValue(sourceViewController.long)
                    
                    //ADD TEACHER LAT LONG VALUE HERE
                    //teacherRef.child("teacher location").setValue(LATLONGASSTRING)
                }){(error) in
                    print(error.localizedDescription)
                }
                self.tableView.reloadData()
            } else {
                self.alreadyAdded = true
            }
        }
    }
}
