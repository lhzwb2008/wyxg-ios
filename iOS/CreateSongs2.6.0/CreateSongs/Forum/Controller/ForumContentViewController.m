//
//  ForumContentViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ForumContentViewController.h"
#import "AXGHeader.h"
#import "TTTAttributedLabel.h"
#import "ForumWebViewController.h"
#import "ReplyInputView.h"
#import "LoginViewController.h"
#import "emojis.h"
#import "NSString+Emojize.h"
#import "ForumCommentTableViewCell.h"
#import "ForumCommentsModel.h"
#import "XWAFNetworkTool.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "MobClick.h"
#import "AppDelegate.h"
#import "ForumCommentFrameModel.h"
#import "OtherPersonCenterController.h"
#import "ForumAlbumView.h"
#import "PlayUserSongViewController.h"

static NSString *const identifier = @"identifier";

@interface ForumContentViewController ()<UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isSendComment;

@property (nonatomic, strong) ReplyInputView *replyInputView;

@property (nonatomic, copy) NSString *commentStr;

@property (nonatomic, copy) NSString *commenterId;

@property (nonatomic, assign) CGFloat markOffset;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) ForumAlbumView *forumAlbumView;

@end

@implementation ForumContentViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    self.isSendComment = NO;
    
    self.replyCount = 0;
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self createTableView];
    [self createReplyView];
    [self createMaskView];
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyChangeShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyChangeHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendCommentAfterLogin) name:@"sendCommentAfterLoginFromForum" object:nil];
    
    [self.view bringSubviewToFront:self.navView];
    self.navTitle.text = @"详情";
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    
    [self.navLeftButton addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

//- (UIImage *)setLeftBtnImage {
//    return [UIImage imageNamed:@"返回"];
//}

- (void)leftBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化界面

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - 44 - 22) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [self getTableHeadView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ForumCommentTableViewCell class] forCellReuseIdentifier:identifier];
}

