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
CLLocationManagerDelegate, UITabBarControllerDelegate, UISearchBarDelegate, UITabBarDelegate, TrashTableViewProtocol  {
    

    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    var locationManager = CLLocationManager()


    var trashArray : [Trash] = Array<Trash>()
    var filteredTrash = [Trash]()
    
    var searchState : Bool = false
    
    // Search controller to help us with filtering.
//    var searchController: UISearchController!
    
    // Secondary search results table view.

    
    
    
     override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.searchBar.delegate = self
        self.trashArray =  InitializeTestData().trashArray
        
//        var del = AddTrashViewController()
//        del.delegate = self
        
        
        self.tableView.reloadData()
        navigationController?.navigationBar.topItem?.title = "Trash \(User().distance) km from you"

//        self.searchDisplayController?.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        

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

            return self.trashArray.count

        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.00
    }
    

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterTextForSearch(searchText)
        self.tableView.reloadData()
    }
    
    
    
    func filterTextForSearch(keyword: String!) -> Array<Trash> {
        searchState = true
        self.trashArray = InitializeTestData().trashArray
        self.trashArray =  self.trashArray.filter({(trash:Trash) -> Bool in
            let descriptionMatch = trash.title.rangeOfString(keyword, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)
            return descriptionMatch != nil
        })
        
        if keyword.isEmpty {
            searchState = false
            self.trashArray = InitializeTestData().trashArray
        }
        
        return self.trashArray
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        var trash : Trash
        trash = trashArray[indexPath.row]
        
        cell.textLabel.text = trash.title
        cell.detailTextLabel?.text = trash.fullAddress()
        
        var imageView = UIImageView(frame: CGRectMake(10, 10, cell.frame.width - 310, cell.frame.height - 15))
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        cell.indentationLevel = 70
        
        if (UIImage(data: trash.image) != nil) {
            imageView.image = UIImage(data: trash.image)
        } else {
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
          var trash : Trash
          let path  = self.tableView.indexPathForSelectedRow()!
          trash = trashArray[path.row] as Trash
          detailSegue.currentTrash = trash
        }
    }
    

     //MARK: -tab functionality
   
    func trashTableViewDelegate(tableData: Array<Trash>) {
        self.trashArray = tableData
        println("hi this delegate is all good")
        self.tableView.reloadData()
    }
    
    

}
