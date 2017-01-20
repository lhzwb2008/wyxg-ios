//
//  TianciTableCell.m
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TianciTableCell.h"
#import "UITextField+Common.h"
#import "UILabel+Common.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const tianciIndentifier = @"tianciIndentifier";

@interface TianciTableCell ()


@property (nonatomic, strong) UILabel *formatLyric;
/**
 *  遮挡底部横线的视图
 */
@property (nonatomic, strong) UILabel *lineMaskView;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UILabel *rightNumber;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation TianciTableCell

//+ (instancetype)customTianciCellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
//   
//    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section], [indexPath row]];
//    
//    TianciTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];//不再复用
//    if (cell == nil) {
//        cell = [[TianciTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    return cell;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    _shapeLayer = [CAShapeLayer layer];
    
    self.formatLyric = [UILabel new];
    self.formatLyric.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.formatLyric.font = NORML_FONT(18*WIDTH_NIT);
    self.formatLyric.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    
    
    self.lineMaskView = [UILabel new];
    self.lineMaskView.backgroundColor = [UIColor whiteColor];
    
    self.tianciInputText = [TianciTextView new];
    self.tianciInputText.textField.font = ZHONGDENG_FONT(18*WIDTH_NIT);
    self.tianciInputText.textField.textColor = [UIColor colorWithHexString:@"#535353"];
    self.tianciInputText.shouldHaveCharacters = NO;
    WEAK_SELF;
    self.tianciInputText.textValueChangedBlock = ^(NSString *text) {
        STRONG_SELF;
        
        [self deleteOtherChar:text];
    };
    self.tianciInputText.editDidBeginBlock = ^{
        STRONG_SELF;
        self.rightNumber.hidden = NO;
    };
    self.tianciInputText.editDidEndBlock = ^{
        STRONG_SELF;
        self.rightNumber.hidden = YES;
    };
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [UIColor clearColor];

    self.rightNumber = [UILabel new];
    self.rightNumber.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    self.rightNumber.textAlignment = NSTextAlignmentRight;
    self.rightNumber.font = NORML_FONT(15*WIDTH_NIT);
    self.rightNumber.hidden = YES;
    
    [self.contentView addSubview:self.formatLyric];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.lineMaskView];
    [self.contentView addSubview:self.tianciInputText];
    [self.contentView addSubview:self.rightNumber];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize lyricSize = [@"我" getWidth:@"我" andFont:self.formatLyric.font];
    CGSize rightLabelSize = [@"00/00" getWidth:@"00/00" andFont:self.rightNumber.font];
    
    self.formatLyric.frame = CGRectMake(16*WIDTH_NIT, 34*HEIGHT_NIT, self.contentView.width-32*WIDTH_NIT-rightLabelSize.width, lyricSize.height);
    
    self.tianciInputText.frame = CGRectMake(self.formatLyric.left, self.formatLyric.bottom + 15*HEIGHT_NIT, self.formatLyric.width, self.formatLyric.height);
    
    self.rightNumber.frame = CGRectMake(self.contentView.width - rightLabelSize.width - 16*WIDTH_NIT, 0, rightLabelSize.width, rightLabelSize.height);
    self.rightNumber.centerY = self.tianciInputText.centerY;
    
    self.bottomLine.frame = CGRectMake(self.tianciInputText.left+3.5/2, self.tianciInputText.bottom-5, self.formatLyric.width, 1);
}

- (void)setTianciLyric:(NSString *)tianciLyric {
    _tianciLyric = tianciLyric;
    self.formatLyric.text = _tianciLyric;
    
    CGSize formatSize = [self.formatLyric.text getWidth:self.formatLyric.text andFont:self.formatLyric.font];
    
    
    self.bottomLine.frame = CGRectMake(self.tianciInputText.left+3.5/2, self.tianciInputText.bottom-5, formatSize.width, 1);
    CGSize lyricSize = [@"我" getWidth:@"我" andFont:self.formatLyric.font];
//    [self drawDashLine:self.bottomLine lineLength:lyricSize.width-3.5 lineSpacing:3.5 lineColor:[UIColor colorWithHexString:@"#535353"]];
    [self drawDashLine:self.bottomLine lineLength:lyricSize.width-3.5 lineSpacing:3.5 lineColor:[UIColor colorWithHexString:@"#a0a0a0"]];
    
    [self changeBottomLineMask:self.tianciInputText.textField.text];
}


