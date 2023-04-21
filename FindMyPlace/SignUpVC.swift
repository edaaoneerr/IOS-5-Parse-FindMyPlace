//
//  ViewController.swift
//  FindMyPlace
//
//  Created by Eda Oner on 20.04.2023.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }

    @IBAction func signInClicked(_ sender: Any) {
        if usernameText != nil && passwordText != nil {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) {
                user, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Sign In Error")
                } else {
                    // segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else {
            makeAlert(title: "OK", message: "Error")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if usernameText != nil && passwordText != nil {
            let user = PFUser()
            user.username = usernameText.text!
            user.password  = passwordText.text!
            
            user.signUpInBackground {
                success, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "You can not sign up.")
                } else {
                    // segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else {
            makeAlert(title: "OK", message: "Error")
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

