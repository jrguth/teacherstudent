//
//  LearnViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class LearnViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var selectedSkillLabel: UILabel!
    @IBOutlet weak var skillsPickerView: UIPickerView!
    
    @IBOutlet weak var tableView: UIPickerView!
    var database: DatabaseReference!
    
    var selectedSkill: String!
    
    var skills: [String] = [String]()
    var teachersInfo: [[String]] = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Learn"
        
        skills = ["Basketball","Cooking","Coding","Mathematics","Microsoft Office"]
        selectedSkill = skills[0]
        selectedSkillLabel.text = selectedSkill
        
        database = Database.database().reference()
        database.keepSynced(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return skills.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return skills[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSkill = skills[row]
        selectedSkillLabel.text = selectedSkill
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? teacherDataBaseViewController{
            destinationVC.skill = self.selectedSkill!
            destinationVC.title = "Teachers for \(self.selectedSkill!)"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