- (UIView *)getTableHeadView {

    
    CGFloat contentW = self.view.width - (16+21+45+15)*WIDTH_NIT - 15*WIDTH_NIT - 16*WIDTH_NIT;
    
    
    CGSize textSize = [self.content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:JIACU_FONT(12*WIDTH_NIT)} context:nil].size;
    

    CGFloat contentHeight = textSize.height;
    CGFloat imageHeight = contentW * (self.themeImage.size.height / self.themeImage.size.width);
    
    CGFloat albumHeight = 75 * WIDTH_NIT;

    UIView *headView = [UIView new];
    
    UIView *bottomView1 = [UIView new];
    [headView addSubview:bottomView1];
    bottomView1.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake((16+21)*WIDTH_NIT, 30 * HEIGHT_NIT, 45 * WIDTH_NIT, 45 * WIDTH_NIT)];
    [headView addSubview:headImage];
    headImage.image = self.headImage;
    headImage.layer.cornerRadius = headImage.width / 2;
    headImage.layer.masksToBounds = YES;
    headImage.layer.borderColor = THEME_COLOR.CGColor;
    headImage.layer.borderWidth = 1.5;
    
    UIButton *button = [UIButton new];
    [headView addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    button.frame = headImage.frame;
    [button addTarget:self action:@selector(turnToUserCenter) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize nameSize = [@"名字" getWidth:@"名字" andFont:TECU_FONT(12*WIDTH_NIT)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 15 * WIDTH_NIT, headImage.top+2, 200, nameSize.height)];
    [headView addSubview:nameLabel];
    nameLabel.font = TECU_FONT(12*WIDTH_NIT);
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = self.name;
    
    UIImageView *thumbView = [UIImageView new];
    CGSize nameSize2 = [self.name getWidth:self.name andFont:nameLabel.font];
    thumbView.frame = CGRectMake(nameLabel.left + nameSize2.width + 7*WIDTH_NIT, 0, 12*WIDTH_NIT, 12*WIDTH_NIT);
    thumbView.centerY = nameLabel.centerY;
    thumbView.clipsToBounds = YES;
//    thumbView.layer.cornerRadius = thumbView.height / 2;
    thumbView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [headView addSubview:thumbView];
    if ([self.gender isEqualToString:@"1"]) {
        thumbView.image = [UIImage imageNamed:@"男icon"];
    } else {
        thumbView.image = [UIImage imageNamed:@"女icon"];
    }
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 100 - 16 * WIDTH_NIT, nameLabel.top, 100, nameLabel.height)];
    [headView addSubview:timeLabel];
    timeLabel.font = NORML_FONT(10*WIDTH_NIT);
    timeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = [self intervalSinceNow:self.createTime];
    
    TTTAttributedLabel *attributeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(headImage.right + 10 * WIDTH_NIT, nameLabel.bottom + (15+9)*HEIGHT_NIT, contentW, contentHeight)];
    [headView addSubview:attributeLabel];
    attributeLabel.delegate = self;
    attributeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    attributeLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    attributeLabel.numberOfLines = 0;
    attributeLabel.font = JIACU_FONT(12*WIDTH_NIT);
    attributeLabel.text = self.content;
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    [linkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [linkAttributes setValue:(__bridge id)[UIColor blueColor].CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    attributeLabel.linkAttributes = linkAttributes;
    
    CGFloat bgHeight = 0;
    
    UIImageView *themeImage = [UIImageView new];
    
    // 专辑图片
    self.forumAlbumView = [[ForumAlbumView alloc] initWithFrame:CGRectMake(attributeLabel.left, attributeLabel.bottom + 15 * WIDTH_NIT, attributeLabel.width, albumHeight)];
    [headView addSubview:self.forumAlbumView];
    self.forumAlbumView.titleLabel.text = self.songTitle;
    self.forumAlbumView.lyricLabel.text = self.zuoci;
    self.forumAlbumView.songLabel.text = self.zuoqu;
    self.forumAlbumView.singerLabel.text = self.yanchang;
    self.forumAlbumView.themeImage.image = self.songImage;
    WEAK_SELF;
    self.forumAlbumView.touchAlbumBlock = ^ () {
        STRONG_SELF;
        
        PlayUserSongViewController *VC = [[PlayUserSongViewController alloc] init];
        VC.songCode = self.code;
        [self.navigationController pushViewController:VC animated:YES];
        
    };
    
    if (self.contentType == ImageAndAlbum) {
    
        self.forumAlbumView.hidden = NO;
        themeImage.hidden = NO;
        themeImage.frame = CGRectMake(attributeLabel.left, self.forumAlbumView.bottom + 15 * HEIGHT_NIT, attributeLabel.width, imageHeight);
        themeImage.image = self.themeImage;
        
        bgHeight = themeImage.bottom + 15*HEIGHT_NIT-(nameLabel.bottom + 9*HEIGHT_NIT);
        
    } else if (self.contentType == ImageOnly) {
        
        themeImage.hidden = NO;
        self.forumAlbumView.hidden = YES;
        themeImage.frame = CGRectMake(attributeLabel.left, attributeLabel.bottom + 15 * HEIGHT_NIT, attributeLabel.width, imageHeight);
        themeImage.image = self.themeImage;
        
        bgHeight = themeImage.bottom + 15*HEIGHT_NIT-(nameLabel.bottom + 9*HEIGHT_NIT);
        
    } else if (self.contentType == AlbumOnly) {
        
        self.forumAlbumView.hidden = NO;
        themeImage.hidden = YES;
        
        bgHeight = self.forumAlbumView.bottom + 15*HEIGHT_NIT-(nameLabel.bottom + 9*HEIGHT_NIT);
        
    } else {
        
        self.forumAlbumView.hidden = YES;
        themeImage.hidden = YES;
        
        bgHeight = attributeLabel.bottom + 15 * HEIGHT_NIT + 15*HEIGHT_NIT-(nameLabel.bottom + 9*HEIGHT_NIT);
        
    }
    
//    if (_hasPic) {
//        themeImage.frame = CGRectMake(attributeLabel.left, attributeLabel.bottom + 15 * HEIGHT_NIT, attributeLabel.width, imageHeight);
//        
//        themeImage.image = self.themeImage;
//    } else {
//        themeImage.frame = CGRectMake(attributeLabel.left, attributeLabel.bottom + 15 * HEIGHT_NIT, 0, 0);;
//    }
    [headView addSubview:themeImage];
    
    bottomView1.frame = CGRectMake(16*WIDTH_NIT, nameLabel.bottom + 9*HEIGHT_NIT, self.view.width - 32*WIDTH_NIT, bgHeight);
//    UIImageView *themeImage = [[UIImageView alloc] initWithFrame:CGRectMake(attributeLabel.left, attributeLabel.bottom + 15 * HEIGHT_NIT, attributeLabel.width, imageHeight)];
//    [headView addSubview:themeImage];
//    themeImage.image = self.themeImage;
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    line.frame = CGRectMake(0, bottomView1.bottom + 25*HEIGHT_NIT, self.view.width, 0.5);
    [headView addSubview:line];
    
    UILabel *commentTitle = [UILabel new];
    commentTitle.text = @"评论";
    commentTitle.backgroundColor = [UIColor clearColor];
    commentTitle.textColor = [UIColor colorWithHexString:@"#879999"];
    commentTitle.font = JIACU_FONT(12*WIDTH_NIT);
    CGSize titleSize = [commentTitle.text getWidth:commentTitle.text andFont:commentTitle.font];
    commentTitle.frame = CGRectMake(16*WIDTH_NIT, line.bottom + 13*HEIGHT_NIT, titleSize.width, titleSize.height);
    [headView addSubview:commentTitle];
    
    
    self.commentLabel = [UILabel new];
    [headView addSubview:self.commentLabel];
    self.commentLabel.frame = CGRectMake(commentTitle.right + 10*WIDTH_NIT, 0, 40*WIDTH_NIT, 15*WIDTH_NIT);
    self.commentLabel.centerY = commentTitle.centerY;
    self.commentLabel.clipsToBounds = YES;
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    self.commentLabel.layer.cornerRadius = self.commentLabel.height / 2;
    self.commentLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.commentLabel.backgroundColor = HexStringColor(@"#441D11");
    self.commentLabel.text = [NSString stringWithFormat:@"%ld", self.replyCount];
    self.commentLabel.font = JIACU_FONT(12*WIDTH_NIT);
    
    headView.frame = CGRectMake(0, 0, self.view.width, self.commentLabel.bottom + 10*HEIGHT_NIT);
    
    return headView;
}

- (void)createMaskView {
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor clearColor];
    self.maskView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.maskView addGestureRecognizer:tap];
    
}

