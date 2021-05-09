//
//  ChooseSingerCell.h
//  CreateSongs
//
//  Created by axg on 16/9/28.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseSingerCell : UITableViewCell

@property (nonatomic, copy) NSString *singer_name;
@property (nonatomic, copy) NSString *singer_id;

@property (nonatomic, strong) UILabel *nameLabel;

@end
