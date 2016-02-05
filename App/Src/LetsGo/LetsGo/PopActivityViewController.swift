//
//  PopActivityViewController.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit

protocol ActivityPickerViewControllerDelegate : class {
    
    func activityPickerVCDismissed(activity : String?)
}
/**
    The view controller for pop over acitivty picker.
*/
class PopActivityViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var activityPicker: UIPickerView!
    
    weak var delegate : ActivityPickerViewControllerDelegate?

    // This variable saves the row of chosen activity.
    var chosen : Int?
    
    //FIXME: Consider removing this to GlobalVar
    // The list for possible activities.
    let pickerActivityData = ["Basketball", "Badminton", "Jogging", "Gym", "Tennis"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerActivityData.count
    }
    
    // Gets the title of activity for a row.
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerActivityData[row]
    }
    
    // Chooses a row.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        chosen = row
    }

    var currentActivity : String? {
        didSet {
            updatePickerCurrentActivity()
        }
    }

    convenience init() {
        self.init(nibName: "PopActivityViewController", bundle: nil)
    }
    
    /// Updates the activity value in the picker.
    private func updatePickerCurrentActivity() {
        
        if let _chosenrow = self.chosen {
            if let _activityPicker = self.activityPicker {
                _activityPicker.selectRow(_chosenrow, inComponent: 0, animated: false)
            }
        }
    }
    
    // Actions for clicking the ok button.
    @IBAction func okAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
            if self.chosen == nil{
                self.delegate?.activityPickerVCDismissed("default")
            }
            else{
                self.delegate?.activityPickerVCDismissed(self.pickerActivityData[(self.chosen)!])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosen = nil
        activityPicker.dataSource = self
        activityPicker.delegate = self
        updatePickerCurrentActivity()
    }

    // Actions for when the window disappears.
    override func viewDidDisappear(animated: Bool) {
        self.delegate?.activityPickerVCDismissed(nil)
    }
}
