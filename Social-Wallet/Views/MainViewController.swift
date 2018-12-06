//
//  MainViewController.swift
//  Social-Wallet
//
//  Created by Robert Chung on 10/26/18.
//  Copyright © 2018 Robert Chung. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import FirebaseDatabase
import PopupDialog
import TwitterKit
import PinterestSDK

/** The View in which a user can connect to another user. */
class MainViewController: UIViewController {
    @IBOutlet weak var userTextField: SkyFloatingLabelTextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Getting a reference to the Firebase Database.
        ref = Database.database().reference()
        
        // Dismiss keyboard
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
        Attempts to find friend in the database and creates a modal
        that is dependent on the platforms that it can connect with.
    */
    @IBAction func findFriendButtonPressed(_ sender: Any) {
        var connections: [String: String] = [:]
        
        self.ref.child("username_to_uid")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let value = snapshot.value as? NSDictionary
                    let userLookup = self.userTextField.text!
                    if let uid = value?[userLookup] as? String {
                        self.ref.child("users").child(uid)
                            .observeSingleEvent(of: .value, with: { (snapshot2) in
                                if snapshot.exists() {
                                    let validConnections = snapshot2.value as? NSDictionary
                                    connections.updateValue(validConnections?["twitterUsername"] as? String ?? "", forKey: "twitter")
                                    connections.updateValue(validConnections?["pinterestUsername"] as? String ?? "", forKey: "pinterest")
                                }
                                
                                let popup = self.createPopup(connections: connections)
                                self.present(popup, animated: true, completion: nil)
                            })
                    }
                }
        })
        
        
    }
    
    /**
        Attemps to log the user out of all sessions, including the auth session.
    */
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        
            // TODO NOT RIGHT
            let user = TWTRTwitter.sharedInstance().sessionStore.session()?.userID
            TWTRTwitter.sharedInstance().sessionStore.logOutUserID(user!)
        
            PDKClient.sharedInstance()?.session.flush {
                //
            }
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error Signing out: %@", signOutError)
        }
    }
    
    /**
        Creates the popup needed for connection.
        Varies based on the different social-media accounts it has access to.
     @ param connections: list of available connections.
     @ returns PopupDialog: The UI component that gets rendered to connect with users.
    */
    func createPopup(connections: [String: String]) -> PopupDialog {
        let title = "Add Connections"
        let message = "Click the buttons to add connections"
        
        let popup = PopupDialog(title: title, message: message)
        
        // Buttons for connections
        if (connections["twitter"] != "" && connections["twitter"] != nil) {
            print("--------------TEStING:    " + connections["twitter"]!)
            let twitterButton = DefaultButton(title: "Follow on Twitter") {
                print("one")
                if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
                    print("two")
                    let client = TWTRAPIClient(userID: userID)
                    let followEndpoint = "https://api.twitter.com/1.1/friendships/create.json"
                    let params = ["screen_name" : connections["twitter"]]
                    var clientError: NSError?
                    print("three")
                    let request = client.urlRequest(withMethod: "POST", urlString: followEndpoint, parameters: params, error: &clientError)
                    print("four")
                    client.sendTwitterRequest(request, completion: { (response, data, connectionError) -> Void in
                        if connectionError != nil {
                            print("five")
                            print("Error: \(connectionError)")
                        }
                        print("six")
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: [])
                            // TODO let user know it was successful
                            print("json: \(json)")
                        } catch let jsonError as NSError {
                            print("json error: \(jsonError.localizedDescription)")
                        }
                    })
                    
                }
            }
            popup.addButton(twitterButton)
        }
        
        if (connections["pinterest"] != "") {
            let pinterestButton = DefaultButton(title: "Follow on Pinterest") {
                if let pinterestClient = PDKClient.sharedInstance() {
                    let followEndpoint = "https://api.pinterest.com/v1/me/following/users/"
                    let params = ["user" : connections["pinterest"]]
                    
                    pinterestClient.postPath(followEndpoint, parameters: params, withSuccess: { (success:PDKResponseObject!) -> Void in
                        let alertController = UIAlertController(title: "Success", message: "Successfully followed user", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }, andFailure: { (error) -> Void in
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    })
                }
            }
            popup.addButton(pinterestButton)
        }
        
        return popup
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
