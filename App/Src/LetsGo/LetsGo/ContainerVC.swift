import UIKit

/**
 This container class is the whole structure of the app. It split the view into two containers, the menu on the left and the other content on the right.
*/
class ContainerVC : UIViewController {
    
    // This value matches the left menu's width in the Storyboard
    let leftMenuWidth:CGFloat = 260
    
    // Need a handle to the scrollView to open and close the menu
    @IBOutlet weak var scrollView: UIScrollView!
    
    /**
     view did load
    */
    override func viewDidLoad() {
        
        // Initially close menu programmatically.  This needs to be done on the main thread initially in order to work.
        dispatch_async(dispatch_get_main_queue()) {
            self.closeMenu(true)
        }
        
        // Tab bar controller's child pages have a top-left button toggles the menu
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu", name: "toggleMenu", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenuViaNotification", name: "closeMenuViaNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableScrollView", name: "enableScroll", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableScrollView", name: "disableScroll", object: nil)
        
//        scrollView.setContentOffset(CGPoint(x: 260, y: 0), animated: false)
//        print(self.scrollView.frame)
    }
    
    /**
     first initial the content view, show the view in right container, hide the memu
    */
    override func viewDidAppear(animated: Bool) {
       self.closeMenu(true)
//       print("appear again")
//       print(self.scrollView.frame)
    }
    /**
    Cleanup notifications added in viewDidLoad
    */
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     click the menu, open or close the menu
    */
    func toggleMenu(){
        scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
    }
    
    /**
    This wrapper function is necessary because
    closeMenu params do not match up with Notification
    */
    func closeMenuViaNotification(){
        closeMenu()
    }
    
    /**
    Use scrollview content offset-x to slide the menu.
    */
    func closeMenu(animated:Bool = true){
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
        NSNotificationCenter.defaultCenter().postNotificationName("enableRightWindowInteraction", object: nil)
    }
    
    /**
    Open is the natural state of the menu because of how the storyboard is setup.
    */
    func openMenu(){
//        print("opening menu")
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        NSNotificationCenter.defaultCenter().postNotificationName("disableRightWindowInteraction", object: nil)
    }
    
    /**
    When mainactivity, new activity view and map view showed, ensable scrolling.
    */
    func enableScrollView() {
        scrollView.scrollEnabled = true
    }
    
    /**
     When the other view showed except for mainactivity, new activity view, map view, disable scrolling.
     */
    func disableScrollView() {
        scrollView.scrollEnabled = false
    }
}

extension ContainerVC : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x:: \(scrollView.contentOffset.x)")
    }
    
    /**
    // When paging is enabled on a Scroll View, 
    // a private method _adjustContentOffsetIfNecessary gets called,
    // presumably when present whatever controller is called.
    // The idea is to disable paging.
    // But we rely on paging to snap the slideout menu in place 
    // (if you're relying on the built-in pan gesture).
    // So the approach is to keep paging disabled.  
    // But enable it at the last minute during scrollViewWillBeginDragging.
    // And then turn it off once the scroll view stops moving.
    // 
    // Approaches that don't work:
    // 1. automaticallyAdjustsScrollViewInsets -- don't bother
    // 2. overriding _adjustContentOffsetIfNecessary -- messing with private methods is a bad idea
    // 3. disable paging altogether.  works, but at the loss of a feature
    // 4. nest the scrollview inside UIView, so UIKit doesn't mess with it.  may have worked before,
    //    but not anymore.
    */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollView.pagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollView.pagingEnabled = false
        if scrollView.contentOffset.x == leftMenuWidth {
        NSNotificationCenter.defaultCenter().postNotificationName("enableRightWindowInteraction", object: nil)
        } else {
        NSNotificationCenter.defaultCenter().postNotificationName("disableRightWindowInteraction", object: nil)
        }
    }
}
