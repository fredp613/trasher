//
//  ProfileViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-27.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import CoreData


class ProfileViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, tableViewProtocol  {
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    @IBOutlet weak var addCategory: UIButton!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var changeDefaultAddress: UIButton!
    @IBOutlet weak var defaultAddressLabel: UILabel!
    @IBOutlet weak var kmText: UITextField!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var kmMiButton: UIButton!

    
    var addCatsController: AddCategoriesTableViewController?
    var tableData: [CoreUserCategories] = [CoreUserCategories]()
    var menuButtons = FPGoogleButton()
    var moc : NSManagedObjectContext = CoreDataStack().managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.kmText.delegate = self

        self.categoriesTableView.delegate = self
        self.categoriesTableView.dataSource = self
        self.kmText.text = "\(User().distance)"
        self.tableData = CoreUserCategories.retrieveUserCategories(moc)

        let btnAttr : [(UIColor, String, String?, UIImage?)] = [
            (UIColor.redColor(), "addTrashButtonTouch", "", nil),
            (UIColor.blueColor(), "requestTrashButtonTouch", "", nil),
        ]
        
        menuButtons = FPGoogleButton(controller: self, buttonAttributes: btnAttr, parentView: self.view)
        println("\(self.tableData.count)")
    }
    
    
    func addTrashButtonTouch(sender: UIButton) {
        
        self.performSegueWithIdentifier("addTrashFromProfileSegue", sender: self)
//        menuButtons.toggleMenuButtons()
    }
    
    func requestTrashButtonTouch(sender: UIButton) {
        self.performSegueWithIdentifier("requestTrashFromProfileSegue", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        println("\(CoreUserCategories.retrieveUserCategories(moc).count)")
        self.categoriesTableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)



    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func kmTextChanged(sender: AnyObject) {
        if (self.kmText.text.toInt() > 500) {
            var alertView = UIAlertView(title: "Range to far", message: "The maximum distance is 500KM", delegate: self, cancelButtonTitle: "OK")
            alertView.show()

            self.distanceSlider.value = 500.00
            
        } else {
            self.distanceSlider.value = (self.kmText.text as NSString).floatValue

        }
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            self.kmText.text = "500"
    }
    
    //MARK: ACTIONS
    
    @IBAction func changeDistance(sender: AnyObject) {
//        self.kmLabel.text = NSString(format: "%.2f" , self.distanceSlider.value)
        self.kmText.text = "\(NSInteger(self.distanceSlider.value))"
    }
    
    
    //MARK: tableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        return self.tableData.count
    }
//
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 40.00
//    }
    
    
    //MARK: Delegate table view method
    func tableViewDelegate(tableData: [CoreUserCategories]) {
        self.tableData = tableData
        self.categoriesTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var catId = self.tableData[indexPath.row].category_id
        var categoryName = CoreCategories.findCategoryById(moc, id: catId).category_name

        
        cell.textLabel?.text = "\(catId) - \(categoryName)"
        return cell
    }
   
    // MARK: - Navigation
    
//    func tableViewDelegate([Int:String]) {
//      
//      self.categoriesTableView.reloadData()
//
//        
//    }
    

    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        println("\(tableData.count)")
        addCatsController = segue.destinationViewController as? AddCategoriesTableViewController
        addCatsController?.delegate = self
        addCatsController?.currentData = tableData
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.kmText.resignFirstResponder()
    }
    
    
    //MARK: Text Field Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func myTrashWasPressed(sender: AnyObject)
    {
//        self.performSegueWithIdentifier("showMyTrashSegue", sender: self)
        
    }
    

    @IBAction func kmMiWasPressed(sender: AnyObject) {
        if kmMiButton.titleLabel?.text == "km" {
        kmMiButton.setTitle("mi", forState: UIControlState.Normal)
        } else {
            kmMiButton.setTitle("km", forState: UIControlState.Normal)
        }
    }

        

      
}


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


