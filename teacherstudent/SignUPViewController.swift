//
//  SignUPViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit
import Firebase

class SignUPViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    var database: DatabaseReference!
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user: User?, error) in
            if error == nil {
                self.labelMessage.text = "You are successfully registered"
                self.database.child("users").child((user?.uid)!).setValue(["name": self.nameTextField.text])
            } else{
                self.labelMessage.text = "Registration failed... please try again"
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        database = Database.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // testing
}
