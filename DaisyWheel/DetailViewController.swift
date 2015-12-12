//
//  DetailViewController.swift
//  LiveCamera
//
//  Created by Phil Wright on 12/12/15.
//  Copyright © 2015 Touchopia, LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var capturedImage: UIImage?


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let image = self.capturedImage {
            self.imageView.image = image
        }
    }
    
    @IBAction func addStickerView() {
        let stickerView = PinchZoomImageView(image: UIImage(named: "wheelPic"))
        self.view.addSubview(stickerView)
    }
    
    /* Save a screenshot */
    
    func saveToPhotoGallery() {
        
        // Hide the button fist!
        button.hidden = true
        
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        // Show the button again
        button.hidden = false
        
        // Show alert
        let alertController = UIAlertController(title: "Image Saved", message:"Screen Saved to Photo Gallery", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.saveToPhotoGallery()
    }

}
