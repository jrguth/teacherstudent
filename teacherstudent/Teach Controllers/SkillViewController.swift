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

class SkillViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var selectedSkillLabel: UILabel!
    @IBOutlet weak var skillPickerView: UIPickerView!
    var lat:String!
    var long:String!
    var locationManager = CLLocationManager.init()
    
    var selectedSkill: String?
    
    var skills: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        skills = ["sports","Basketball","hockey","football","baseball","tennis" ,"Cooking", "Coding", "Mathematics", "Microsoft Office","Java","swift","physics","English","French","German","Spanish",]
        selectedSkill = skills[0]
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        //selectedSkillLabel.text = selectedSkill
      
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
            long = String(describing: locationManager.location?.coordinate.latitude)
            lat  = String(describing: locationManager.location?.coordinate.longitude)
            print(lat)
            print(long)
        }
    }
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var Distance: UITextField!
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.skills[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedSkill = skills[row]
        //self.selectedSkillLabel.text = selectedSkill
    }
    
    @IBAction func distancefromme(_ sender: UITextField) {
    }
    @IBAction func distancetozip(_ sender: UITextField) {
    }
    @IBAction func zipcode(_ sender: UITextField) {
        getCoordinate(addressString: sender.text!)
    }
    func getCoordinate( addressString : String)
 {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressString) { (placemarks, error) in
    if error == nil {
    if let placemark = placemarks?[0] {
        self.lat = String(describing: placemark.location!.coordinate.latitude)
        self.long = String(describing: placemark.location!.coordinate.longitude)

        print(self.long)
        print(self.lat)
    
        }}}
    }
  
    @IBOutlet weak var togeoccodetext: UITextField!
    @IBAction func geocode(_ sender: UIButton) {
        getCoordinate(addressString: togeoccodetext.text!)
    }
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
