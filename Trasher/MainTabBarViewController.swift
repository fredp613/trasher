//
//  MainTabBarViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-08.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit



class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate, PopulateMasterTableViewDelegate {

   
    var trashArray = [Trash]()
    var trashAssets = [TrashAssets]()

    @IBOutlet weak var logoutButton: UIButton!
    var managedObjectContext = CoreDataStack().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self                
//        println("this a view controller \(self.selectedViewController)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let master = self.viewControllers?[0] as MasterTableViewController
        master.trashArray = trashArray
        master.trashAssets = trashAssets
        logoutButton.alpha = 0
        
//        let cu = CoreUser.currentUser(managedObjectContext!)

        
    }
    

    
    func trashTableViewDelegate(tableData: Array<Trash>, trashAssetData: Array<TrashAssets>) {
        trashArray = tableData
        trashAssets = trashAssetData
    }
    
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if viewController == self.viewControllers?[1] as UIViewController {
            if CoreUser.userIsRegistered(managedObjectContext!) {
                //here you should check if user is logged in via API and core data
                if CoreUser.userIsLoggedIn(managedObjectContext!) {
                    navigationController?.navigationBar.topItem?.title = "Profile"
                } else {
                    //login segue to change
                    performSegueWithIdentifier("showLoginFromMainSegue", sender: self)
                    tabBarController.selectedIndex = 0
                }
            } else {
                performSegueWithIdentifier("signUpSegue", sender: self)
                tabBarController.selectedIndex = 0
            }
            logoutButton.alpha = 1
        } else {
            navigationController?.navigationBar.topItem?.title = "Trash \(User().distance) KM from you"
            logoutButton.alpha = 0
        }
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if self.selectedIndex == 1 {
            logoutButton.alpha = 1
        } else {
            logoutButton.alpha = 0
        }
        
//        var master = self.viewControllers?[0] as MasterTableViewController;
//        master.tableView.reloadData()

    }
    
    override func viewDidAppear(animated: Bool) {
//        var master = self.viewControllers?[0] as MasterTableViewController;
//        master.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutWasPressed(sender: AnyObject) {
    
        if let user = CoreUser.currentUser(managedObjectContext!) {
            user.remember = false
            CoreUser.updateUser(managedObjectContext!, coreUser: user)
            println(CoreUser.getUserToken(user))
        }
        
        let params = [
            "user": ["email" : "fredp@gmail.com",
                "password" : "fredp613"]
        ]
        
        TrasherAPI.APIAuthenticatedRequest(managedObjectContext!, httpMethod: httpMethodEnum.DELETE, url: "https://trasher.herokuapp.com/users/sign_out", params: params) { (responseObject, error) -> () in
            let json = responseObject
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if json["state_code"] == 0 {
                    //update user token
                    let token : String = json["new_user_token"].string!
                    KeyChainHelper.createORupdateForKey(token, keyName: "auth_token")
                    let new_token = KeyChainHelper.retrieveForKey("auth_token")
                    println("\(new_token) new token worked! so the keychain has updated")
                    var alertView = UIAlertView(title: "Logged out!", message: "You have successfully logged out!!", delegate: self, cancelButtonTitle: nil)
                    alertView.show()
                    self.dismissAlert(alertView)
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    var jsonError = json["message"].string!
                    var alertView = UIAlertView(title: "Logout error", message: jsonError, delegate: self, cancelButtonTitle: "OK")
                    alertView.show()
                }
            })
        }
        
        self.selectedIndex = 0
        logoutButton.alpha = 0
    }
    
    func dismissAlert(alertView: UIAlertView) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { () -> Void in
            sleep(2)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                alertView.dismissWithClickedButtonIndex(0, animated: true)
                
            })
        })
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var master = self.viewControllers?[0] as MasterTableViewController!
        
        if segue.identifier == "addTrashSegue" {
            var addTrashController = segue.destinationViewController as? AddTrashViewController
            addTrashController?.trashArray = master!.trashArray
            addTrashController?.trashAssetsArray = master!.trashAssets
//            addTrashController?.delegate = master!
           
        }
        
        if segue.identifier == "signUpSegue" {
            var signUpController = segue.destinationViewController as? SignUpViewController
            signUpController?.trashArray = master!.trashArray
            signUpController?.trashAssetsArray = master!.trashAssets
        }
        
     

        
    

    }
    


}
