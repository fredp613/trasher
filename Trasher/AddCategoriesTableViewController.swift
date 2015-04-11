//
//  AddCategoriesTableViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-08.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import CoreData


class AddCategoriesTableViewController: UITableViewController, ProfileDelegate {

    var delegate:ProfileDelegate? = nil
    var currentData = [CoreUserCategories]()
    var categories : [CoreCategories]! = [CoreCategories]()
    var pvc: ProfileViewController! = ProfileViewController()
    var moc : NSManagedObjectContext = CoreDataStack().managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = CoreCategories.retrieveCategories(moc)
        println(delegate)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        categories = CoreCategories.retrieveCategories(moc)
        currentData = CoreUserCategories.retrieveUserCategories(moc)
        self.tableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        return categories.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        

        var categoryItem : String! = categories[indexPath.row].category_name
        
        
        var catId = categories[indexPath.row].id
        
        cell?.textLabel?.text = categoryItem

        if !self.existingCategory(catId) {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            //this is where you update coreusercategories
            CoreUserCategories.insertUserCategory(moc, category_id: catId)
            currentData = CoreUserCategories.retrieveUserCategories(moc)
//            delegate?.tableViewDelegate(self.currentData)

        } else {
                        //this is where you update coreusercategories
            cell?.accessoryType = UITableViewCellAccessoryType.None
            CoreUserCategories.deleteUserCategory(moc, category_id: catId)
            currentData = CoreUserCategories.retrieveUserCategories(moc)
//            delegate?.tableViewDelegate(self.currentData)
            
        }
        updateCategories(moc)
        
    }
    
    func updateCategories(moc: NSManagedObjectContext) {
        delegate?.updateCategories!(moc)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var categoryItem = categories[indexPath.row].category_name
        cell.textLabel?.text = categoryItem
        
        var catId = categories[indexPath.row].id
        
        if self.existingCategory(catId) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark

        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        
        
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Custom Actions
    
    
    // MARK: - Custom Methods
    func existingCategory(category_id: NSNumber) -> Bool {
        
        currentData = CoreUserCategories.retrieveUserCategories(moc)
        
        for c in currentData {
            if c.category_id == category_id {
                return true
            }
        }

        return false
    }
    
//    override func viewDidDisappear(animated: Bool) {
//        delegate?.tableViewDelegate(self.currentData)
//        
//    }

}
