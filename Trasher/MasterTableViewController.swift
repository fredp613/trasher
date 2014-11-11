//
//  MasterTableViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-18.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation
import QuartzCore


class MasterTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
CLLocationManagerDelegate, UITabBarControllerDelegate, UITabBarDelegate, TrashTableViewProtocol  {
    
    @IBOutlet weak var textSearch: UISearchBar!
    
 
    @IBOutlet weak var tableView: UITableView!

    var locationManager = CLLocationManager()

   

    var trashArray: NSMutableArray = NSMutableArray()

    
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.trashArray = InitializeTestData().trashArray
        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
 
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.trashArray.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.00
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
//        var trashItem  = trashArray.objectAtIndex(indexPath.row)
        var trashItem: Trash = self.trashArray.objectAtIndex(indexPath.row) as Trash
        cell.textLabel.text = trashItem.title
        cell.detailTextLabel?.text = trashItem.fullAddress() 
        
        if (trashItem.image != nil) {
            var imageView = UIImageView(frame: CGRectMake(10, 10, cell.frame.width - 310, cell.frame.height - 15))
            imageView.layer.cornerRadius = 32.5
            imageView.clipsToBounds = true
            cell.addSubview(imageView)
            cell.indentationLevel = 75
            //set image
            imageView.image = trashItem.image as UIImage

        } else {
            
            var imageView = UIImageView(frame: CGRectMake(10, 10, cell.frame.width - 310, cell.frame.height - 15))
            imageView.layer.cornerRadius = 32.5
            imageView.clipsToBounds = true
            cell.addSubview(imageView)
            cell.indentationLevel = 75
            //set image
            imageView.image = UIImage(named: "trash-can-icon")

        }
        
        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        if (segue.identifier == "showDetailsSegue") {
            var detailSegue : DetailViewController = segue.destinationViewController as DetailViewController
            var path : NSIndexPath = self.tableView.indexPathForSelectedRow()!
            var trash = trashArray[path.row] as Trash
            detailSegue.currentTrash = trash
        }
//        
//        if (segue.identifier == "addTrashSegue") {
//            var addTrashController = segue.destinationViewController as? AddTrashViewController
//            addTrashController?.delegate = self;
//            addTrashController?.trashArray = trashArray
//            println("hi")
//        }
        
     
        
        
    
    }
    


    
     //MARK: -tab functionality
   
    func trashTableViewDelegate(tableData: NSMutableArray) {
        self.trashArray = tableData
        println("hi this delegate is all good")
        self.tableView.reloadData()
    }
    
    

}
