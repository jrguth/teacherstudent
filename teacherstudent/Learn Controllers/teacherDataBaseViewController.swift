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
import CoreLocation

class teacherDataBaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var database: DatabaseReference!
    var userID: String!
    var mylat:Double!
    var myLong:Double!
    var locationManager = CLLocationManager.init()
    
    @IBOutlet weak var selectedSkillLabel: UILabel!
    
    var skill: String?
    var teacherList: [[String]] = [[String]]()
    var messagchecker: [Bool] = [Bool]()
    
    var selectedTeacherID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.database = Database.database().reference()
        self.database.keepSynced(true)
    
        self.userID = Auth.auth().currentUser?.uid
        
        self.selectedSkillLabel.text = ("Teachers for "+(self.skill)!)
        
        let ref = database.child("teachers").child(self.skill!)
        ref.observeSingleEvent(of: .value, with:{snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                var teacher: [String] = [String]()
                if(child.key != self.userID){
                    teacher.append(child.childSnapshot(forPath: "name").value as! String)
                    teacher.append(String(child.childSnapshot(forPath: "teacher rating").value as! Double))
                    teacher.append(String(child.childSnapshot(forPath: "teacher sessions").value as! Int))
                    //APPEND TEACHER LOCATION HERE
                    //teacher.append(String(child.childSnapshot(forPath: "teacher location").value as! String))
                    teacher.append(child.key)
                    self.messagchecker.append(true)
                    
                    self.teacherList.append(teacher)
                }
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
        
        cell.nameLabel.text = teacherList[indexPath.row][2]
        cell.ratingLabel.text = teacherList[indexPath.row][3] + " / 10"
        cell.completedSessionsLabel.text = teacherList[indexPath.row][4]
        let templat = Double(teacherList[indexPath.row][0])
        let templong = Double(teacherList[indexPath.row][1])
    
    
        let templocation = CLLocation.init(latitude: templat!,  longitude: templong! )
        //ADD DISTANCE LABEL HERE
        cell.DIstanceLabel.text = String(describing: locationManager.location?.distance(from: templocation))
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? TeacherProfileViewController
        let cell = sender as? TeacherTableViewCell
        let indexPath = tableView.indexPath(for: cell!)
        destination?.teacherUserID = teacherList[(indexPath?.row)!][3]
        destination?.skill = self.skill
        destination?.title = "Teacher profile"
        destination?.isMEssagable = messagchecker[(indexPath?.row)!]
        
    }
}

