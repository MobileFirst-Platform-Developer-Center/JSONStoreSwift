//
//  Register.swift
//  JSONStoreSwift
//
//  Created by Saachi Ravindra Talwai on 6/27/18.
//  Copyright © 2018 IBM. All rights reserved.
//


/**
 * Copyright 2016 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import IBMMobileFirstPlatformFoundation

class LoginViewController: UIViewController {
    
    
    var displayName: String!
    
    @IBOutlet weak var registerMessage: UILabel!
    @IBOutlet weak var PreemptiveLogin: UINavigationItem!
  
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.username.text = ""
        self.password.text = ""
        
        
        
        
        // Add notifications observers
        NotificationCenter.default.addObserver(self, selector: #selector(registerSuccess), name: NSNotification.Name(rawValue: RegisterationNotificationKey), object: nil)
        
    }
    
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        
    }
    func toTouchID(alert: UIAlertAction!)
    {
        
        self.performSegue(withIdentifier: "RegisterToTouch", sender: nil)
        
        
    }
    // loginButtonClicked
   
    
    // RegisterSuccess (triggered by  RegisterationNotificationKey notification)
    
    
    @IBAction func RegisterButtonClicked(_ sender: Any) {
        
       
            
            
            let saveUsername: Bool = KeychainWrapper.standard.set(username.text!, forKey: "username")
            let savePassword : Bool  = KeychainWrapper.standard.set(password.text!, forKey: "password")
            print(savePassword)
            print(saveUsername)
            
            
            
            
            if(self.username.text != "" && self.password.text != ""){
                
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: RegisterationNotificationKey), object: nil)
                
            }
                
            else
            {
                
                self.registerMessage.text = "Please Enter Valid Details"
                
            }
            
        }
        
    
    
    func registerSuccess(){
        //let saveFlag: Bool = KeychainWrapper.standard.set(true, forKey:"Flag" )
        
        let alert = UIAlertController(title: "Successful",
                                      message: "Registered sucessfully\n You can now use TouchID",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: toTouchID))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    //cleanFieldsAndLabels (triggered by LoginFailure notification)
    
    
    // viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
}
