//
//  PopStartTimePicker.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit
/**
    A class that deals with pop over start time picker.
*/
public class PopStartTimePicker : NSObject, UIPopoverPresentationControllerDelegate, StartTimePickerViewControllerDelegate {
    
    public typealias PopStartTimePickerCallback = (newStartTime : NSDate, forTextField : UITextField)->()
    
    var startTimePickerVC : PopStartTimeViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopStartTimePickerCallback?
    var presented = false
    var offset : CGFloat = 8.0

    /// Initializes the start time.
    public init(forTextField: UITextField) {
        
        startTimePickerVC = PopStartTimeViewController()
        self.textField = forTextField
        super.init()
    }
    /// When a time is picked return a call back.
    public func pick(inViewController : UIViewController, initStartTime : NSDate?, dataChanged : PopStartTimePickerCallback) {
        
        if presented {
            return  // we are busy
        }
        
        startTimePickerVC.delegate = self
        startTimePickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        startTimePickerVC.preferredContentSize = CGSizeMake(500,208)
        startTimePickerVC.currentDate = initStartTime
        
        popover = startTimePickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset,textField.bounds.size.height,0,0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(startTimePickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    /// The actions to perform when view controller is dismissed.
    func startTimePickerVCDismissed(startTime : NSDate?){
        
        if let _dataChanged = dataChanged {
            
            if let _startTime = startTime {
            
                _dataChanged(newStartTime: _startTime, forTextField: textField)
        
            }
        }
        presented = false
    }
}