#pragma mark - Action

- (void)turnToUserCenter {
    OtherPersonCenterController *personCenter = [[OtherPersonCenterController alloc] initWIthUserId:self.userId];
    [self.navigationController pushViewController:personCenter animated:YES];
}

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)tapAction:(UIGestureRecognizer *)tap {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    self.maskView.hidden = YES;
}

// 获取数据
- (void)getData {
    
    [self.dataSource removeAllObjects];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_POST_COMMENT, self.contentId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *array = resposeObject[@"items"];
            for (NSDictionary *dic in array) {
                ForumCommentsModel *model = [[ForumCommentsModel alloc] initWithDictionary:dic error:nil];
                ForumCommentFrameModel *frameModel = [ForumCommentFrameModel new];
                frameModel.commentsModel = model;
                [self.dataSource addObject:frameModel];
            }
            self.replyCount = self.dataSource.count;
            self.commentLabel.text = [NSString stringWithFormat:@"%ld", self.replyCount];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// 获取数据并滚动到顶部
- (void)getDataAndScroll {
    
    [self.dataSource removeAllObjects];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_POST_COMMENT, self.contentId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *array = resposeObject[@"items"];
            for (NSDictionary *dic in array) {
//                ForumCommentsModel *model = [[ForumCommentsModel alloc] initWithDictionary:dic error:nil];
//                [self.dataSource addObject:model];
//                
//                
                ForumCommentsModel *model = [[ForumCommentsModel alloc] initWithDictionary:dic error:nil];
                ForumCommentFrameModel *frameModel = [ForumCommentFrameModel new];
                frameModel.commentsModel = model;
                [self.dataSource addObject:frameModel];
                
            }
            self.replyCount = self.dataSource.count;
            self.commentLabel.text = [NSString stringWithFormat:@"%ld", self.replyCount];
            [self.tableView reloadData];
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
//            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.height) animated:YES];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForumCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (self.dataSource.count > indexPath.row) {
        ForumCommentFrameModel *model = self.dataSource[indexPath.row];
        cell.model = model;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForumCommentFrameModel *frameModel = self.dataSource[indexPath.row];
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    ForumCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.replyInputView.preCommenter = cell.name;
    [self.replyInputView.sendTextView becomeFirstResponder];
    self.replyInputView.lblPlaceholder.text = [NSString stringWithFormat:@"回复：%@", cell.name];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TTTAttributedDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"%@", url);
    
    ForumWebViewController *webVC = [[ForumWebViewController alloc] init];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

#pragma mark - *************发送评论**************
/**
 *  发送评论视图
 */
- (void)createReplyView {
    
    ReplyInputView *replyInputView = [[ReplyInputView alloc] initForumReply:CGRectMake(0, self.view.bounds.origin.y + self.view.frame.size.height -  50*WIDTH_NIT, screenWidth(),  50*WIDTH_NIT) andAboveView:self.view];
    [replyInputView.sendButton setTitle:@"发表" forState:UIControlStateNormal];
    replyInputView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    WEAK_SELF;
    //回调输入框的contentSize,改变工具栏的高度
    [replyInputView setContentSizeBlock:^(CGSize contentSize) {
        
        STRONG_SELF;
        [self updateHeight:contentSize];
    }];
    
    
    [replyInputView setReplyAddBlock:^(NSString *replyText, NSInteger inputTag) {
        STRONG_SELF;

        if (replyText.length > 0) {
            self.isSendComment = YES;
            [self sendComments:replyText];
        }

    }];
    
    replyInputView.replyTag = 2;
    [self.view addSubview:replyInputView];
    self.replyInputView = replyInputView;
    
    //    NSLog(@"%@", NSStringFromCGRect(self.replyInputView.frame));
}

- (void)sendCommentAfterLogin {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        //        [_renderer start];
        [self beginSendCommentWithUser:userId];
    } else {
        NSLog(@"登录失败，不能发送评论");
    }
}

