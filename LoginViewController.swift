//
//  LoginViewController.swift
//  OnTheMap1.1
//
//  Created by Mahmoud Zakaria on 10/05/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Email.text = "saudiarabia.inquiry@gmail.com"
        //Email.text = "ing.mahmoudzakaria@gmail.com"
        Email.text = "mahmoud_zakaria@sas-se.com"
        Password.text = "Sas654321"
    }
    
     @IBAction func loginPressed(_ sender: AnyObject) {
        
        if Email.text!.isEmpty || Password.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else{
            setUIEnabled(false)
            UDBClient.sharedInstance().authenticateWithEmailAndPassword (Email: Email.text!, Password: Password.text!) { (success, errorString) in
                    if success! {
                        UDBClient.sharedInstance().getStudentLocation(accountKey: UDBClient.sharedInstance().accountKey) { (objectId, success, error) in
                            if success! {
                                UDBClient.sharedInstance().objectId = objectId
                            }
                            else
                            {
                                self.displayError(error)
                            }
                        }
                        performUIUpdatesOnMain {
                            self.completeLogin()
                        }
                    } else {
                        self.setUIEnabled(true)
                        self.displayError(errorString)
                    }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let url = URL(string: "https://auth.udacity.com/sign-up")!
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    // MARK: Login
    
    private func completeLogin() {
        
        setUIEnabled(true)
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        Email.isEnabled = enabled
        Password.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
}

