//
//  AvatarCell.swift
//  ExpandingView
//
//  Created by Xi Yang on 11/7/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import UIKit

/**
 AvatarCell class was used in activity detailed view, it shows the avatars of group members
*/
class AvatarCell : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    var isObserving = false;
    
    @IBOutlet weak var avatarCollectionView: UICollectionView!
    var imageArray = [UIImage]()
    var userIdArray = [Int]()
    
    /** 
    initial frame of each cell in the content
    */

    func initContent() {
        var height:CGFloat = CGFloat(imageArray.count/8)
        if imageArray.count%8 != 0 {
            height += 1
        }
        height *= 50
        
        avatarCollectionView.frame = CGRectMake(avatarCollectionView.frame.minX, avatarCollectionView.frame.minY, avatarCollectionView.frame.width, height)
        
        avatarCollectionView.scrollEnabled = false
    }
    
    /**
     add the oberver
     */

    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Initial], context: nil)
            isObserving = true;
        }
    }
    
    /**
     remove the oberver
     */
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            NSNotificationCenter.defaultCenter().removeObserver(self)
            isObserving = false;
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            
            initContent()
        }
    }
    
    /**
     initial each content(member's avatar) in the view
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        initContent()
        return self.imageArray.count
    }
    
    /**
     initial frame of each cell in the content
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("avatarCell", forIndexPath: indexPath) as! SingleAvatarCell

        cell.imageAvatar?.image = self.imageArray[indexPath.row]
        
        return cell
        
    }
    
    /**
     return the avatar index, when click the cell
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(self.userIdArray[indexPath.row]   )
        NSNotificationCenter.defaultCenter().postNotificationName("clickAvatar", object: nil, userInfo: ["row": self.userIdArray[indexPath.row]])
    }
    
}





