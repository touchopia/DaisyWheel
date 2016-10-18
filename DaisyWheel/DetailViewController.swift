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
    
    open var capturedImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
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
        button.isHidden = true
        
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        // Show the button again
        button.isHidden = false
        
        // Show alert
        let alertController = UIAlertController(title: "Image Saved", message:"Screen Saved to Photo Gallery", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.saveToPhotoGallery()
    }
}
