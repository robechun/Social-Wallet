//
//  RegisterViewController.swift
//  Social-Wallet
//
//  Created by Robert Chung on 10/18/18.
//  Copyright © 2018 Robert Chung. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import LGButton
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var rePasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var createAccountButton: LGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        rePasswordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
        Delegate to handle text changes in the fields for signing up.
    */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case emailTextField:
            emailErrorHandler(textField);
        default:
            return true
        }
        
        return true
    }

    /**
        Provides the user with feedback on whether the email entered is correct or incorrect.
        Also disables the createAccount Button if incorrect.
    */
    private func emailErrorHandler(_ textField: UITextField) {
        if let text = textField.text {
            if (text.count < 3 || !text.contains("@")) {
                emailTextField.errorMessage = "Invalid Email"
                createAccountButton.isEnabled = false
            } else {
                emailTextField.errorMessage = "";
                createAccountButton.isEnabled = true
            }
        }
    }
    
    
    /**
        Creates a user in the Firebase account with Email/Password.
        The email is checked via the emailErrorHandler, so we don't check for that.
    */
    @IBAction func createAccountAction(_ sender: Any) {
        if passwordTextField.text != rePasswordTextField.text {
            // If the password doesn't match, doesn't create an account.
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please check your password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            // If the password matches, creates the account, but catches any errors that get thrown.
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "toMainView", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            })
        }
        
        
    }

}
