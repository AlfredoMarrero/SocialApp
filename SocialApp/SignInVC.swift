//
//  SignInVC.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/7/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { result, error in
                      print(result.debugDescription)
            if error != nil {
                print("Error: Unable to authenticate with Facebook.")
            } else if result?.isCancelled == true {
                print ("User cancelled Facebook authentication.")
            } else {
                print ("Successfully authentucated with Facebook.")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
    }

    func firebaseAuthenticate(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: {user, error in
            if error != nil {
                print("Error: Unable to authenticate with Firebase - \(error)")
            } else {
                print ("Successfully authenticated with Firebase.")
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    print ("Message: Email user authenticated with firebase.")
                }
                else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                print (error.debugDescription)
                                print ("Message: Unable to authenticate with firebase using email.")
    
                            } else {
                                print ("Message: Successfully authenticate with Firebase.")
                            
                            }
                        })
                
                }
                
            })
        }
    }
    
    
    
}

