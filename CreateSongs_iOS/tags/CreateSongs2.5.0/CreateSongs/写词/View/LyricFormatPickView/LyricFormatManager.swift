//
//  LyricFormatManager.swift
//  CreateSongs
//
//  Created by axg on 16/6/29.
//  Copyright © 2016年 AXG. All rights reserved.
//

import UIKit


/*
 *  管理下拉显示逻辑类
 */
class lyricFormatManager: NSObject {
    
    var selectedIndex: NSInteger = 999
    var plistPath: String = ""
    var selectedView: SelectedView
    var tucaoArray: NSArray = []
    var zhufuArray: NSArray = []
    var weimeiArray: NSArray = []
    var biaobaiArray: NSArray = []
    
    
    var selectedViewFrame: CGRect
    var lyricFormatView: LYricFormatSeletView
    
    init(controllerView: XieciViewController, selectFrame: CGRect, tucaoArray: NSArray, zhufuArray: NSArray, weimeiArray: NSArray, biaobaiArray: NSArray) {
        self.plistPath = NSBundle.mainBundle().pathForResource("LyricFormat", ofType: "plist")!
        let lyricDic: NSMutableDictionary = NSMutableDictionary(contentsOfFile: self.plistPath)!
        
//        for dic in tucao {
//            let tmpDic: NSDictionary = dic as! NSDictionary
//            let typeStr = tmpDic.objectForKey("type")
//            if typeStr!.isEqualToString("1") {
//
//            } else if typeStr!.isEqualToString("2") {
//                
//            }
//        }
        self.tucaoArray = NSArray().arrayByAddingObjectsFromArray(tucaoArray as [AnyObject])
        self.zhufuArray = NSArray().arrayByAddingObjectsFromArray(zhufuArray as [AnyObject])
        self.weimeiArray = NSArray().arrayByAddingObjectsFromArray(weimeiArray as [AnyObject])
        self.biaobaiArray = NSArray().arrayByAddingObjectsFromArray(biaobaiArray as [AnyObject])
        
        self.selectedView = SelectedView.init(frame: CGRectMake(0, selectFrame.origin.y, selectFrame.width, 25))
        self.lyricFormatView = LYricFormatSeletView.init(frame: CGRectMake(0, selectFrame.origin.y, UIScreen.mainScreen().bounds.width, selectFrame.size.height))
        self.lyricFormatView.backgroundColor = UIColor.clearColor()
        self.lyricFormatView.autoresizesSubviews = true
        self.lyricFormatView.hidden = true
        self.selectedViewFrame = selectFrame
        
        super.init()
        
        controllerView.view.addSubview(self.lyricFormatView)
        
//        controllerView.navView.addSubview(self.selectedView)
        
//        self.selectedView.initWithClosure(didSelected)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "didTap")
        self.lyricFormatView.seletTableView.frame = CGRectMake(self.lyricFormatView.seletTableView.frame.origin.x, self.lyricFormatView.seletTableView.frame.origin.y, self.lyricFormatView.seletTableView.frame.size.width, 0)
        self.lyricFormatView.tapMaskView.alpha = 0;
        self.lyricFormatView.tapMaskView.addGestureRecognizer(tapGesture)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didTap", name: "selectedLyricFormat", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "selectedLyricFormat", object: nil)
    }
    
    func didSelected(selectIndex: NSInteger) {
        
        if self.selectedIndex == selectIndex {
            self.didTap()
            return
        }
        self.showSelectView(selectIndex)
    }
    
    func didTap() {
        self.selectedIndex = 999
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.lyricFormatView.seletTableView.frame = CGRectMake(self.lyricFormatView.seletTableView.frame.origin.x, self.lyricFormatView.seletTableView.frame.origin.y, self.lyricFormatView.seletTableView.bounds.size.width, 0)
            self.lyricFormatView.tapMaskView.alpha = 0;
            
        }) { (finished: Bool) -> Void in
            self.lyricFormatView.hidden = true
        }
    }
    
    func tableViewScrollToTop(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            let indexPath = NSIndexPath(forRow: 0, inSection: (0))
            self.lyricFormatView.seletTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
        })
    }
    
    func showSelectView(index: NSInteger) {
        if index == 0 {
            NSNotificationCenter.defaultCenter().postNotificationName("selectedBlack", object: nil)
            self.didTap()
            return
        }
        self.tableViewScrollToTop(false)
        self.lyricFormatView.hidden = false
        switch index {
        case 1:
            self.lyricFormatView.seletItemsArray = self.tucaoArray
            self.lyricFormatView.seletTableView.reloadData()
            break
        case 2:
            self.lyricFormatView.seletItemsArray = self.zhufuArray
            self.lyricFormatView.seletTableView.reloadData()
            break
        case 3:
            self.lyricFormatView.seletItemsArray = self.weimeiArray
            self.lyricFormatView.seletTableView.reloadData()
            break
        case 4:
            self.lyricFormatView.seletItemsArray = self.biaobaiArray
            self.lyricFormatView.seletTableView.reloadData()
            break
        default:
            break
        }
        if self.selectedIndex != 999 {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.lyricFormatView.seletTableView.frame = CGRectMake(self.lyricFormatView.seletTableView.frame.origin.x, self.lyricFormatView.seletTableView.frame.origin.y, self.lyricFormatView.seletTableView.bounds.size.width, 0)
//                self.lyricFormatView.tapMaskView.alpha = 0;
                }) { (finished: Bool) -> Void in
                    UIView.animateWithDuration(0.3) { () -> Void in
                        self.lyricFormatView.seletTableView.frame = CGRectMake(self.lyricFormatView.seletTableView.frame.origin.x, self.lyricFormatView.seletTableView.frame.origin.y, self.lyricFormatView.seletTableView.bounds.size.width,  (UIScreen.mainScreen().bounds.size.height/667) * 40 * 8)
                        self.lyricFormatView.tapMaskView.alpha = 1;
                    }
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.lyricFormatView.seletTableView.frame = CGRectMake(self.lyricFormatView.seletTableView.frame.origin.x, self.lyricFormatView.seletTableView.frame.origin.y, self.lyricFormatView.seletTableView.bounds.size.width, 0)
                self.lyricFormatView.tapMaskView.alpha = 0;
                }) { (finished: Bool) -> Void in
                    UIView.animateWithDuration(0.3) { () -> Void in
                        self.lyricFormatView.seletTableView.frame = CGRectMake(self.lyricFormatView.seletTableView.frame.origin.x, self.lyricFormatView.seletTableView.frame.origin.y, self.lyricFormatView.seletTableView.bounds.size.width,  (UIScreen.mainScreen().bounds.size.height/667) * 40 * 8)
                        self.lyricFormatView.tapMaskView.alpha = 1;
                    }
            }
        }
        self.selectedIndex = index;
    }
}
