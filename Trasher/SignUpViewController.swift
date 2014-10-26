//
//  SignUpViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-23.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import LocalAuthentication

class SignUpViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var buttonVerification: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var textVerification: UITextField!
    @IBOutlet weak var buttonVerify: UIButton!
    @IBOutlet weak var activityIndicatorViewVerrify: UIActivityIndicatorView!
    
    @IBOutlet weak var barButtons: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textVerification.hidden = true
        self.buttonVerify.hidden = true

//        self.navigationItem.setHidesBackButton(true, animated: false)
//
//        self.navigationController?.navigationBar.topItem?.title = " "

        

        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchID(sender: AnyObject) {
        // Create an alert
        var alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        // Add the cancel button to the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // Create the Local Authentication Context
        var touchIDContext = LAContext()
        var touchIDError : NSError?
        var reasonString = "Local Authentication Testing"
        
        // Check if we can access local device authentication
        if touchIDContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&touchIDError) {
            // Check what the authentication response was
            touchIDContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {
                (success: Bool, error: NSError?) -> Void in
                // Check if we passed or failed
                if success {
                    // User authenticated using Local Device Authentication Successfully!
                    
                    // Show a success alert
                    alert.title = "Success!"
                    alert.message = "You have authenticated!"
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else {
                    // Unsuccessful
                    
                    // Set the title of the unsuccessful alert
                    alert.title = "Unsuccessful!"
                    
                    // Set the message of the alert
                    switch error!.code {
                    case LAError.UserCancel.rawValue:
                        alert.message = "User Cancelled"
                    case LAError.AuthenticationFailed.rawValue:
                        alert.message = "Authentication Failed"
                    case LAError.PasscodeNotSet.rawValue:
                        alert.message = "Passcode Not Set"
                    case LAError.SystemCancel.rawValue:
                        alert.message = "System Cancelled"
                    case LAError.UserFallback.rawValue:
                        alert.message = "User chose to try a password"
                    default:
                        alert.message = "Unable to Authenticate!"
                    }
                    
                    // Show the alert
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } else {
            // Unable to access local device authentication
            
            // Set the error title
            alert.title = "Error"
            
            // Set the error alert message with more information
            switch touchIDError!.code {
            case LAError.TouchIDNotEnrolled.rawValue:
                alert.message = "Touch ID is not enrolled"
            case LAError.TouchIDNotAvailable.rawValue:
                alert.message = "Touch ID not available"
            case LAError.PasscodeNotSet.rawValue:
                alert.message = "Passcode has not been set"
            default:
                alert.message = "Local Authentication not available"
            }
            
            // Show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    

    
    
    
//    func canEvaluatePolicy(_ policy: LAPolicy,
//        error error: NSErrorPointer) -> Bool
    
    @IBAction func sendVerification(sender: AnyObject) {
        
        self.buttonVerification.hidden = true
        self.activityIndicatorView.startAnimating()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { () -> Void in
            sleep(1)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.buttonVerification.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                self.buttonVerification.setTitle("Verification Code Sent", forState: UIControlState.Normal)
                self.buttonVerification.backgroundColor = UIColor.whiteColor()
                self.buttonVerification.hidden = false
                self.buttonVerify.hidden = false
                self.textVerification.hidden = false
                
                self.activityIndicatorView.stopAnimating()
            })
        })
        
       

        


        
        

        
    }
    
    @IBAction func verifyCode(sender: AnyObject) {
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}