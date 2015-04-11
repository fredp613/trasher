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

class MyTrashTableViewController: UITableViewController, MyTrashTableViewDelegate {

    @IBOutlet weak var scopeBar: UISegmentedControl!

    var moc : NSManagedObjectContext = CoreDataStack().managedObjectContext!
    var userTrash : [Trash] = [Trash]()
    var refreshCtrl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
//        println("\(userTrash[0].category.category_name)" + " hihi" )
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        refreshCtrl.backgroundColor = UIColor.lightGrayColor()
        refreshCtrl.tintColor = UIColor.whiteColor()
        refreshCtrl.addTarget(self, action: "refreshTableView", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshCtrl)
        setUserTrashArray(activityIndicator: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableViewDelegate(moc: NSManagedObjectContext) {
        tableView.reloadData()
    }
    
    func setUserTrashArray(activityIndicator: Bool = true) -> [Trash] {
        
        Trash.getTrashFromAPI(moc, completionHandler: { (data, error) -> Void in
            if data != nil {
                self.userTrash = data
                self.tableView.reloadData()
            } else {
                println(error)
            }
        })
        return userTrash
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
        let category : String! = Trash.categoryName(trash.trash_category!)
        cell.textLabel?.text = trash.title + " " + category! + " \(trash.trashType)" + "\(trash.userId)"
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
            var userTrash : [CoreTrash] = CoreTrash.getTrashByUser(moc)
            if scopeBar.selectedSegmentIndex == 0 {
                userTrash = CoreTrash.getRequestedTrashByUser(moc)
            } else {
                userTrash = CoreTrash.getWantedTrashByUser(moc)
            }
            let trash = userTrash[path!.row] as CoreTrash
            
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
        setUserTrashArray(activityIndicator: false)
        refreshCtrl.endRefreshing()
    }












}







