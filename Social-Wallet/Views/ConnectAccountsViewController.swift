//
//  ConnectAccountsViewController.swift
//  Social-Wallet
//
//  Created by Robert Chung on 10/22/18.
//  Copyright © 2018 Robert Chung. All rights reserved.
//

import UIKit
import TwitterKit
import KeychainAccess
import PinterestSDK
import FirebaseDatabase
import Firebase

/** Class to connect a user's accounts on multiple social media platforms. */
class ConnectAccountsViewController: UIViewController {
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting a reference to the Firebase Database.
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
        Attemps to connect to twitter's account and save the session to the application keychain.
    */
    @IBAction func twitterButtonPressed(_ sender: Any) {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                // Save userId to keychain so that we can use the Twitter API later on.
                // TODO: Save information to Firebase for lookup.
                // TODO: Might not be the right way to do it. Check here for more info: https://github.com/twitter/twitter-kit-ios/issues/61
                let keychain = Keychain(service: "twitter-login")
                if keychain["userId"] == nil {
                    print("----------------- Keychain DOES NOT have value ")
                    // Add twitter username for lookup to Firebase.
                    self.addKVToLoggedInUser(key: "twitterUsername", value: session!.userName)
                    
                    // Save "token" to keychain for API calls 
                    keychain["userId"] = session?.userID
                } else {
                    // TODO: UI work with disabling/changing how the button looks (?).
                    print("----------------- Keychain has value")
                    print(keychain["userId"]!)
                    
                }
                self.addKVToLoggedInUser(key: "twitterUsername", value: session!.userName)
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
    }
    
    /**
        Attemps to connec to Pinterest account and save the session to the application keychain.
    */
    @IBAction func pinterestButtonPressed(_ sender: Any) {
        print("pinterest Button Pressed")
        let permissions = [PDKClientWritePublicPermissions, PDKClientReadPublicPermissions, PDKClientReadRelationshipsPermissions, PDKClientWriteRelationshipsPermissions]
        PDKClient.sharedInstance().authenticate(withPermissions: permissions, from: self, withSuccess: { (success:PDKResponseObject!) -> Void in
            let user = success.user()
            self.addKVToLoggedInUser(key: "pinterestUsername", value: user!.username)
            
        }, andFailure: { (error) -> Void in
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
        
    }
    
    /**
        Adds a Key-Value pair to the current logged in user.
     @ param key: the key in the key-value pair
     @ param value: the value in the key-value pair
     TODO: Throw error instead of just printing?
    */
    fileprivate func addKVToLoggedInUser(key: String, value: String) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.ref.child("users").child(user!.uid).child(key).setValue(value)
            } else {
                print("User isn't logged into Firebase. Not saving key:value.")
            }
        }
    }


}
