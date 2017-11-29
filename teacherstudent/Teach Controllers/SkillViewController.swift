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
        return self.skills.count
    }
    
    @IBAction func locationservicesswitch(_ sender: UISwitch) {
        if sender.isOn{
            
        }
    }
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var Distance: UITextField!
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.skills[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedSkill = skills[row]
        self.selectedSkillLabel.text = selectedSkill
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