- (void)drawDashLine:(UIView *)lineView lineLength:(CGFloat)lineLength lineSpacing:(CGFloat)lineSpacing lineColor:(UIColor *)lineColor {

    [_shapeLayer removeFromSuperlayer];
    
    [_shapeLayer setBounds:lineView.bounds];
    [_shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [_shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [_shapeLayer setStrokeColor:lineColor.CGColor];
    [_shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [_shapeLayer setLineJoin:kCALineJoinRound];
    [_shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithFloat:lineLength], [NSNumber numberWithFloat:lineSpacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [_shapeLayer setPath:path];
    CGPathRelease(path);
    
    [lineView.layer addSublayer:_shapeLayer];
}

- (void)setTextFieldText:(NSString *)textFieldText {
    _textFieldText = textFieldText;
}

- (void)changeBottomLineMask:(NSString *)text {
    
    NSInteger leftNumber = text.length;
    
    self.rightNumber.text = [NSString stringWithFormat:@"%ld/%ld", leftNumber, self.tianciLyric.length];

    CGSize inputSize = [self.tianciInputText.textField.text getWidth:self.tianciInputText.textField.text andFont:self.tianciInputText.textField.font];
    
    self.lineMaskView.frame = CGRectMake(self.tianciInputText.left, self.tianciInputText.top, inputSize.width, self.tianciInputText.height);
    if (leftNumber == 0) {
        self.formatLyric.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    } else {
        [self.formatLyric setColorWithRange:NSMakeRange(0, leftNumber)
                                  withColor:[UIColor colorWithHexString:@"#a06262"]];
    }
}

- (void)deleteOtherChar:(NSString *)text {
    
    UITextField *textField = self.tianciInputText.textField;
    if( textField.text.length < 1) {
        textField.rightViewMode = UITextFieldViewModeNever;
    } else {
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    if (self.tianciInputText.shouldHaveCharacters) {
        if (textField.markedTextRange == Nil && text.length > 15) {
            textField.text = [text substringToIndex:15];
        }
    }else{
        if (textField.markedTextRange == Nil) {
            NSString *temp = nil;
            NSMutableString *newText = [NSMutableString string];
            if (text.length > self.tianciLyric.length) {
                textField.text = [text substringToIndex:self.tianciLyric.length];
            }
            
            for(int i = 0; i < [text length]; i++) {
                
                temp = [text substringWithRange:NSMakeRange(i, 1)];
                
                if ([temp isEqualToString:@"～"] && i != 0) {
                    [newText appendString:temp];
                } else {
                    NSString * regex = @"^[\u4e00-\u9fa5]$";
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    BOOL isMatch = [pred evaluateWithObject:temp];
                    if (isMatch == NO) {
                        
                        textField.text = [textField.text stringByReplacingOccurrencesOfString:temp withString:@""];
                        
                        [MBProgressHUD showError:@"请输入中文"];
                    } else {
                        [newText appendString:temp];
                    }
                }
            }
            [self checkIfTurnToNext];
        }
    }
}

- (void)checkIfTurnToNext {
    UITextField *textField = self.tianciInputText.textField;
    if (textField.text.length == self.tianciLyric.length && self.turnToNextField
        //            && self.checkLyricIsAllFull
        ) {
        self.isFullLyric = YES;
        self.turnToNextField(self.tianciInputText);
        //            self.checkLyricIsAllFull();
    } else {
        self.isFullLyric = NO;
    }
    if (self.checkLyricIsAllFull) {
        self.checkLyricIsAllFull();
    }
    [self changeBottomLineMask:textField.text];
}

@end
