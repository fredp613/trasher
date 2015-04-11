//
//  LoginViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-12-15.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var textPwd: UITextField!
    
    var parentController : Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textPwd.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        CoreUser.authenticated("fredp@gmail.com", password: "fredp613", completionHandler: { (authenticated) -> Void in
        //do some
            if (authenticated == true) {
                if self.parentController == 1 {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.performSegueWithIdentifier("showMasterFromLogin", sender: self)
                }

            } else {
                var alertView = UIAlertView(title: "Sign in error", message: "email / password not correct, try again", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
            }
        })
        
        return true
    }
    
    @IBAction func closeButtonWasPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
