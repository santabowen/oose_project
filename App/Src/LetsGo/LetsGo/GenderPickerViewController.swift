//
//  GenderPickerViewController.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 11/6/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import UIKit

protocol GenderPickerViewControllerDelegate
{
    func saveText(var strText : NSString)
}

/// a controller that controlls the gender picker.
class GenderPickerViewController: UIViewController {
    
    var genderText: String?
    var delegate : GenderPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// save the chosen gender to the signup view.
    @IBAction func chooseGender(sender: UIButton)
    {
        if((self.delegate) != nil)
        {
            delegate?.saveText(sender.titleLabel!.text!);
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

