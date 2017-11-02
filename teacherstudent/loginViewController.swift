//
//  loginViewController.swift
//  teacherstudent
//
//  Created by  macbook_user on 10/19/17.
//  Copyright © 2017  macbook_user. All rights reserved.
//

import UIKit
import Firebase
class loginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    @IBAction func forgotbutton(_ sender: UIButton) {
        performSegue(withIdentifier: "ForgotSegue", sender: self)
    }
    
    @IBAction func signupbutton(_ sender: UIButton) {
        performSegue(withIdentifier: "signupsegue", sender: self
        )
    }
    
    @IBAction func loginbutton(_ sender: UIButton) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully logged in")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MasterTabViewController")
                    self.present(vc!, animated: true, completion: nil)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
