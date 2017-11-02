//
//  SkillViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//


import Foundation
import UIKit

class SkillViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var selectedSkillLabel: UILabel!
    @IBOutlet weak var skillPickerView: UIPickerView!
    
    var selectedSkill: String?
    
    var skills: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skills = ["Basketball", "Cooking", "Coding", "Mathematics", "Microsoft Office"]
        selectedSkill = skills[0]
        selectedSkillLabel.text = selectedSkill
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
}
