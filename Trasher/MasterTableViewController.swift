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


class MasterTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate,
CLLocationManagerDelegate, UITabBarControllerDelegate, UISearchBarDelegate, UITabBarDelegate, TrashTableViewProtocol  {
    

    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    var locationManager = CLLocationManager()


    var trashArray = [Trash]()
    var trashAssets = [TrashAssets]()
    var filteredTrash = [Trash]()
    var maskView = UIView()
    var searchState : Bool = false
    var menuButtons = FPGoogleButton()
    var testData = InitializeTestData()
    var requestedTrash = [Trash]()
    var wantedTrash = [Trash]()
    
     override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
        maskView.frame = self.tableView.frame
        maskView.backgroundColor = UIColor(white: 0.98, alpha: 0.8)
        
        
        
        
        
        if (self.trashArray.isEmpty) {
            self.trashArray =  testData.generateTestData()
            self.trashAssets = testData.generateFilteredTrashAssets()
        }
        
        performTrashTypeFilter(self.trashArray)
        


        self.tableView.reloadData()
        self.navigationController?.navigationBar.topItem?.title = "Trash \(User().distance) km from you"
        
        let btnAttr : [(UIColor, String, String?, UIImage?)] = [
            (UIColor.redColor(), "addTrashButtonTouch", "", nil),
            (UIColor.blueColor(), "requestTrashButtonTouch", "", nil),
        ]
        
        menuButtons = FPGoogleButton(controller: self, buttonAttributes: btnAttr, parentView: self.view)
        
    }
    
    func performTrashTypeFilter(arrayOfTrash: [Trash]) -> [Trash] {
        
        if searchBar.selectedScopeButtonIndex == 0 {
            self.filteredTrash = testData.filterRequestedTrash(arrayOfTrash)
        } else {
            self.filteredTrash = testData.filterWantedTrash(arrayOfTrash)
        }
        
        return arrayOfTrash
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBar.text = ""
        performTrashTypeFilter(self.trashArray)
        
        tableView.reloadData()
    }
    

    
    func addTrashButtonTouch(sender: UIButton) {
        if User.registeredUser() {
            self.performSegueWithIdentifier("addTrashFromMasterSegue", sender: self)
        } else {
            self.performSegueWithIdentifier("signUpFromMasterSegue", sender: self)
        }
//        menuButtons.toggleMenuButtons()
    }
    
    func requestTrashButtonTouch(sender: UIButton) {
        if User.registeredUser() {
            self.performSegueWithIdentifier("requestTrashFromMasterSegue", sender: self)
        } else {
            self.performSegueWithIdentifier("signUpFromMasterSegue", sender: self)
        }
    }
    
    func drawRoundButton(btn: UIButton) {
//        btn.frame = CGRectMake(200, 100, 50, 50)
        btn.layer.cornerRadius = 30
        btn.clipsToBounds = true
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

            return self.filteredTrash.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.00
    }
    

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredTrash = filterTextForSearch(searchText)
        performTrashTypeFilter(self.filteredTrash)
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {

        clearSearch()
        searchBar.resignFirstResponder()
    }
    
    func clearSearch() {
        self.searchBar.text = ""
        performTrashTypeFilter(self.trashArray)
        self.tableView.reloadData()
    }
    
    func filterTextForSearch(keyword: String!) -> Array<Trash> {
        searchState = true
        
        self.filteredTrash = self.filteredTrash.filter({(trash:Trash) -> Bool in
            let descriptionMatch = trash.title.rangeOfString(keyword, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)
            return descriptionMatch != nil
        })
        
        if keyword.isEmpty {
            searchState = false
            self.filteredTrash = performTrashTypeFilter(self.trashArray)
//            self.trashArray = self.trashArray
        }
        
//        return self.trashArray
        return self.filteredTrash
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        var trash : Trash
        trash = filteredTrash[indexPath.row]

        
        cell.textLabel?.text = trash.title
        cell.detailTextLabel?.text = trash.fullAddress()
        
        var imageView = UIImageView(frame: CGRectMake(10, 10, cell.frame.width - 310, cell.frame.height - 15))
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        cell.indentationLevel = 70
        
        var mainTrashImage: NSData = TrashAssets.getMainTrashImage(self.trashAssets, trashId: trash.trashId)
        
        if (UIImage(data: trash.image) != nil) {
//            imageView.image = UIImage(data: trash.image)
            imageView.image = UIImage(data: mainTrashImage)
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
          detailSegue.trashAssets = trashAssets

        }
        
        if segue.identifier == "addTrashFromMasterSegue" {
            var addTrashController = segue.destinationViewController as AddTrashViewController
            
            addTrashController.trashArray = trashArray
            
            
            addTrashController.trashAssetsArray = trashAssets
            addTrashController.delegate = self
            
        }
        
        if segue.identifier == "requestTrashFromMasterSegue" {
            var requestTrashController = segue.destinationViewController as RequestTrashViewController
            
//            requestTrashController.trashArray = trashArray
//            
//            
//            requestTrashController.trashAssetsArray = trashAssets
//            requestTrashController.delegate = self
            
        }
    }
    
    func trashTableViewDelegate(tableData: Array<Trash>, trashAssetData: Array<TrashAssets>) {
        println("delegate called")
        self.trashArray = tableData
        self.trashAssets = trashAssetData
        
        performTrashTypeFilter(self.trashArray)
        self.tableView.reloadData()
    }


}
