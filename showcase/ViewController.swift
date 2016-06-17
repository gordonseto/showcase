//
//  ViewController.swift
//  showcase
//
//  Created by Gordon Seto on 2016-06-16.
//  Copyright © 2016 Gordon Seto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailField: MaterialTextField!
    @IBOutlet weak var passwordField: MaterialTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {

    }

    @IBAction func attemptLogin(sender: AnyObject) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: {(user, error ) in
                if error != nil {
                    
                    print(error!.code)
                    if error!.code == STATUS_WRONG_PASSWORD {
                        self.showErrorAlert("Wrong password", msg: "You have entered an incorrect password")
                    }
                    
                    if error!.code == STATUS_ACCOUNT_NONEXIST {
                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
                            if let error = error {
                                print(error.localizedDescription)
                                self.showErrorAlert("Could not create account", msg: "Problem creating account.")
                                return
                            } else {
                                print(user!)
                                print(user!.uid)
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                    }
                } else {
                    print(user!.uid)
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })

        } else {
            showErrorAlert("Email and password required", msg: "You must enter an email and password")
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}

