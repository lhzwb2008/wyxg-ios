//
//  XuanquTempModel.h
//  CreateSongs
//
//  Created by axg on 16/8/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@protocol XuanquItemsModel <NSObject>
@end
@interface XuanquItemsModel : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lrc;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *acc_wav;
@property (nonatomic, copy) NSString *acc_mp3;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *modify_time;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *time_file;
@property (nonatomic, copy) NSString *pirce;
@end

@interface XuanquTempModel : JSONModel
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSMutableArray<XuanquItemsModel> *items;
@end