//更新replyView的高度约束
-(void)updateHeight:(CGSize)contentSize {
    float height = contentSize.height + 20 + 9;
    CGRect frame = self.replyInputView.frame;
    frame.origin.y -= height - frame.size.height;  //高度往上拉伸
    frame.size.height = height;
    self.replyInputView.frame = frame;
}

// 回复评论
- (void)replayTopreCommenter:(NSString *)preCommenter {
    self.replyInputView.preCommenter = preCommenter;
    self.replyInputView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@", preCommenter];
    [self.replyInputView.sendTextView becomeFirstResponder];
}

- (void)sendComments:(NSString *)commentStr {
    
    self.commentStr = commentStr;
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    /**
     *  没有登录 本地不能找到userId则弹出登录页面
     */
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        //        [_renderer start];
        
        [self beginSendCommentWithUser:userId];
    } else {
        NSLog(@"评论需要登录哦");
        
        //         设置登录位置为评论，弹出登录窗口
        [[NSUserDefaults standardUserDefaults] setObject:LOGIN_LOCATION_FORUM_COMMENT forKey:LOGIN_LOCATION];
        
        AXG_LOGIN(LOGIN_LOCATION_FORUM_COMMENT);
        
    }
    self.replyInputView.sendTextView.text = @"";
    [self.replyInputView updateInputHeight];
    //    self.replyInputView.replyBlock(self.replyInputView.sendTextView.text, self.replyInputView.replyTag);
}

