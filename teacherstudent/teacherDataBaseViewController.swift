//
//  teacherDataBaseViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class teacherDataBaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var database: DatabaseReference!
    
    @IBOutlet weak var selectedSkillLabel: UILabel!
    
    var skill: String?
    var teacherList: [[String]] = [[String]]()
    
    var selectedTeacherID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.database = Database.database().reference()
        self.database.keepSynced(true)
    
        self.selectedSkillLabel.text = ("Teachers for "+(self.skill)!)
        
        let ref = database.child("teachers").child(self.skill!)
        ref.observeSingleEvent(of: .value, with:{snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                var teacher: [String] = [String]()
                teacher.append(child.childSnapshot(forPath: "name").value as! String)
                teacher.append(String(child.childSnapshot(forPath: "teacher rating").value as! Double))
                teacher.append(String(child.childSnapshot(forPath: "teacher sessions").value as! Int))
                teacher.append(child.key)
                
                self.teacherList.append(teacher)
            }
            self.tableView.reloadData()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TeacherTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TeacherTableViewCell", for: indexPath) as! TeacherTableViewCell
        
        cell.nameLabel.text = teacherList[indexPath.row][0]
        cell.ratingLabel.text = teacherList[indexPath.row][1] + " / 10"
        cell.completedSessionsLabel.text = teacherList[indexPath.row][2]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? TeacherProfileViewController
        let cell = sender as? TeacherTableViewCell
        let indexPath = tableView.indexPath(for: cell!)
        destination?.teacherUserID = teacherList[(indexPath?.row)!][3]
        destination?.skill = self.skill
        destination?.title = "Teacher profile"
    }
}

