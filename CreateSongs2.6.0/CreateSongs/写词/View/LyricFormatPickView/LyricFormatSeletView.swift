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
        self.seletTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: (UIScreen.main.bounds.size.height/667) * 40 * 8))
        self.tapMaskView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        super.init(frame: frame)
        
        self.tapMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(self.tapMaskView)
        
//        self.seletTableView.bounces = false
        self.seletTableView.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
        self.seletTableView.backgroundColor = UIColor.colorFromHex("f5f5f5")
        self.seletTableView.delegate = self
        self.seletTableView.dataSource = self
        self.seletTableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        self.addSubview(self.seletTableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.seletTableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
    }
    //[[UIScreen mainScreen] bounds].size.height / 667
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * (UIScreen.main.bounds.size.height/667)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seletItemsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? LyricFormatCell
        
        if cell == nil {
             cell = LyricFormatCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
        }
        cell?.backgroundColor = UIColor.white
        cell!.giveStrForItemLabel(self.seletItemsArray.object(at: (indexPath as NSIndexPath).row) as! NSDictionary)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 埋点
        MobClick.event("xieci_select_song");
        print("埋点");
        
        let dic = self.seletItemsArray.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let dic1 = dic.mutableCopy()
        let cell: LyricFormatCell = (tableView.cellForRow(at: indexPath) as? LyricFormatCell)!
        cell.itemLabel.font = UIFont.boldSystemFont(ofSize: 15)
        (dic1 as AnyObject).setValue(cell.itemLabel.text, forKey: "title")
        (dic1 as AnyObject).setValue(cell.lyricArray, forKey: "lyric")
        
        let bgView: UIView = UIView.init(frame: cell.bounds)
        bgView.backgroundColor = UIColor.colorFromHex("ffffff")
        cell.selectedBackgroundView = bgView;
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "selectedLyricFormat"), object: dic1)
    }
    
    func selectedTableView(_ index: NSInteger) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: LyricFormatCell = (tableView.cellForRow(at: indexPath) as? LyricFormatCell)!
        cell.itemLabel.font = UIFont.systemFont(ofSize: 13)
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
        self.itemLabel.backgroundColor = UIColor.clear
        self.itemLabel.font = UIFont.systemFont(ofSize: 13)
//        self.itemLabel.textColor = UIColor.colorFromHex("#333333")
        self.itemLabel.textColor = UIColor.colorFromHex("#441D11")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.itemLabel.frame = self.bounds
        self.addSubview(self.itemLabel)
    }
    
    func giveStrForItemLabel(_ itemStr: NSDictionary) {
        
        var songTitle: NSString = ""
        var songLyric: NSString
        var lyricArray: [String]
        
        if itemStr.object(forKey: "lyric") != nil {
            songLyric = itemStr.object(forKey: "lyric") as! NSString
            //open func components(separatedBy separator: String) -> [String]
            let tmpStr:NSString = songLyric;
            lyricArray = tmpStr.components(separatedBy: ",");
            self.lyricArray = lyricArray as NSArray
            songTitle = lyricArray[0] as NSString
        }
        if itemStr.object(forKey: "title") != nil && itemStr.object(forKey: "title") as! NSString != "" {
            songTitle = itemStr.object(forKey: "title") as! NSString
        } else {
            if itemStr.object(forKey: "lyric") != nil {
                songLyric = itemStr.object(forKey: "lyric") as! NSString
                lyricArray = songLyric.components(separatedBy: ",")
                songTitle = lyricArray[0] as NSString
            }
        }
        self.itemLabel.text = songTitle as String
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.itemLabel.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 10, height: self.bounds.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

typealias didSelectFunc = (_ selectIndex: Int)-> Void

class SelectedView: UIView {
    var bgScrollView: UIScrollView
    var btnArray: NSMutableArray = []
    //var myFunc:didSelectFunc
    
    //func initWithClosure(_ closure: didSelectFunc?) {
        //myFunc = closure!
    //}
    
    override init(frame: CGRect) {
        let bgViewFrame: CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.bgScrollView = UIScrollView(frame: bgViewFrame)
        self.btnArray = []
        //self.initWithClosure(didSelected(<#T##selectIndex: NSInteger##NSInteger#>))
        super.init(frame: frame)
        self.initSubViews()
    }
    
    func didSelected(_ selectIndex: NSInteger) {
    }
    func initSubViews() {
        self.bgScrollView.backgroundColor = UIColor.red
        self.bgScrollView.contentOffset = CGPoint.zero
        self.addSubview(self.bgScrollView)
        self.createBtns()
    }
    
    func createBtns() {
        
        let btnWidth = UIScreen.main.bounds.width / 5
        let btnHeight: CGFloat = self.bounds.size.height
        var btnNames: [AnyObject] = ["空白" as AnyObject, "吐槽" as AnyObject, "祝福" as AnyObject, "文艺" as AnyObject, "表白" as AnyObject]
        for i in 0 ..< 5 {
            let selectBtn: UIButton = UIButton.init()
            selectBtn.frame = CGRect(x: CGFloat(Float(i)) * btnWidth, y: 0, width: btnWidth, height: btnHeight)
            selectBtn.setTitle(btnNames[i] as? String, for: UIControlState())
            selectBtn.setTitleColor(UIColor.black, for: UIControlState())
//            selectBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectedView.selectBtnClick(_:)))
            selectBtn.addGestureRecognizer(tapGesture)
            selectBtn.tag = i
            self.bgScrollView.addSubview(selectBtn)
//            self.btnArray.addObject(selectBtn)
        }
        self.bgScrollView.contentSize = CGSize(width: btnWidth * CGFloat(Float(5)), height: 0)
    }
    
    @objc func selectBtnClick(_ sender: UITapGestureRecognizer) {
        //if (self.myFunc != nil) {
            //let senderBtn: UIButton = sender.view as! UIButton
            //self.myFunc(senderBtn.tag)
        //}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}












 
