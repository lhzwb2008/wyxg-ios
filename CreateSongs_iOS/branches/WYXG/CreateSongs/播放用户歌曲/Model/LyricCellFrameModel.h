//
//  LyricCellFrameModel.h
//  CreateSongs
//
//  Created by axg on 16/5/4.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LyricCellFrameModel : NSObject

@property (nonatomic, assign) CGRect songNameLabelFrame;

@property (nonatomic, assign) CGRect lyricTitleFrame;

@property (nonatomic, strong) NSMutableArray *lyricFrameArray;

@property (nonatomic, copy) NSString *lyric;

@property (nonatomic, assign) CGFloat cellHeight;


@property (nonatomic, copy) NSString *songNameStr;

@property (nonatomic, strong) NSMutableArray *lyricStrArray;

@property (nonatomic, assign) CGRect lineFrame;

@end
