//
//  MyTrashDetailViewController.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-12-29.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration
import AssetsLibrary

class MyTrashDetailViewController: UIViewController, UIScrollViewDelegate,CTAssetsPickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MyTrashTableViewDelegate {

   
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var changeImagesButton: UIButton!
    @IBOutlet weak var trashDesc: UITextView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var delegate:MyTrashTableViewDelegate? = nil
    var ctPicker = CTAssetsPickerController()
    var pageViews: [UIImageView?] = []
    var categoryPickerView = UIView()
    var categories = InitializeTestData().generateDefaultCategories()
    var pickedAssets = [UIImage]()
    
    var moc : NSManagedObjectContext = CoreDataStack().managedObjectContext!
    var currentTrash : CoreTrash!
    var trashImages : [CoreTrashImage]!
    var fpTextView : FPTextView!
    var assets = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.trashDesc.text = currentTrash.title
        self.trashDesc.editable = false
        trashImages = CoreTrashImage.getTrashImages(currentTrash.id, moc: moc)
        let pageCount = trashImages.count
        
        // Set up the page control
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // Set up the array to hold the views for each page
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // Set up the content size of the scroll view
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(trashImages.count), pagesScrollViewSize.height)
        
        // Load the initial set of pages that are on screen
        loadVisiblePages()
        
