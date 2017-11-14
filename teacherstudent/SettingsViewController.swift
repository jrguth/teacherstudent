//
//  SettingsViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    var database: DatabaseReference!
    var userID: String!
    var availability: Dictionary<String,String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database().reference()
        self.database.keepSynced(true)
        
        self.userID = Auth.auth().currentUser?.uid
        
        let ref = self.database.child("users").child(self.userID).child("availability")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            self.availability = snapshot.value as! Dictionary<String,String>
            self.updateAvailability()
        })
        
        
    }
    
    private func updateAvailability(){
        self.mondayLabel.text = self.availability["Monday"]
        self.tuesdayLabel.text = self.availability["Tuesday"]
        self.wednesdayLabel.text = self.availability["Wednesday"]
        self.thursdayLabel.text = self.availability["Thursday"]
        self.fridayLabel.text = self.availability["Friday"]
        self.saturdayLabel.text = self.availability["Saturday"]
        self.sundayLabel.text = self.availability["Sunday"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController")
                present(vc, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? EditSettingsViewController{
            destinationVC.dict = self.availability
        }
    }
    
    @IBAction func unwindToSettingsView (sender: UIStoryboardSegue){
        self.database.child("users").child(self.userID).child("availability").setValue(self.availability)
        updateAvailability()
    }
}
