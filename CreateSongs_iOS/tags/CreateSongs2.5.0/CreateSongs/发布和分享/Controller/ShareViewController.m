//
//  ShareViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/23.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ShareViewController.h"
#import "AXGHeader.h"
#import "AppDelegate.h"
#import "MobClick.h"
#import "WXApi.h"
#import "UMSocial.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "MobClick.h"
#import "AFNetworking.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "KVNProgress.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "ShareButton.h"
#import "UserModel.h"

@interface ShareViewController ()<WXApiDelegate, UMSocialUIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *shareMaskView;

@property (nonatomic, strong) UIButton *weChatShare;
@property (nonatomic, strong) UIButton *friendShare;
@property (nonatomic, strong) UIButton *QQShare;
@property (nonatomic, strong) UIButton *QZoneShare;
@property (nonatomic, strong) UIButton *weiboShare;
@property (nonatomic, strong) UIButton *urlShare;

@property (nonatomic, strong) UILabel *weChatLabel;
@property (nonatomic, strong) UILabel *friendLabel;
@property (nonatomic, strong) UILabel *QQLabel;
@property (nonatomic, strong) UILabel *QZoneLabel;
@property (nonatomic, strong) UILabel *weiboLabel;
@property (nonatomic, strong) UILabel *urlLabel;

@property (nonatomic, strong) UILabel *shareLable;
@property (nonatomic, strong) UIButton *closeButton;

//@property (nonatomic, assign) BOOL isAgree;

@property (nonatomic, strong) UIImage *avatar;

@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIImageView *preImageView;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *uploadCode;

// 记录缩放大小
@property (nonatomic, assign) CGFloat lastScale;

// 记录旋转角度
@property (nonatomic, assign) CGFloat lastRotation;

// 记录X坐标
@property (nonatomic, assign) CGFloat firstX;

// 记录Y坐标
@property (nonatomic, assign) CGFloat firstY;

@property (nonatomic, strong) UILabel *shareName;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *robotDataSource;

@property (nonatomic, strong) NSMutableArray *robotCommentsDataSource;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.robotDataSource = [[NSMutableArray alloc] initWithCapacity:0];
//    self.robotCommentsDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.view.backgroundColor = HexStringColor(@"#eeeeee");
    self.lyricStr = @"";
    
    [self getSongInfo];
    
    [self initNavView];
    [self createUploadSuccess];
    [self createShareView];

}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    self.navTitle.text = @"分享";
    
    [self.navLeftButton setTitle:@"个人" forState:UIControlStateNormal];

    [self.navRightButton setTitle:@"首页" forState:UIControlStateNormal];
    
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navRightButton addTarget:self action:@selector(backToHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 上传成功图标
- (void)createUploadSuccess {
    UIImageView *succussImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 65 * HEIGHT_NIT, 150 * WIDTH_NIT, 150 * WIDTH_NIT)];
    [self.view addSubview:succussImage];
    succussImage.center = CGPointMake(self.view.width / 2, succussImage.centerY);
    succussImage.image = [UIImage imageNamed:@"分享成功"];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 * WIDTH_NIT, succussImage.bottom + 20 * HEIGHT_NIT, self.view.width - 80 * WIDTH_NIT, 40 * HEIGHT_NIT + 18 * HEIGHT_NIT)];
    [self.view addSubview:successLabel];
    successLabel.numberOfLines = 2;
    
    if (self.isAgree) {
        
        successLabel.text = @"发布成功";
        
    } else {
        
        successLabel.text = @"作品已保存至个人";
        
        [MobClick event:@"release_notRelease"];
    }
    
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.font = NORML_FONT(18);
    successLabel.textColor = HexStringColor(@"#441D11");
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(12.5 * WIDTH_NIT, successLabel.bottom + 120 * HEIGHT_NIT - 25, 350 * WIDTH_NIT, 0.5)];
    
    [self.view addSubview:self.lineView];
    
}

