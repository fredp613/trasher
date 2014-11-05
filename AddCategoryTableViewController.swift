//
//  AddCategoryTableViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-28.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit

class AddCategoryTableViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var initialCategories = Category().initials1

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var headerView  = CGRectMake(40.0, 40.0, 40.0, 40.0)
//        self.tableView.tableHeaderView = headerView

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneWasClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Table view data source
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return ""
//    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return Category().defaults.count
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        var categoryItem = Category().defaults[indexPath.row + 1]
        
        var catId = indexPath.row + 1
        
        cell?.textLabel.text = categoryItem
        
        
        if !self.existingCategory(categoryItem!) {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            initialCategories.updateValue(categoryItem!, forKey: catId)
            println("\(initialCategories)")

        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.None
            initialCategories.removeValueForKey(catId)
            println("\(initialCategories)")

        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        var categoryItem = Category().defaults[indexPath.row + 1]
        cell.textLabel.text = categoryItem
        
     
        
        if self.existingCategory(categoryItem!) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
    
    //MARK: - Custom Methods
    
 
    
    func existingCategory(var category : String) -> Bool {
        
//        for var i = 0; i < Category.initialCategories().count; i++ {
//            if var cat = Category.initialCategories()[i].category {
//                if category == cat  {
//                    return true
//                }
//            }
//        }
        for (key, value) in initialCategories {
            
            if category == value {
                return true
            }
        }
        return false
    }

}
