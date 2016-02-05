//
//  PopStartTimeViewController.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit

protocol StartTimePickerViewControllerDelegate : class {
    
    func startTimePickerVCDismissed(date : NSDate?)
}

/**
    The view controller for pop over start time picker.
*/
class PopStartTimeViewController : UIViewController {
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    weak var delegate : StartTimePickerViewControllerDelegate?

    var currentDate : NSDate? {
        didSet {
            updatePickerCurrentDate()
        }
    }

    convenience init() {

        self.init(nibName: "PopStartTimeViewController", bundle: nil)
    }
    
    /// Update the date value in the picker.
    private func updatePickerCurrentDate() {
        
        if let _currentDate = self.currentDate {
            if let _startTimePicker = self.startTimePicker {
                _startTimePicker.date = _currentDate
            }
        }
    }
    
    // Actions for clicking the ok button.
    @IBAction func okAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
            
            let nsdate = self.startTimePicker.date
            self.delegate?.startTimePickerVCDismissed(nsdate)
            
        }
    }
    
    override func viewDidLoad() {
        startTimePicker.datePickerMode = UIDatePickerMode.DateAndTime
        startTimePicker.minuteInterval = 10
        updatePickerCurrentDate()
    }
    
    // Actions for when the window disappears.
    override func viewDidDisappear(animated: Bool) {
        
        self.delegate?.startTimePickerVCDismissed(nil)
    }
}
