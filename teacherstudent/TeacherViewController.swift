//
//  teacherViewConroller.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import Foundation
import UIKit

class TeacherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mySkills: [String] = ["Test"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            mySkills.remove(at: indexPath.row)
        }
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func unwindToTeacherView (sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SkillViewController, let skill = sourceViewController.selectedSkill {
            
            let newIndexPath = IndexPath(row: mySkills.count, section: 0)
            mySkills.append(skill)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableViewController = segue.destination as? MySkillsTableViewController {
            self.tableViewController = tableViewController
        }
    }
     */
}
