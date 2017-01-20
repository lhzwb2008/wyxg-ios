//
//  IntroduceView.h
//  CreateSongs
//
//  Created by axg on 16/3/4.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LastIntroducePic)();

@interface IntroduceView : UIView

@property (nonatomic, copy) LastIntroducePic lastIntroducPic;

@end
