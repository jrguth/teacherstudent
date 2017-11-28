//
//  EditSettingsViewController.swift
//  teacherstudent
//
//  Created by Jacob Guth on 11/8/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit

class EditSettingsViewController: UIViewController {

    var dict: Dictionary<String,String>!

    @IBOutlet weak var mondayTextField: UITextField!
    @IBOutlet weak var tuesdayTextField: UITextField!
    @IBOutlet weak var wednesdayTextField: UITextField!
    @IBOutlet weak var thursdayTextField: UITextField!
    @IBOutlet weak var fridayTextField: UITextField!
    @IBOutlet weak var saturdayTextField: UITextField!
    @IBOutlet weak var sundayTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mondayTextField.text = self.dict["Monday"]
        self.tuesdayTextField.text = self.dict["Tuesday"]
        self.wednesdayTextField.text = self.dict["Wednesday"]
        self.thursdayTextField.text = self.dict["Thursday"]
        self.fridayTextField.text = self.dict["Friday"]
        self.saturdayTextField.text = self.dict["Saturday"]
        self.sundayTextField.text = self.dict["Sunday"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SettingsViewController
        
        self.dict["Monday"] = self.mondayTextField.text!
        self.dict["Tuesday"] = self.tuesdayTextField.text!
        self.dict["Wednesday"] = self.wednesdayTextField.text!
        self.dict["Thursday"] = self.thursdayTextField.text!
        self.dict["Friday"] = self.fridayTextField.text!
        self.dict["Saturday"] = self.saturdayTextField.text!
        self.dict["Sunday"] = self.sundayTextField.text!
        
        destinationVC.availability = self.dict
    }
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