//        fpTextView = FPTextView(textView: self.trashDesc, placeholder: currentTrash.title)
        changeImagesButton.alpha = 0
        categoryButton.setTitle(currentTrash.category.category_name, forState: UIControlState.Normal)
        categoryButton.enabled = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.editButtonItem().action = "editButtonWasPressed:"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: MYTrashTableViewDelegate method
    func updateTableViewDelegate(moc: NSManagedObjectContext) {
        delegate?.updateTableViewDelegate(moc)
    }
    
    
    //MARK:PickerView
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryButton.setTitle(categories[row], forState: UIControlState.Normal)
        let category : CoreCategories = CoreCategories.findCategoryById(moc, id: row) as CoreCategories
        currentTrash.category = category
        categoryPickerView.removeFromSuperview()
    }
    
    
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
    
    
    // MARK: CT delegats
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeButtonWasPressed(sender: AnyObject) {
        self.assets = NSMutableArray()
        self.ctPicker.assetsFilter = ALAssetsFilter.allAssets()
        self.ctPicker.showsCancelButton = true
        self.ctPicker.delegate = self
        self.ctPicker.selectedAssets = self.assets as! NSMutableArray
        self.presentViewController(ctPicker, animated: true, completion: nil)
    }
    
    func promptForSource() {
        var actionSheet = UIActionSheet()
        actionSheet.title = "Image Source"
        actionSheet.delegate = self
        actionSheet.showInView(self.view);
    }
    
    func promptForPhotoRoll() {
        var controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        controller.delegate = self;
        self.presentViewController(controller, animated: true, completion: nil)
        
        
    }
    
    func promptForCamera() {
        var controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.Camera;
        controller.delegate = self;
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func capture(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            var img = UIImagePickerController()
            img.delegate = self
            img.sourceType = UIImagePickerControllerSourceType.Camera;
            img.allowsEditing = false
            self.presentViewController(img, animated: true, completion: nil)
        }
    }
    
    // MARK: CTPickerControllerDelegate
    
    
    
    
    func assetsPickerController(picker: CTAssetsPickerController!, isDefaultAssetsGroup group: ALAssetsGroup!) -> Bool {
        //        return [group.valueForProperty(ALAssetsGroupPropertyType).integerValue == ALAssetsGroupSavedPhotos
        return true
    }
    
    func assetsPickerController(picker: CTAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        //        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        
        //TODO - update scroll view with new images and save to core data
        
        for selectedImg in assets {
            //                cell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
            let pickedAsset : ALAsset = selectedImg as! ALAsset
            var img = UIImage(CGImage: pickedAsset.thumbnail().takeUnretainedValue())
            self.pickedAssets.append(img!)
            
        }
        
        let pageCount = pickedAssets.count
        
        // Set up the page control
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // Set up the array to hold the views for each page
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // Set up the content size of the scroll view
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pickedAssets.count), pagesScrollViewSize.height)
        
        // Load the initial set of pages that are on screen
        loadVisiblePages()
        
        
        
    }
    
    func loadPage(page: Int) {
        
        if pickedAssets.isEmpty {
            if page < 0 || page >= trashImages.count {
                // If it's outside the range of what you have to display, then do nothing
                return
            }
        } else {
            if page < 0 || page >= pickedAssets.count {
                // If it's outside the range of what you have to display, then do nothing
                return
            }
        }
        
        
        
        // Load an individual page, first checking if you've already loaded it
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            frame = CGRectInset(frame, 10.0, 0.0)
            
            let newPageView = UIImageView()
            if pickedAssets.isEmpty {
                var ta : NSData?
                if let trashImages = CoreTrashImage.getTrashImages(currentTrash.id, moc: moc) {
                    ta = trashImages[page].trash_image
                }
                newPageView.image = UIImage(data: ta!)
            } else {
//                newPageView.image = UIImage(data: pickedAssets[page])
                newPageView.image = pickedAssets[page]
            }
            
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        
        if pickedAssets.isEmpty {
            if page < 0 || page >= trashImages.count {
                // If it's outside the range of what you have to display, then do nothing
                return
            }
        } else {
            if page < 0 || page >= pickedAssets.count {
                // If it's outside the range of what you have to display, then do nothing
                return
            }
        }
        
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
        
    }
    
    func loadVisiblePages() {
        
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        if pickedAssets.isEmpty {
            for var index = lastPage+1; index < self.trashImages.count; ++index {
                purgePage(index)
            }
        } else {
            for var index = lastPage+1; index < self.pickedAssets.count; ++index {
                purgePage(index)
            }
        }
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    
    func assetsPickerController(picker: CTAssetsPickerController!, shouldEnableAsset asset: ALAsset!) -> Bool {
        if asset.valueForProperty(ALAssetPropertyType).isEqual(ALAssetTypeVideo) {
            var duration : NSTimeInterval = asset.valueForProperty(ALAssetPropertyDuration).doubleValue
            return lround(duration) >= 5
        } else {
            return true
        }
    }
    
    func assetsPickerController(picker: CTAssetsPickerController!, shouldSelectAsset asset: ALAsset!) -> Bool {
        if ctPicker.selectedAssets.count >= 10 {
            var alertView = UIAlertView(title: "Attention", message: "Please select no more than 10", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
        
        if !(asset.defaultRepresentation() != nil) {
            var alertView = UIAlertView(title: "Attention", message: "Please select no more than 10", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            
        }
        
        return ctPicker.selectedAssets.count < 10 && asset.defaultRepresentation() != nil
    }
    
    func editButtonWasPressed(sender: AnyObject) {
        if self.editButtonItem().title == "Edit" {
            trashDesc.editable = true
            changeImagesButton.alpha = 1
            categoryButton.enabled = true
            self.editButtonItem().title = "Done"
        } else {
            if updateTrash() {
                trashDesc.editable = false
                changeImagesButton.alpha = 0
                categoryButton.enabled = false
                self.editButtonItem().title = "Edit"
            } else {
                // ui alert view with message
            }
        }

        
    }
    
    func updateTrash() -> Bool {
        
        let coreTrash = currentTrash
        currentTrash.title = trashDesc.text
        if CoreTrash.updateTrash(moc, coreTrash: coreTrash) {
            
            if !pickedAssets.isEmpty {
                println("this should execute")
                CoreTrashImage.deleteImagesForTrash(moc, trash: currentTrash)
                for ta in pickedAssets {
                    let trashAsset : CoreTrashImage = NSEntityDescription.insertNewObjectForEntityForName("CoreTrashImage", inManagedObjectContext: moc) as! CoreTrashImage
                    trashAsset.trash_image = UIImageJPEGRepresentation(ta, 0.75) as NSData
                    trashAsset.trash = currentTrash
                    CoreTrashImage.saveTrashImage(trashAsset, moc: moc)
                }
            }
            
            updateTableViewDelegate(moc)
            return true
            
        }
        return false
        
        
    }
    
    
    @IBAction func categoryButtonPressed(sender: AnyObject) {

        
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

    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
