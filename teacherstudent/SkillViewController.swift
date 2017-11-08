//
//  SkillViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation
import AddressBookUI
import CoreLocation

class SkillViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var selectedSkillLabel: UILabel!
    @IBOutlet weak var skillPickerView: UIPickerView!
    let locationmanger = CLLocationManager.init()
    var controlswitch = true
    var maxlatrange = 0.0
    var maxlongrange = 0.0
    var zipcode = 0
    var distance = 0.0
    var subject = ""
    
    var selectedSkill: String?
    
    var skills: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skills = ["Basketball", "Cooking", "Coding", "Mathematics", "Microsoft Office"]
        selectedSkill = skills[0]
        selectedSkillLabel.text = selectedSkill
          locationmanger.startUpdatingLocation()
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
    
    @IBAction func zipcodedistance(_ sender: UITextField) {
        
        distance = Double(sender.text!)!
        
    }
    func forwardGeocoding(address: String){
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                self.maxlongrange = (coordinate?.longitude)! as Double
                self.maxlatrange = (coordinate?.latitude)! as Double
                if (placemark?.areasOfInterest?.count)! > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
    @IBAction func zipcode(_ sender: UITextField) {
        
        forwardGeocoding(address: sender.text!)
        
        
    }
  
    @IBAction func dateandtime(_ sender: UIDatePicker) {
    }
    @IBAction func subjectlinebox(_ sender: UITextField) {
        subject = sender.text!
    }
    @IBAction func locationswitch(_ sender: UISwitch) {
        if(controlswitch)
        {
            locationmanger.delegate = self
            locationmanger.desiredAccuracy = 10
            
            print(locationmanger.location!)
            controlswitch = false
        }
        else{
            controlswitch = true
        }
    }
    
  
    // testing
}



