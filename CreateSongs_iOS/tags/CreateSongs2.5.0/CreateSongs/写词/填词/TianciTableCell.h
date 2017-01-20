//
//  TianciTableCell.h
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TianciTextView.h"

typedef void(^TurnToNextField)(TianciTextView *currentInputView);

typedef void(^CheckLyricIsAllFull)();

@interface TianciTableCell : UITableViewCell

@property (nonatomic, strong) TianciTextView *tianciInputText;

@property (nonatomic, copy) NSString *tianciLyric;

@property (nonatomic, copy) TurnToNextField turnToNextField;

@property (nonatomic, copy) CheckLyricIsAllFull checkLyricIsAllFull;

@property (nonatomic, copy) NSString *textFieldText;
/**
 *  歌词是否填满
 */
@property (nonatomic, assign) BOOL isFullLyric;

//+ (instancetype)customTianciCellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath;

@end
