//
//  PopDurationViewController.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit

protocol DurationPickerViewControllerDelegate : class {
    
    func durationPickerVCDismissed(duration : NSDate?)
}

/**
    The view controller for pop over duration picker.
*/
class PopDurationViewController : UIViewController {
    
    @IBOutlet weak var durationPicker: UIDatePicker!
    weak var delegate : DurationPickerViewControllerDelegate?

    var currentDuration : NSDate? {
        didSet {
            updatePickerCurrentDuration()
        }
    }

    convenience init() {

        self.init(nibName: "PopDurationViewController", bundle: nil)
    }

    /// Updates the date value in picker.
    private func updatePickerCurrentDuration() {
        
        if let _currentDuration = self.currentDuration {
            if let _durationPicker = self.durationPicker {
                _durationPicker.date = _currentDuration
            }
        }
    }
    // Actions for clicking the ok button.
    @IBAction func okAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
            
            let nsduration = self.durationPicker.date
            self.delegate?.durationPickerVCDismissed(nsduration)
            
        }
    }
    
    override func viewDidLoad() {
        durationPicker.datePickerMode = UIDatePickerMode.CountDownTimer
        durationPicker.minuteInterval = 10
        updatePickerCurrentDuration()
    }
    
    // Actions for when the window disappears.
    override func viewDidDisappear(animated: Bool) {
        
        self.delegate?.durationPickerVCDismissed(nil)
    }
}