/**
 *  创建分享界面
 */
- (void)createShareView {
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - (50 * WIDTH_NIT + 6 * HEIGHT_NIT + 12 * HEIGHT_NIT + 30 * HEIGHT_NIT) * 2 - 10 * HEIGHT_NIT, self.view.width, (50 * WIDTH_NIT + 6 * HEIGHT_NIT + 12 * HEIGHT_NIT + 30 * HEIGHT_NIT) * 2 + 10 * HEIGHT_NIT)];
    [self.view addSubview:self.shareView];
    
    CGRect frame1;// 微信
    CGRect frame2;// 朋友圈
    CGRect frame3;// QQ
    CGRect frame4;// qq空间
    CGRect frame5;// 新浪微博
    CGRect frame6;// 链接
    NSString *title1 = nil;
    NSString *title2 = nil;
    NSString *title3 = nil;
    NSString *title4 = nil;
    NSString *title5 = nil;
    NSString *title6 = nil;
    
    title1 = @"微信";
    title2 = @"朋友圈";
    title3 = @"QQ";
    title4 = @"QQ空间";
    title5 = @"微博";
    title6 = @"复制链接";
    
    CGFloat leftGap = (self.view.width - 40*WIDTH_NIT * 5 - 26*WIDTH_NIT*4)/2;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
#warning fortest remember delete
    // 测试用
