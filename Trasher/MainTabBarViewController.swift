//
//  MainTabBarViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-08.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit



class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

   
    var trashArray = [Trash]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        println("\(trashArray.count)")
        
//        println("this a view controller \(self.selectedViewController)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
//        var master = self.viewControllers?[0] as MasterTableViewController;
//        master.trashArray = trashArray
        
        
    }
    
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        
        if viewController == self.viewControllers?[1] as UIViewController {
            navigationController?.navigationBar.topItem?.title = "Profile"
        } else {
            navigationController?.navigationBar.topItem?.title = "Trash \(User().distance) KM from you"
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addTrashSegue") {
            var master = self.viewControllers?[0] as MasterTableViewController!
            var addTrashController = segue.destinationViewController as? AddTrashViewController
            addTrashController?.trashArray = master!.trashArray
            addTrashController?.delegate = master!
        }
        
    

    }
    


}