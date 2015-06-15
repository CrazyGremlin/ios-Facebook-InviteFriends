//
//  ViewController.swift
//  ios-Facebook-InviteFriends
//
//  Created by Michael Wittek on 06.05.15.
//  Copyright (c) 2015 Michael Wittek. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate, FBSDKGameRequestDialogDelegate  {
    
    var loginButton: FBSDKLoginButton?
    
    override func viewDidLoad() {
        print("called viewDidLoad")
        super.viewDidLoad()
        
        loginButton = FBSDKLoginButton(frame: CGRectMake(0, 400, 300, 100))
        loginButton!.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton!.delegate = self
        view.addSubview(loginButton!)
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            print("Token: \(token)")
            inviteFriends()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // FBSDKLoginButtonDelegate protocols
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("called loginButton")
        
        print(result)
        print(result.token)
        print(result.grantedPermissions)
        print(result.declinedPermissions)
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            print("Token: \(token)")
            inviteFriends()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("called loginButtonDidLogOut")
    }
    
    func inviteFriends() {
        
        FBSDKGraphRequest(graphPath: "/me/invitable_friends", parameters: nil).startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            print("called completition")
            print(result)
            
            var data : NSArray = result.objectForKey("data") as! NSArray
            
            var to = [String]()
            for i in 0...(data.count - 1) {
                let valueDict : NSDictionary = data[i] as! NSDictionary
                let id = valueDict.objectForKey("id") as! String
                to.append(id)
            }
            
            let content = FBSDKGameRequestContent()
            content.message = "Play with me!"
            content.title = "Great game"
            content.to = to
            content.actionType = FBSDKGameRequestActionType.None
            
            let dialog = FBSDKGameRequestDialog()
            dialog.frictionlessRequestsEnabled = false
            dialog.content = content
            dialog.delegate = self
            
            dialog.show()
        }
    }
    
    // FBSDKGameRequestDialogDelegate protocols
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("called gameRequestDialog")
    }
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!) {
        print("called gameRequestDialog")
    }
    
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
        print("called gameRequestDialogDidCancel")
    }
    
}

