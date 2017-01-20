//
//  LyricFormatSeletView.swift
//  CreateSongs
//
//  Created by axg on 16/6/28.
//  Copyright © 2016年 AXG. All rights reserved.
//

import UIKit

class LYricFormatSeletView: UIView, UITableViewDelegate, UITableViewDataSource {
    var seletItemsArray: NSArray = []
    var seletTableView: UITableView
    var tapMaskView: UIView

    override init(frame: CGRect) {
        self.seletItemsArray = NSArray()
        self.seletTableView = UITableView.init(frame: CGRectMake(0, 0, frame.size.width, (UIScreen.mainScreen().bounds.size.height/667) * 40 * 8))
        self.tapMaskView = UIView.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        
        super.init(frame: frame)
        
        self.tapMaskView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.addSubview(self.tapMaskView)
        
//        self.seletTableView.bounces = false
        self.seletTableView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin
        self.seletTableView.backgroundColor = UIColor.colorFromHex("f5f5f5")
        self.seletTableView.delegate = self
        self.seletTableView.dataSource = self
        self.seletTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.addSubview(self.seletTableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.seletTableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
    }
    //[[UIScreen mainScreen] bounds].size.height / 667
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40 * (UIScreen.mainScreen().bounds.size.height/667)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seletItemsArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? LyricFormatCell
        
        if cell == nil {
             cell = LyricFormatCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        cell?.backgroundColor = UIColor.whiteColor()
        cell!.giveStrForItemLabel(self.seletItemsArray.objectAtIndex(indexPath.row) as! NSDictionary)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        // 埋点
        MobClick.event("xieci_select_song");
        print("埋点");
        
        let dic = self.seletItemsArray.objectAtIndex(indexPath.row) as! NSDictionary
        let dic1 = dic.mutableCopy()
        let cell: LyricFormatCell = (tableView.cellForRowAtIndexPath(indexPath) as? LyricFormatCell)!
        cell.itemLabel.font = UIFont.boldSystemFontOfSize(15)
        dic1.setValue(cell.itemLabel.text, forKey: "title")
        dic1.setValue(cell.lyricArray, forKey: "lyric")
        
        let bgView: UIView = UIView.init(frame: cell.bounds)
        bgView.backgroundColor = UIColor.colorFromHex("ffffff")
        cell.selectedBackgroundView = bgView;
        
        NSNotificationCenter.defaultCenter().postNotificationName("selectedLyricFormat", object: dic1)
    }
    
    func selectedTableView(index: NSInteger) {
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: LyricFormatCell = (tableView.cellForRowAtIndexPath(indexPath) as? LyricFormatCell)!
        cell.itemLabel.font = UIFont.systemFontOfSize(13)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LyricFormatCell: UITableViewCell {
    
    var itemLabel: UILabel
    var lyricArray: NSArray = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.itemLabel = UILabel()
        self.itemLabel.backgroundColor = UIColor.clearColor()
        self.itemLabel.font = UIFont.systemFontOfSize(13)
//        self.itemLabel.textColor = UIColor.colorFromHex("#333333")
        self.itemLabel.textColor = UIColor.colorFromHex("#441D11")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.itemLabel.frame = self.bounds
        self.addSubview(self.itemLabel)
    }
    
    func giveStrForItemLabel(itemStr: NSDictionary) {
        
        var songTitle: NSString = ""
        var songLyric: NSString
        var lyricArray: NSArray
        
        if itemStr.objectForKey("lyric") != nil {
            songLyric = itemStr.objectForKey("lyric") as! NSString
            lyricArray = songLyric.componentsSeparatedByString(",")
            self.lyricArray = lyricArray
            songTitle = lyricArray.firstObject as! NSString
        }
        if itemStr.objectForKey("title") != nil && itemStr.objectForKey("title") as! NSString != "" {
            songTitle = itemStr.objectForKey("title") as! NSString
        } else {
            if itemStr.objectForKey("lyric") != nil {
                songLyric = itemStr.objectForKey("lyric") as! NSString
                lyricArray = songLyric.componentsSeparatedByString(",")
                songTitle = lyricArray.firstObject as! NSString
            }
        }
        self.itemLabel.text = songTitle as String
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.itemLabel.frame = CGRectMake(10, 0, self.bounds.size.width - 10, self.bounds.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

typealias didSelectFunc = (selectIndex: Int)-> Void

class SelectedView: UIView {
    var bgScrollView: UIScrollView
    var btnArray: NSMutableArray = []
    var myFunc = didSelectFunc?()
    
    func initWithClosure(closure: didSelectFunc?) {
        myFunc = closure
    }
    
    override init(frame: CGRect) {
        let bgViewFrame: CGRect = CGRectMake(0, 0, frame.size.width, frame.size.height)
        self.bgScrollView = UIScrollView(frame: bgViewFrame)
        self.btnArray = []
        super.init(frame: frame)
        self.initSubViews()
    }
    
    func initSubViews() {
        self.bgScrollView.backgroundColor = UIColor.redColor()
        self.bgScrollView.contentOffset = CGPointZero
        self.addSubview(self.bgScrollView)
        self.createBtns()
    }
    
    func createBtns() {
        
        let btnWidth = UIScreen.mainScreen().bounds.width / 5
        let btnHeight: CGFloat = self.bounds.size.height
        var btnNames: [AnyObject] = ["空白", "吐槽", "祝福", "文艺", "表白"]
        for var i = 0; i < 5; i++ {
            let selectBtn: UIButton = UIButton.init()
            selectBtn.frame = CGRectMake(CGFloat(Float(i)) * btnWidth, 0, btnWidth, btnHeight)
            selectBtn.setTitle(btnNames[i] as? String, forState: UIControlState.Normal)
            selectBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//            selectBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            let tapGesture = UITapGestureRecognizer(target: self, action: "selectBtnClick:")
            selectBtn.addGestureRecognizer(tapGesture)
            selectBtn.tag = i
            self.bgScrollView.addSubview(selectBtn)
//            self.btnArray.addObject(selectBtn)
        }
        self.bgScrollView.contentSize = CGSizeMake(btnWidth * CGFloat(Float(5)), 0)
    }
    
    func selectBtnClick(sender: UITapGestureRecognizer) {
        if (self.myFunc != nil) {
            let senderBtn: UIButton = sender.view as! UIButton
            self.myFunc!(selectIndex: senderBtn.tag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}












 