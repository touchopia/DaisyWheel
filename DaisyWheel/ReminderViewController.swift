//
//  TableViewController.swift
//
//
//  Created by Phil Wright on 1/10/16.
//  Copyright © 2016 Touchopia, LLC. All rights reserved.
//

import UIKit

class ReminderViewController: UITableViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    open var dateToggle = true
    
    lazy var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerChanged()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dateToggle && (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0 {
            toggleDatePickerForSelectedIndexPath(indexPath)
        }
    }
    
    @IBAction func datePickerHasChanged(_ sender: AnyObject) {
        datePickerChanged()
    }
    
    func datePickerChanged () {
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    func toggleDatePickerForSelectedIndexPath(_ indexPath: IndexPath) {
        dateToggle = (dateToggle == true) ? false : true
        tableView.beginUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
    }
}
