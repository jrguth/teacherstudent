//
//  LearnViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import Foundation
import UIKit

import CoreLocation

class LearnViewController: UIViewController , CLLocationManagerDelegate{
    let locationmanger = CLLocationManager.init()
    var controlswitch = true
    var maxlatrange = 0.0
    var maxlongrange = 0.0
    var minlongrange = 0.0
    var minlatrange = 0.0
    var zipcode = 0
    var subject = ""
    override func viewDidLoad() {
        //var Database:
    
      locationmanger.startUpdatingLocation()
       // Database = Database.database().reference()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
  
   
    @IBAction func zipcodedistance(_ sender: UITextField) {
       
        
        
        
    }
    @IBAction func zipcode(_ sender: UITextField) {
        zipcode = Int(sender.text!)!
        
    }
    @IBAction func distance(_ sender: UITextField) {
        let area = Double(sender.text!)!
        maxlatrange = (locationmanger.location?.coordinate.latitude)! as Double
        
        maxlongrange = (locationmanger.location?.coordinate.longitude)!
        minlongrange = maxlatrange - area
        minlatrange = maxlatrange - area
        maxlatrange = maxlatrange + area
        maxlatrange = maxlongrange + area
        
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
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // testing
}