- (void)beginSendCommentWithUser:(NSString *)userId {
    
    if (_commentStr.length != 0) {

//        NSString *preComment = [self.commentStr preEmojizedString];
        NSString *preComment = self.commentStr;
        
        NSLog(@"预处理过的评论%@", preComment);
        
        NSString *commentUrl = @"";
        if (self.replyInputView.preCommenter.length != 0) {
            commentUrl = [NSString stringWithFormat:ADD_POST_COMMENT, userId, self.contentId, preComment, self.replyInputView.preCommenter];
//            commentUrl = @"";
            
            WEAK_SELF;
            NSLog(@"%@", commentUrl);
            [XWAFNetworkTool getUrl:commentUrl body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                STRONG_SELF;
                [MobClick event:@"post_send_comments"];
                NSLog(@"评论成功%@",resposeObject);
                
//#if ALLOW_MSG
//                if (![self.commenterId isEqualToString:userId]) {
//                    /*msg type 3 回复评论*/
//                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.commenterId, userId, @"3", self.song_id, preComment, self.soundName] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//                        
//                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                        
//                    }];
//                }
//                
//                if (![self.user_id isEqualToString:userId]) {
//                    /*msg type 1 评论*/
//                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.user_id, userId, @"1", self.song_id, preComment, self.soundName] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//                        
//                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                        
//                    }];
//                }
//                
//#endif
                
                self.replyInputView.preCommenter = @"";
#warning 获取评论刷新界面
                [self getDataAndScroll];
                
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"发送评论失败%@", error.description);
                self.replyInputView.preCommenter = @"";
            }];
            
        } else {
            commentUrl = [NSString stringWithFormat:ADD_POST_COMMENT, userId, self.contentId, preComment, @""];
//            commentUrl = @"";
            
            WEAK_SELF;
            NSLog(@"%@", commentUrl);
            [XWAFNetworkTool getUrl:commentUrl body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                STRONG_SELF;
                NSLog(@"评论成功%@",resposeObject);
                
//#if ALLOW_MSG
//                if (![self.user_id isEqualToString:userId]) {
//                    /*msg type 1 评论*/
//                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.user_id, userId, @"1", self.song_id, preComment, self.soundName] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//                        
//                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                        
//                    }];
//                }
//                
//#endif
                
                self.replyInputView.preCommenter = @"";
                #warning 获取评论刷新界面
                [self getDataAndScroll];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"发送评论失败%@", error.description);
                self.replyInputView.preCommenter = @"";
            }];
            
        }
    }
    
}

#pragma mark - *************键盘通知**************

- (void)keyboardWillChangeFrame:(NSNotification *)notify {
    NSDictionary *dic = notify.userInfo;
    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //    if (keyboardRect.size.height >250 && self.flag) {
    if (keyboardRect.size.height >100) {
        WEAK_SELF;
        [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            STRONG_SELF;
            [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            
            self.replyInputView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
            
            self.maskView.frame = CGRectMake(0, 0, self.view.width, self.view.height - keyboardRect.size.height - 62);
            
        }];
    }
}

//键盘出来的时候调整replyView的位置
- (void) keyChangeShow:(NSNotification *) notify {
    
    self.maskView.hidden = NO;
    
    if ([UIResponder currentFirstResponder] == self.replyInputView.sendTextView) {
        
    }
    
    NSDictionary *dic = notify.userInfo;
    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    if (keyboardRect.size.height >100) {
        WEAK_SELF;
        [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            STRONG_SELF;
            [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            
            self.replyInputView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
        }];
    }
}

//键盘出来的时候调整replyView的位置
-(void) keyChangeHide:(NSNotification *) notify {
    
    self.maskView.hidden = YES;
    
    if ([UIResponder currentFirstResponder] == self.replyInputView.sendTextView) {
    }
    
    self.replyInputView.preCommenter = @"";
    self.replyInputView.lblPlaceholder.text = @"输入评论";
    
    NSDictionary *dic = notify.userInfo;
    //    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    WEAK_SELF;
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        STRONG_SELF;
        [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        
        self.replyInputView.transform = CGAffineTransformIdentity;
        
        //        self.mainTableView.transform = CGAffineTransformIdentity;
        
    }completion:^(BOOL finished) {
        //        NSLog(@"%@", NSStringFromCGRect(self.replyInputView.frame));
    }];
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY - self.markOffset < -5) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
    }
    self.markOffset = offsetY;
    
}

- (NSString *)intervalSinceNow: (NSString *) theDate {
    
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1.0;
    
    NSDate* dat = [NSDate date];
    
    NSTimeInterval now=[dat timeIntervalSince1970]*1.0;
    
    NSString *timeString=@"";
    
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        
        if (cha < 0) {
            timeString=@"刚刚";
        } else {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    if (cha/3600>1&&cha/86400<1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        
    }
    if (cha/86400>1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    
    return timeString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
