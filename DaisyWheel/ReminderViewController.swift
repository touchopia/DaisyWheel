//
//  ReminderViewController.swift
//  DaisyWheel
//
//  Created by Phil Wright on 12/1/15.
//  Copyright © 2015 Touchopia, LLC. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {
    
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        datePicker.datePickerMode = .DateAndTime
        datePicker.date = NSDate()
        datePickerChanged()
    }
    
    @IBAction func datePickerChanged() {
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        dateLabel.text = dateFormatter.stringFromDate(datePicker.date)
    }

}

