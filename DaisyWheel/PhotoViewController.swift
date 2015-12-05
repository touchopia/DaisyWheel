//
//  PhotoViewController.swift
//  DaisyWheel
//
//  Created by Phil Wright on 12/1/15.
//  Copyright © 2015 Touchopia, LLC. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var stickers = [UIImageView]()
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var imageView : UIImageView!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Hide NavigationBar
        
        self.navigationController?.navigationBarHidden = true
        
        // Assign Delegate for ImagePicker
        
        imagePicker.delegate = self
    }
    
    //MARK: - Action Methods
    
    @IBAction func addSticker() {
        
        let image = UIImage(named: "wheelPic")
        
        if let stickerImage = image {
            let imageView = PinchZoomImageView(image: stickerImage)
            imageView.contentMode = .ScaleAspectFit
            
            let point = self.randomOriginPoint()
            
            imageView.frame = CGRectMake(point.x, point.y, 200, 200)
            self.view.addSubview(imageView)
        }
    }
    
    @IBAction func chooseImage() {
        
        if  UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - UIImagePicker Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Notice: UIImagePickerControllerEditedImage rather than UIImagePickerControllerOrginalImage
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Saving Image
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alertController = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func saveScreenShot() {
        
        // Hide Any Views Not Relevent to Screen
        
        bottomBar.hidden = true
        
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            self.view.layer.renderInContext(context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //Save it to the camera roll
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        // Show Any View
        bottomBar.hidden = false
    }
    
    func randomOriginPoint() -> CGPoint {
        
        let screenWidth = UInt32(self.view.frame.size.width / 3)
        return CGPointMake(CGFloat(arc4random_uniform(screenWidth)), CGFloat(arc4random_uniform(screenWidth)))
    }
    
    //MARK: - Helper Methods
    
    func getDocumentsDirectory() -> NSString {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK: - ViewController Methods
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}

