//
//  ActivityTypeCell.swift
//  LetsGo
//
//  Created by lv huizhan on 11/27/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import Foundation

class ActivityTypeCell: UITableViewCell{
    
    @IBOutlet var activityTypeName: UILabel!
    var _isSelected:Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func drawRect(rect: CGRect) {
    }
    
    func initContent() {
        activityTypeName = UILabel()
        self._isSelected = false
    }
    
    func updateCell(activityType: String, isSelected:Bool){
        activityTypeName = UILabel()
        activityTypeName = UILabel(frame: CGRectMake(0, 0, 240, 30))
        activityTypeName.center = CGPointMake(120, 30)
        activityTypeName.textAlignment = NSTextAlignment.Left
        activityTypeName.text = activityType
        self.addSubview(activityTypeName)
        self._isSelected = isSelected
        show()
    }

    func didSelect(){
        _isSelected = !_isSelected
        show()
    }
    
    func show(){
        if _isSelected == true{
            self.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            self.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
}