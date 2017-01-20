//
//  CustomeCreateButton.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/21.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeCreateButton : UIView

@property (nonatomic, assign) BOOL customeEnable;

@property (nonatomic, strong) UILabel *title;

//要执行方法的对象
@property (nonatomic, assign) id target;
//对象自己的一个方法
@property (nonatomic, assign) SEL action;

@end
