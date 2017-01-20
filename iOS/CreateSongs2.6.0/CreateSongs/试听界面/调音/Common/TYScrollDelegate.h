//
//  TYScrollDelegate.h
//  SentenceMidiView
//
//  Created by axg on 16/5/30.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TYDidScroll)(CGFloat offsetX);

@interface TYScrollDelegate : NSObject <UIScrollViewDelegate>

@property (nonatomic, copy) TYDidScroll tyScrollBlock;

@end
