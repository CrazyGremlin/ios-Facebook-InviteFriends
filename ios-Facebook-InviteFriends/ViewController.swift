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

class ViewController: UIViewController, FBLoginViewDelegate, FBSDKGameRequestDialogDelegate {
    
    override func viewDidLoad() {
        println("called viewDidLoad")
        super.viewDidLoad()

        let fbLoginView = FBLoginView(frame: CGRectMake(0, 0, 300, 100))
        fbLoginView.backgroundColor = UIColor.redColor()
        fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        fbLoginView.delegate = self
        
        view.addSubview(fbLoginView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // FBLoginViewDelegate protocols
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("called loginView")
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        println("called loginViewFetchedUserInfo")
        
        println(user)
        println(user.objectForKey("id"))
        
        let text = UILabel(frame: CGRectMake(0, 100, 300, 20))
        let name = user.objectForKey("name") as! String
        text.text = "Welcome \(name)"
        
        view.addSubview(text)
        
        let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(0, 130, 100, 50)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Invite friends", forState: UIControlState.Normal)
        button.addTarget(self, action: "inviteFriends:", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button)
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("called loginViewShowingLoggedInUser")
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        println("called loginViewShowingLoggedOutUser")
    }
    
    
    func inviteFriends(sender: AnyObject) {
        FBRequestConnection.startWithGraphPath("/me/invitable_friends", completionHandler: {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            println("Result \(result)")
            
            var data : NSArray = result.objectForKey("data") as! NSArray
            
            var to = [String]()
            for i in 0...(data.count - 1) {
                let valueDict : NSDictionary = data[i] as! NSDictionary
                let id = valueDict.objectForKey("id") as! String
                to.append(id)
                
                // Only the first for testing...
                break
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
            
        } as FBRequestHandler)
        
    }
    
    // FBSDKGameRequestDialogDelegate protocols
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        println("called gameRequestDialog")
    }
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!) {
        println("called gameRequestDialog")
    }
    
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
        println("called gameRequestDialogDidCancel")
    }
    
    
    
}

