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
            if CoreUser.userIsRegistered() {
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
        
        let user = CoreUser.currentUser(managedObjectContext!)
        user.remember = false
        CoreUser.updateUser(managedObjectContext!, coreUser: user)
        self.selectedIndex = 0
        logoutButton.alpha = 0
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
