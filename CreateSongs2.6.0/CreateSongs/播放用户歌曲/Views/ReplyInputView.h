//
//  AXGDelegateClass.m
//  CreateSongs
//
//  Created by axg on 16/4/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayUser_GIFT_BTN.h"
//改变根据文字改变TextView的高度
typedef void (^ContentSizeBlock)(CGSize contentSize);
//添加评论
typedef void (^replyAddBlock)(NSString *replyText,NSInteger inputTag);

typedef void(^SendGiftBlock)();

@interface ReplyInputView : UIView

@property (nonatomic,weak)UIButton *sendButton;

@property (nonatomic, strong) PlayUser_GIFT_BTN *giftButton;

@property (nonatomic,weak)UIView *tapView;

@property (nonatomic,weak)UILabel *lblPlaceholder;

@property (nonatomic,weak)UITextView *sendTextView;

@property (nonatomic, weak) UIView *bgView;

@property (nonatomic,assign)NSInteger replyTag;

@property (nonatomic, copy) NSString *preCommenter;

//block
@property (copy, nonatomic) ContentSizeBlock sizeBlock;

@property (copy,nonatomic) replyAddBlock replyBlock;

@property (nonatomic, copy) SendGiftBlock sendGiftBlock;
/**
 *  根据内容计算高度回调
 */
-(void)setContentSizeBlock:(ContentSizeBlock) block;
/**
 *  发送评论回调
 */
-(void)setReplyAddBlock:(replyAddBlock)block;

-(id)initForumReply:(CGRect)frame andAboveView:(UIView *)bgView;

-(id)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;

- (void)updateInputHeight;

@end
