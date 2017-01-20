
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
        self.plistPath = Bundle.main.path(forResource: "LyricFormat", ofType: "plist")!
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
        self.tucaoArray = NSArray().addingObjects(from: tucaoArray as [AnyObject]) as NSArray
        self.zhufuArray = NSArray().addingObjects(from: zhufuArray as [AnyObject]) as NSArray
        self.weimeiArray = NSArray().addingObjects(from: weimeiArray as [AnyObject]) as NSArray
        self.biaobaiArray = NSArray().addingObjects(from: biaobaiArray as [AnyObject]) as NSArray
        
        self.selectedView = SelectedView.init(frame: CGRect(x: 0, y: selectFrame.origin.y, width: selectFrame.width, height: 25))
        self.lyricFormatView = LYricFormatSeletView.init(frame: CGRect(x: 0, y: selectFrame.origin.y, width: UIScreen.main.bounds.width, height: selectFrame.size.height))
        self.lyricFormatView.backgroundColor = UIColor.clear
        self.lyricFormatView.autoresizesSubviews = true
        self.lyricFormatView.isHidden = true
        self.selectedViewFrame = selectFrame
        
        super.init()
        
        controllerView.view.addSubview(self.lyricFormatView)
        
//        controllerView.navView.addSubview(self.selectedView)
        
//        self.selectedView.initWithClosure(didSelected)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "didTap")
        self.lyricFormatView.seletTableView.frame = CGRect(x: self.lyricFormatView.seletTableView.frame.origin.x, y: self.lyricFormatView.seletTableView.frame.origin.y, width: self.lyricFormatView.seletTableView.frame.size.width, height: 0)
        self.lyricFormatView.tapMaskView.alpha = 0;
        self.lyricFormatView.tapMaskView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: "didTap", name: NSNotification.Name(rawValue: "selectedLyricFormat"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectedLyricFormat"), object: nil)
    }
    
    func didSelected(_ selectIndex: NSInteger) {
        
        if self.selectedIndex == selectIndex {
            self.didTap()
            return
        }
        self.showSelectView(selectIndex)
    }
    
    func didTap() {
        self.selectedIndex = 999
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.lyricFormatView.seletTableView.frame = CGRect(x: self.lyricFormatView.seletTableView.frame.origin.x, y: self.lyricFormatView.seletTableView.frame.origin.y, width: self.lyricFormatView.seletTableView.bounds.size.width, height: 0)
            self.lyricFormatView.tapMaskView.alpha = 0;
            
        }, completion: { (finished: Bool) -> Void in
            self.lyricFormatView.isHidden = true
        }) 
    }
    
    func tableViewScrollToTop(_ animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            let indexPath = IndexPath(row: 0, section: (0))
            self.lyricFormatView.seletTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
        })
    }
    
    func showSelectView(_ index: NSInteger) {
        if index == 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "selectedBlack"), object: nil)
            self.didTap()
            return
        }
        self.tableViewScrollToTop(false)
        self.lyricFormatView.isHidden = false
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
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.lyricFormatView.seletTableView.frame = CGRect(x: self.lyricFormatView.seletTableView.frame.origin.x, y: self.lyricFormatView.seletTableView.frame.origin.y, width: self.lyricFormatView.seletTableView.bounds.size.width, height: 0)
//                self.lyricFormatView.tapMaskView.alpha = 0;
                }, completion: { (finished: Bool) -> Void in
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.lyricFormatView.seletTableView.frame = CGRect(x: self.lyricFormatView.seletTableView.frame.origin.x, y: self.lyricFormatView.seletTableView.frame.origin.y, width: self.lyricFormatView.seletTableView.bounds.size.width,  height: (UIScreen.main.bounds.size.height/667) * 40 * 8)
                        self.lyricFormatView.tapMaskView.alpha = 1;
                    }) 
            }) 
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.lyricFormatView.seletTableView.frame = CGRect(x: self.lyricFormatView.seletTableView.frame.origin.x, y: self.lyricFormatView.seletTableView.frame.origin.y, width: self.lyricFormatView.seletTableView.bounds.size.width, height: 0)
                self.lyricFormatView.tapMaskView.alpha = 0;
                }, completion: { (finished: Bool) -> Void in
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.lyricFormatView.seletTableView.frame = CGRect(x: self.lyricFormatView.seletTableView.frame.origin.x, y: self.lyricFormatView.seletTableView.frame.origin.y, width: self.lyricFormatView.seletTableView.bounds.size.width,  height: (UIScreen.main.bounds.size.height/667) * 40 * 8)
                        self.lyricFormatView.tapMaskView.alpha = 1;
                    }) 
            }) 
        }
        self.selectedIndex = index;
    }
}
