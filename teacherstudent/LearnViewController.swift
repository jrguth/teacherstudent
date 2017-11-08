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
import AddressBookUI
import CoreLocation

class LearnViewController: UIViewController , CLLocationManagerDelegate{
    let locationmanger = CLLocationManager.init()
    var controlswitch = true
    var maxlatrange = 0.0
    var maxlongrange = 0.0
    var zipcode = 0
    var distance = 0.0
    var subject = ""
    override func viewDidLoad() {
        //var Database:
    
      locationmanger.startUpdatingLocation()
       // Database = Database.database().reference()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
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
    @IBAction func distance(_ sender: UITextField) {
       let area = Double(sender.text!)!
        //maxlatrange = (locationmanger.location?.coordinate.latitude)! as Double
        
        
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
