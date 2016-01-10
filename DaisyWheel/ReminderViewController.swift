//
//  ReminderViewController.swift
//  DaisyWheel
//
//  Created by Phil Wright on 12/1/15.
//  Copyright © 2015 Touchopia, LLC. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, UITextFieldDelegate {
    
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    
    var datePickerIsHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // set text field delegate and return type
        descriptionTextField.delegate = self
        descriptionTextField.returnKeyType = .Done
        
        // setup date format
        
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        
        // setup datePicker
        
        datePicker?.datePickerMode = .Time
        datePicker?.minuteInterval = 15
        datePicker?.date = NSDate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        datePickerChanged()
        datePickerIsHidden = true
        self.bottomContraint.constant -= self.datePicker.frame.size.height
    }
    
    @IBAction func toggleDatePicker() {
        
        if datePickerIsHidden == true {
            showDatePicker()
        } else {
            hideDatePicker()
        }
        
    }
    
    func showDatePicker() {
        
        if datePickerIsHidden == true {
            
            datePickerIsHidden = false
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.bottomContraint.constant += self.datePicker.frame.size.height
            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func hideDatePicker() {
        
        if datePickerIsHidden == false {
            datePickerIsHidden = true
        
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                self.bottomContraint.constant -= self.datePicker.frame.size.height
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @IBAction func datePickerChanged() {
        
        if let picker = datePicker {
            dateLabel.text = dateFormatter.stringFromDate(picker.date)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

