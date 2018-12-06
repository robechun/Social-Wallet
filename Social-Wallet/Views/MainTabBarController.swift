//
//  MainTabBarController.swift
//  Social-Wallet
//
//  Created by Robert Chung on 10/25/18.
//  Copyright © 2018 Robert Chung. All rights reserved.
//

import UIKit

/** The main tab controller for both connecting accounts and looking up accounts to connect to. */
class MainTabBarController: UITabBarController {
    
    class func instantiate() -> MainTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "mainTabView") as! MainTabBarController
        
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
