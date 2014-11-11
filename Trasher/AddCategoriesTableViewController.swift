//
//  AddCategoriesTableViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-08.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit

protocol tableViewProtocol {
    func tableViewDelegate(tableData: [Int:String])
}

class AddCategoriesTableViewController: UITableViewController {

    var delegate: tableViewProtocol?
    var currentData: [Int:String]! = [Int: String]()
    var category: Category! = Category()
    var pvc: ProfileViewController! = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//                currentData = category.initialCategories
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return InitializeTestData().defaulCategories.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        var categoryItem : String! = InitializeTestData().defaulCategories[indexPath.row + 1]
        
        
        var catId = indexPath.row + 1
        
        cell?.textLabel.text = categoryItem
        
        
        if !self.existingCategory(categoryItem!) {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            currentData.updateValue(categoryItem!, forKey: catId)
            println("Current data categories are: \(currentData)")
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.None
            
            if currentData.count != 0 {
                currentData.removeValueForKey(catId)
                
            } else {
                println("some error msg")
            }
            
            println("Current data categories are: \(currentData)")
        }
        
       
        
        
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var categoryItem = InitializeTestData().defaulCategories[indexPath.row + 1]
        cell.textLabel.text = categoryItem
        
        
        
        if self.existingCategory(categoryItem!) {
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
    func existingCategory(var category : String) -> Bool {
        
     
        for (key, value) in currentData {
            
            
            if category == value {
                return true
            }
        }
        return false
    }
    
    override func viewDidDisappear(animated: Bool) {
        delegate?.tableViewDelegate(currentData)
        
    }

}
