//
//  RequestTrashViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-12-06.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit


class RequestTrashViewController: UIViewController, UIGestureRecognizerDelegate,PopulateMasterTableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var fpTextView = FPTextView()
    var trashArray = [Trash]()
    var trashAssets = [TrashAssets]()
    var trash = Trash()
    var categories = InitializeTestData().generateDefaultCategories()
    var delegate : PopulateMasterTableViewDelegate? = nil
    var categoryPickerView = UIView()
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fpTextView = FPTextView(textView: textView, placeholder: "Enter description")
        trash.trashType = 2
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeButtonWasPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func saveButtonWasPressed(sender: AnyObject) {
        
        trash.title = self.textView.text
        trashArray.append(trash)
        
        if delegate != nil {
            refreshWantedData(trashArray)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshWantedData(tableData: [Trash]) {
        delegate?.refreshWantedData!(tableData)
    }
    
 
//    func trashTableViewDelegate(tableData: Array<Trash>) {
//        delegate?.trashTableViewDelegate(tableData)
//    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.textView.endEditing(true)
    }
    
    
    @IBAction func chooseCategoryWasPressed(sender: AnyObject) {
        if (self.categoryLabel.text? != nil) {
            self.chooseCategoryButton.setTitle("change", forState: UIControlState.Normal)
        } else {
            self.chooseCategoryButton.setTitle("choose category", forState: UIControlState.Normal)
        }
        
        var categoryPickerContainerFrame = CGRectMake(60, 200, 250, 220)
        categoryPickerView = UIView(frame: categoryPickerContainerFrame)
        categoryPickerView.backgroundColor = UIColor.whiteColor()
        categoryPickerView.layer.borderWidth = 1.0
        categoryPickerView.layer.cornerRadius = 12
        categoryPickerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        var categoryPicker = UIPickerView()
        categoryPicker.frame.size.height = 300
        categoryPicker.frame.size.width = 250
        categoryPicker.delegate = self
        
        categoryPickerView.addSubview(categoryPicker)
        self.view.addSubview(categoryPickerView)
    }
    
    //MARK: pickerView delegate methods
    
    //MARK:PickerView
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("selected")
        self.categoryLabel.text = categories[row]
        trash.trash_category = row
        categoryPickerView.removeFromSuperview()
        
        
    }
    
    
    
    //    func doneSelectingCategory(sender: UIButton) {
    //        categoryPickerView.removeFromSuperview()
    //    }
    
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var categories = InitializeTestData().generateDefaultCategories()
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return categories[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        //to do
        return 1
    }
    
 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - keyboard
    
    //MARK: keyboard
    
//    func registerForKeyboardNotifications() {
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
//    }
//    
//    
//    
//    func deregisterForKeyboardNotifications() {
//        NSNotificationCenter.defaultCenter().removeObserver(self);
//    }
//    
//    func keyboardWillShow(notification: NSNotification) {
//        var info = notification.userInfo!
//        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
//        
//        let delay:NSTimeInterval = 0.0
//        let duration:NSTimeInterval = 1.0
//        let keybSize = keyboardFrame.size.height + 25 as CGFloat
//        
//        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
////            self.bottomConstraint.constant = keyboardFrame.size.height + 25
//            }, completion: { finished in println("animation done")})
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        var info = notification.userInfo!
//        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
//        
//        UIView.animateWithDuration(0.1, animations: { () -> Void in
////            self.bottomConstraint.constant -= keyboardFrame.size.height + 105
//        })
//        
//    }

}
