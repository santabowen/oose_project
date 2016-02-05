//
//  PopDurationPicker.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit
/**
    A class that deals with pop over duration picker.
*/
public class PopDurationPicker : NSObject, UIPopoverPresentationControllerDelegate, DurationPickerViewControllerDelegate {
    
    public typealias PopDurationPickerCallback = (newDuration : NSDate, forTextField : UITextField)->()
    
    var durationPickerVC : PopDurationViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopDurationPickerCallback?
    var presented = false
    var offset : CGFloat = 8.0

    /// Initializes duration textfield.
    public init(forTextField: UITextField) {
        durationPickerVC = PopDurationViewController()
        self.textField = forTextField
        super.init()
    }
    
    /// When a time is picked return call back.
    public func pick(inViewController : UIViewController, initDuration : NSDate?, dataChanged : PopDurationPickerCallback) {
        
        if presented {
            return  // we are busy
        }
        
        durationPickerVC.delegate = self
        durationPickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        durationPickerVC.preferredContentSize = CGSizeMake(500,208)
        durationPickerVC.currentDuration = initDuration
        
        popover = durationPickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset,textField.bounds.size.height,0,0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(durationPickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    /// The actions to perform when view controller is dismissed.
    func durationPickerVCDismissed(duration : NSDate?) {
        
        if let _dataChanged = dataChanged {
            
            if let _duration = duration {
            
                _dataChanged(newDuration: _duration, forTextField: textField)
        
            }
        }
        presented = false
    }
}
