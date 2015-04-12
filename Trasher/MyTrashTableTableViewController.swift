//
//  MyTrashTableTableViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-12-07.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import CoreData


protocol MyTrashTableViewDelegate {
   func updateTableViewDelegate(moc: NSManagedObjectContext)
}

class MyTrashTableViewController: UITableViewController, MyTrashTableViewDelegate, UISearchBarDelegate {

    var moc : NSManagedObjectContext = CoreDataStack().managedObjectContext!
    var userTrash : [Trash] = [Trash]()
    var refreshCtrl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        refreshCtrl.backgroundColor = UIColor.lightGrayColor()
        refreshCtrl.tintColor = UIColor.whiteColor()
        refreshCtrl.addTarget(self, action: "refreshTableView", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshCtrl)
        setUserTrashArray(setActivityIndicator: true, dataRefresh: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableViewDelegate(moc: NSManagedObjectContext) {
        setUserTrashArray(setActivityIndicator: true, dataRefresh: true)
    }
    
    
    func setUserTrashArray(setActivityIndicator: Bool = true, dataRefresh: Bool = true) {
        
        var activityIndicator : UIActivityIndicatorView!
        if dataRefresh {
            if setActivityIndicator {
                activityIndicator = CustomActivityIndicator.activate(self.view)
            }
            
            Trash.getAuthenticatedTrashFromAPI(moc, url: APIUrls.get_user_trashes, completionHandler: { (data, error) -> Void in
                if (data != nil) {
                    var trashData = data
                    self.userTrash = trashData
//                    self.thumbnails = self.trashAssets.map{$0.trashImage}
                    self.tableView.reloadData()
                    if setActivityIndicator {
                        CustomActivityIndicator.deactivate(activityIndicator)
                    }
                } else {
                    println(error)
                }
            })
        } else {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
       
        return userTrash.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let trash = userTrash[indexPath.row]
//        if let category : String! = Trash.categoryName(trash.trash_category!)
        cell.textLabel!.text = "\(trash.desc) - \(trash.trashType) - \(trash.userId)"
        cell.detailTextLabel?.text = "\(trash.updatedOn)"
        
        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "myTrashEditSegue") {
            
            var detailSegue : MyTrashDetailViewController = segue.destinationViewController as! MyTrashDetailViewController
            let path = self.tableView.indexPathForSelectedRow()
            let trash = self.userTrash[path!.row] as Trash
            detailSegue.currentTrash = trash
            detailSegue.delegate = self
            detailSegue.moc = moc
        }
        
    }
    
    @IBAction func backToProfileWasPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: custom methods
    
    @IBAction func scopeChanged(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    func refreshTableView() {
        setUserTrashArray(setActivityIndicator: false, dataRefresh: true)
        refreshCtrl.endRefreshing()
    }

}







