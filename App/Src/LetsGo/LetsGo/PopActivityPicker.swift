//
//  PopActivityPicker.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit
/**
    A class that deals with pop over activity picker.
*/
public class PopActivityPicker : NSObject, UIPopoverPresentationControllerDelegate, ActivityPickerViewControllerDelegate{
    
    public typealias PopActivityPickerCallback = (newActivity : String, forTextField : UITextField)->()
    
    // The corresponding view controller.
    var activityPickerVC : PopActivityViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    
    // The actions to do when data is changed.
    var dataChanged : PopActivityPickerCallback?
    var presented = false
    var offset : CGFloat = 8.0
    var initActivityStr = ""
    
    public init(forTextField: UITextField) {
        // Initialze the view controller.
        activityPickerVC = PopActivityViewController()
        self.textField = forTextField
        super.init()
    }
    
    /// When an activity is picked, return call back.
    public func pick(inViewController : UIViewController, initActivity : String?, dataChanged : PopActivityPickerCallback) {
        
        if presented {
            return  // we are busy
        }
        
        activityPickerVC.delegate = self
        activityPickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        activityPickerVC.preferredContentSize = CGSizeMake(500,208)
        activityPickerVC.currentActivity = initActivity
        initActivityStr = initActivity!
        popover = activityPickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset,textField.bounds.size.height,0,0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(activityPickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    /// The actions to perform when view controller is dismissed.
    func activityPickerVCDismissed(activity : String?) {
        
        if let _dataChanged = dataChanged {
            
            if let _activity = activity {
                if _activity != "default"{
                    _dataChanged(newActivity: _activity, forTextField: textField)
                }
                else{
                    _dataChanged(newActivity: initActivityStr, forTextField: textField)
                }
            }
        }
        presented = false
    }
}
