//
//  StartViewController.swift
//  Social-Wallet
//
//  Created by Robert Chung on 10/17/18.
//  Copyright © 2018 Robert Chung. All rights reserved.
//

import UIKit

/** Delegate to perform segues to either register or login screens. */
class StartViewController: UIViewController {
    
    // Properties
    @IBAction func onRegisterButton(_ sender: Any) {
        performSegue(withIdentifier: "toRegisterSegue", sender: self);
    }
    @IBAction func onLoginButton(_ sender: Any) {
        performSegue(withIdentifier: "toLoginSegue", sender: self);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