//        app.wxIsInstall = YES;
//        app.QQIsInstall = YES;
//        app.weiboInstall = YES;
    
    if (app.wxIsInstall == YES && app.QQIsInstall == YES) {
        
        frame1 = CGRectMake(55 * WIDTH_NIT, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        frame2 = CGRectMake(frame1.origin.x + frame1.size.width + 57.5 * WIDTH_NIT, frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        frame5 = CGRectMake(frame2.origin.x + frame2.size.width + 57.5 * WIDTH_NIT, frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        
        frame3 = CGRectMake(frame1.origin.x, frame1.origin.y + frame1.size.height + 48 * HEIGHT_NIT, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        frame4 = CGRectMake(frame3.origin.x + frame3.size.width + 57.5 * WIDTH_NIT, frame3.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        frame6 = CGRectMake(frame4.origin.x + frame4.size.width + 57.5 * WIDTH_NIT, frame4.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        
    } else if (app.wxIsInstall == NO && app.QQIsInstall == YES) {
        frame1 = CGRectZero;
        frame2 = CGRectZero;
        frame5 = CGRectMake(55 * WIDTH_NIT, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        
        frame3 = CGRectMake(frame5.origin.x + frame5.size.width + 57.5 * WIDTH_NIT, frame5.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        frame4 = CGRectMake(frame3.origin.x + frame3.size.width + 57.5 * WIDTH_NIT, frame3.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        frame6 = CGRectMake(frame5.origin.x, frame5.origin.y + frame5.size.height + 48 * HEIGHT_NIT, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        
    } else if (app.wxIsInstall == YES && app.QQIsInstall == NO) {
        frame1 = CGRectMake(55 * WIDTH_NIT, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        frame2 = CGRectMake(frame1.origin.x + frame1.size.width + 57.5 * WIDTH_NIT, frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        frame5 = CGRectMake(frame2.origin.x + frame2.size.width + 57.5 * WIDTH_NIT, frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        
        frame3 = CGRectZero;
        frame4 = CGRectZero;
        frame6 = CGRectMake(frame1.origin.x, frame1.origin.y + frame1.size.height + 48 * HEIGHT_NIT, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
    } else {
        frame1 = CGRectZero;
        frame2 = CGRectZero;
        frame5 = CGRectMake(55 * WIDTH_NIT, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
        
        frame3 = CGRectZero;
        frame4 = CGRectZero;
        frame6 = CGRectMake(frame1.origin.x + frame1.size.width + 57.5 * WIDTH_NIT, frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
    }
    
    self.weChatShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.weChatShare.userInteractionEnabled = NO;
    self.weChatShare.frame = frame1;
//    [self.weChatShare setBackgroundImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    
    self.friendShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.friendShare.userInteractionEnabled = NO;
    self.friendShare.frame = frame2;
//    [self.friendShare setBackgroundImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
    
    if (app.wxIsInstall) {
        self.weChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.weChatShare.left - self.weChatShare.width * 0.25, self.weChatShare.bottom, self.weChatShare.width * 1.5, 24 * HEIGHT_NIT)];
//        self.weChatLabel.text = title1;
        self.weChatLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.weChatLabel.textAlignment = NSTextAlignmentCenter;
        self.weChatLabel.textColor = HexStringColor(@"#535353");
        
        [self.shareView addSubview:self.weChatShare];
        [self.shareView addSubview:self.weChatLabel];
        
        ShareButton *weChatButton = [ShareButton buttonWithType:UIButtonTypeCustom];
        [self.shareView addSubview:weChatButton];
        weChatButton.frame = CGRectMake(self.weChatLabel.left, self.weChatShare.top, self.weChatLabel.width, self.weChatLabel.bottom - self.weChatShare.top);
        [weChatButton setTitle:title1 forState:UIControlStateNormal];
        [weChatButton setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
  
        [weChatButton addTarget:self action:@selector(weChatShareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.friendShare.left - self.friendShare.width * 0.25, self.friendShare.bottom, self.friendShare.width * 1.5, 24 * HEIGHT_NIT)];
//        self.friendLabel.text = title2;
        self.friendLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.friendLabel.textAlignment = NSTextAlignmentCenter;
        self.friendLabel.textColor = HexStringColor(@"#535353");
    
        [self.shareView addSubview:self.friendShare];
        [self.shareView addSubview:self.friendLabel];
        
        ShareButton *friendButton = [ShareButton buttonWithType:UIButtonTypeCustom];
        [self.shareView addSubview:friendButton];
        friendButton.frame = CGRectMake(self.friendLabel.left, self.friendShare.top, self.friendLabel.width, self.friendLabel.bottom - self.friendShare.top);
        [friendButton setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        [friendButton setTitle:title2 forState:UIControlStateNormal];

        [friendButton addTarget:self action:@selector(friendShareAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    self.QQShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.QQShare.userInteractionEnabled = NO;
    self.QQShare.frame = frame3;
//    [self.QQShare setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [self.shareView addSubview:self.QQShare];
    
    self.QZoneShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.QZoneShare.userInteractionEnabled = NO;
    self.QZoneShare.frame = frame4;
//    [self.QZoneShare setBackgroundImage:[UIImage imageNamed:@"QQ空间"] forState:UIControlStateNormal];
    [self.shareView addSubview:self.QZoneShare];
    
    if (app.QQIsInstall) {
        self.QQLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.QQShare.left - self.QQShare.width * 0.25, self.QQShare.bottom, self.QQShare.width * 1.5, 24 * HEIGHT_NIT)];
//        self.QQLabel.text = title3;
        self.QQLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.QQLabel.textAlignment = NSTextAlignmentCenter;
        self.QQLabel.textColor = HexStringColor(@"#535353");
        [self.shareView addSubview:self.QQLabel];
        
        ShareButton *QQButton = [ShareButton buttonWithType:UIButtonTypeCustom];
        [self.shareView addSubview:QQButton];
        QQButton.frame = CGRectMake(self.QQLabel.left, self.QQShare.top, self.QQLabel.width, self.QQLabel.bottom - self.QQShare.top);
        [QQButton setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
        [QQButton setTitle:title3 forState:UIControlStateNormal];
        [QQButton addTarget:self action:@selector(QQShareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.QZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.QZoneShare.left - self.QZoneShare.width * 0.25, self.QZoneShare.bottom, self.QZoneShare.width * 1.5, 24 * HEIGHT_NIT)];
//        self.QZoneLabel.text = title4;
        self.QZoneLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.QZoneLabel.textAlignment = NSTextAlignmentCenter;
        self.QZoneLabel.textColor = HexStringColor(@"#535353");
        [self.shareView addSubview:self.QZoneLabel];
        
        ShareButton *QZoneButton = [ShareButton buttonWithType:UIButtonTypeCustom];
        [self.shareView addSubview:QZoneButton];
        QZoneButton.frame = CGRectMake(self.QZoneLabel.left, self.QZoneShare.top, self.QZoneLabel.width, self.QZoneLabel.bottom - self.QZoneShare.top);
        [QZoneButton setImage:[UIImage imageNamed:@"QQ空间"] forState:UIControlStateNormal];
        [QZoneButton setTitle:title4 forState:UIControlStateNormal];
        [QZoneButton addTarget:self action:@selector(QZoneShareAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIButton *QZoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.shareView addSubview:QZoneButton];
//        QZoneButton.frame = CGRectMake(self.QZoneLabel.left, self.QZoneShare.top, self.QZoneLabel.width, self.QZoneLabel.bottom - self.QZoneShare.top);
//        [QZoneButton setImage:[UIImage imageNamed:@"QQ空间"] forState:UIControlStateNormal];
//        [QZoneButton setTitle:title4 forState:UIControlStateNormal];
//        [QZoneButton addTarget:self action:@selector(QZoneShareAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.weiboShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.weiboShare.frame = frame5;
//    [self.weiboShare setBackgroundImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
    self.weiboShare.userInteractionEnabled = NO;
    [self.shareView addSubview:self.weiboShare];
    
    self.weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.weiboShare.left - self.weiboShare.width * 0.25, self.weiboShare.bottom, self.weiboShare.width * 1.5, 24 * HEIGHT_NIT)];
//    self.weiboLabel.text = title5;
    self.weiboLabel.font = NORML_FONT(12 * WIDTH_NIT);
    self.weiboLabel.textAlignment = NSTextAlignmentCenter;
    self.weiboLabel.textColor = HexStringColor(@"#535353");
    [self.shareView addSubview:self.weiboLabel];
    
    ShareButton *weiboButton = [ShareButton buttonWithType:UIButtonTypeCustom];
    [self.shareView addSubview:weiboButton];
    weiboButton.frame = CGRectMake(self.weiboLabel.left, self.weiboShare.top, self.weiboLabel.width, self.weiboLabel.bottom - self.weiboShare.top);
    [weiboButton setTitle:title5 forState:UIControlStateNormal];
    [weiboButton setImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
    [weiboButton addTarget:self action:@selector(WeiboShareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *lineImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.shareImage.left, self.weiboLabel.bottom + 24 * HEIGHT_NIT, self.shareImage.width, 5)];
    [self.shareView addSubview:lineImage2];
    
    if (!app.weiboInstall) {
        self.weiboLabel.hidden = YES;
        self.weiboShare.hidden = YES;
        weiboButton.hidden = YES;
        lineImage2.frame = CGRectMake(self.shareImage.left, 222 * HEIGHT_NIT + 24 * HEIGHT_NIT, self.shareImage.width, 5);
    }
    
    self.urlShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.urlShare.frame = frame6;
//    [self.urlShare setBackgroundImage:[UIImage imageNamed:@"链接"] forState:UIControlStateNormal];
    self.urlShare.userInteractionEnabled = NO;
    [self.shareView addSubview:self.urlShare];
    
    self.urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.urlShare.left - self.urlShare.width * 0.25, self.urlShare.bottom, self.urlShare.width * 1.5, 24 * HEIGHT_NIT)];
//    self.urlLabel.text = title6;
    self.urlLabel.font = NORML_FONT(12 * WIDTH_NIT);
    self.urlLabel.textAlignment = NSTextAlignmentCenter;
    self.urlLabel.textColor = HexStringColor(@"#535353");
    [self.shareView addSubview:self.urlLabel];
    
    ShareButton *urlButton = [ShareButton buttonWithType:UIButtonTypeCustom];
    [self.shareView addSubview:urlButton];
    urlButton.frame = CGRectMake(self.urlLabel.left, self.urlShare.top, self.urlLabel.width, self.urlLabel.bottom - self.urlShare.top);
    [urlButton setImage:[UIImage imageNamed:@"链接"] forState:UIControlStateNormal];
    [urlButton setTitle:title6 forState:UIControlStateNormal];
    [urlButton addTarget:self action:@selector(urlShareAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 方法

// 获取歌曲信息
- (void)getSongInfo {
    
    NSString *playStr = @"play";
    NSRange range = [self.webUrl rangeOfString:playStr];
    
    NSString *code = [self.webUrl substringFromIndex:range.location + range.length + 1];
    
    NSLog(@"%@---------%@",self.webUrl, code);
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_MESS, code] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        NSString *songId = resposeObject[@"id"];
        NSString *songCode = resposeObject[@"code"];
        NSString *songTitle = resposeObject[@"title"];
        
        NSLog(@"app info %@, %@, %@", songId, songCode, songTitle);
        
        [self robotActionid:songId songCode:songCode songTitle:songTitle];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
    
}

// 机器人动作
- (void)robotActionid:(NSString *)songId songCode:(NSString *)songCode songTitle:(NSString *)songTitle {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RobotComments" ofType:@"plist"];
    
    self.robotCommentsDataSource = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    NSInteger number = arc4random() % 3 + 3;
    
    [self.robotDataSource removeAllObjects];
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_ROBOT, number] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        STRONG_SELF;
        
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            
            NSArray *array = resposeObject[@"items"];
            for (NSDictionary *dic in array) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                [self.robotDataSource addObject:model];
            }
            
            NSArray *commentsArray = [self getNumberArray:self.robotDataSource.count fromDataSource:self.robotCommentsDataSource];
            
            [self robotSendCommentsAndUpSongWithUser:self.robotDataSource commentsDataSource:commentsArray songId:songId songCode:songCode songTitle:songTitle];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

// 机器人评论
- (void)robotSendCommentsAndUpSongWithUser:(NSMutableArray *)userDataSource commentsDataSource:(NSArray *)commentsDataSource songId:(NSString *)songId songCode:(NSString *)songCode songTitle:(NSString *)songTitle {

    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    if (songCode.length != 0 && songId.length != 0) {
        
        for (int i = 0; i < userDataSource.count; i++) {
            
            UserModel *model = userDataSource[i];
            NSString *comments = commentsDataSource[i];
            
            // 添加播放数接口
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
            // 发送评论
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_COMMENTS, model.userModelId, songId, comments, @""] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, userId, model.userModelId, @"1", songId, comments, songTitle] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
            // 点赞
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:UP_SONGS, songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, userId, model.userModelId, @"0", songId, @"", songTitle] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }

    }

}

// 取不重复内容
- (NSArray *)getNumberArray:(NSInteger)num fromDataSource:(NSArray *)dataSource {
    
    if (num > dataSource.count) {
        return nil;
    }
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] initWithArray:dataSource];
    NSMutableArray *subArray = [[NSMutableArray alloc] initWithCapacity:0];

    for (int i = 0; i < num; i++) {
        NSInteger index = arc4random() % mutArray.count;
        [subArray addObject:mutArray[index]];
        [mutArray removeObjectAtIndex:index];
    }
    
    NSArray *array = subArray;
    return array;
}

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backToPerson" object:nil];
    
}

// 返回首页方法
- (void)backToHomeAction:(UIButton *)sender {
    
    if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[HomeViewController class]]) {
        HomeViewController *homeVC = [self.navigationController.viewControllers firstObject];
        [homeVC reloadHome];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"turnToHomeFromShare" object:nil];
    }
}

- (void)backToHomeNotification {
    [self backToHomeAction:nil];
}

#pragma mark - 分享方法

// 微信分享按钮
- (void)weChatShareAction:(UIButton *)sender {
    
    // 点击分享微信的按钮统计
    [MobClick event:@"play_shareWechat"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.songTitle;
    
    message.description = self.songWriter;
    [message setThumbImage:[UIImage imageNamed:@"shareIcon"]];
    
    if (self.image != nil) {
        [message setThumbImage:self.image];
    }
    
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = self.webUrl;
    ext.musicLowBandUrl = ext.musicUrl;
    ext.musicDataUrl = self.mp3Url;
    ext.musicLowBandDataUrl = ext.musicDataUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = wxShare;
    
}

// 朋友圈分享按钮
- (void)friendShareAction:(UIButton *)sender {
    
    
    // 点击分享朋友圈按钮统计
    [MobClick event:@"play_shareFriend"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.songTitle;
    message.description = self.songWriter;
    [message setThumbImage:[UIImage imageNamed:@"shareIcon"]];
    
    if (self.image != nil) {
        [message setThumbImage:self.image];
    }
    
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = self.webUrl;
    ext.musicLowBandUrl = ext.musicUrl;
    ext.musicDataUrl = self.mp3Url;
    ext.musicLowBandDataUrl = ext.musicDataUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = wxFriend;
    
    
}

// QQ分享按钮
- (void)QQShareAction:(UIButton *)sender {
    
    // 点击分享QQ按钮统计
    [MobClick event:@"play_shareQQ"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"]];
    
    if (self.image != nil) {
        if (UIImagePNGRepresentation(self.image) == nil) {
            data = UIImageJPEGRepresentation(self.image, 1);
        } else {
            data = UIImagePNGRepresentation(self.image);
        }
    }
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    QQApiAudioObject *audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:self.webUrl] title:self.songTitle description:self.songWriter previewImageData:data];
    
    [audioObj setFlashURL:[NSURL URLWithString:self.mp3Url]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];

    NSLog(@"%d", sent);
    if (sent == 0) {
        [MobClick event:@"play_shareQQSuccess"];
        //        [KVNProgress showSuccessWithStatus:@"已分享"];
        app.willShowShareToast = YES;
    }
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = QQShare;
    
    
}

// QZone分享按钮
- (void)QZoneShareAction:(UIButton *)sender {
    // 点击分享到QQ空间按钮
    [MobClick event:@"play_shareQZone"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"]];
    
    if (self.image != nil) {
        if (UIImagePNGRepresentation(self.image) == nil) {
            data = UIImageJPEGRepresentation(self.image, 1);
        } else {
            data = UIImagePNGRepresentation(self.image);
        }
    }
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    QQApiAudioObject *audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:self.webUrl] title:self.songTitle description:self.songWriter previewImageData:data];
    
    [audioObj setFlashURL:[NSURL URLWithString:self.mp3Url]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    NSLog(@"%d", sent);
    if (sent == 0) {
        [MobClick event:@"play_shareQZoneSuccess"];
        //        [KVNProgress showSuccessWithStatus:@"已分享"];
        app.willShowShareToast = YES;
    }
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = QZoneShare;
    
    
}


- (void)WeiboShareAction:(UIButton *)sender {
    
    
    [MobClick event:@"play_weiboShare"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:self.webUrl image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功");
            AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            myAppDelegate.willShowShareToast = YES;
            [MobClick event:@"play_weiboShareSuccess"];
        }
    }];
    
}

// 复制链接
- (void)urlShareAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.webUrl;
    
    [MBProgressHUD showSuccess:@"已复制的剪贴板"];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == UMSResponseCodeSuccess) {
        
    }
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if (platformName == UMShareToSina) {
        socialData.shareText = @"分享到新浪微博的文字内容";
    }
    else{
        socialData.shareText = @"分享到其他平台的文字内容";
    }
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
