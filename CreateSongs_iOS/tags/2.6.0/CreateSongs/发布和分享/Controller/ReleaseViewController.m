//
//  ReleaseViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ReleaseViewController.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"
#import "ShareViewController.h"
#import "LoginViewController.h"
#import "MobClick.h"
#import "AFHTTPSessionManager.h"
#import "KVNProgress.h"
#import "AXGTools.h"
#import "NSString+Emojize.h"
#import "AXGMessage.h"

@interface ReleaseViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *selectImage;

@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIImageView *preImageView;

// 记录缩放大小
@property (nonatomic, assign) CGFloat lastScale;

// 记录旋转角度
@property (nonatomic, assign) CGFloat lastRotation;

// 记录X坐标
@property (nonatomic, assign) CGFloat firstX;

// 记录Y坐标
@property (nonatomic, assign) CGFloat firstY;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *uploadCode;

@property (nonatomic, assign) NSInteger shareChannleId;

@property (nonatomic, assign) BOOL isAgree;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, assign) CGAffineTransform transform;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isAgree = YES;
    
    [self initNavView];
    
    [self createBody];

    [self.view bringSubviewToFront:self.navView];
    
    [self createEditView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUser)
                                                 name:@"refreshUserInRelease" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    self.navTitle.text = @"发布";
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createBody {
    UIImageView *themeBottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(87.5 * WIDTH_NIT, self.navView.bottom + 50 * HEIGHT_NIT, 200 * WIDTH_NIT, 200 * WIDTH_NIT)];
    [self.view addSubview:themeBottomImage];
    themeBottomImage.image = [UIImage imageNamed:@"专辑封面占位符"];
    
    UIImageView *plusImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75 * WIDTH_NIT, 75 * WIDTH_NIT)];
    [themeBottomImage addSubview:plusImage];
    plusImage.image = [UIImage imageNamed:@"加载图片icon"];
    plusImage.center = CGPointMake(themeBottomImage.width / 2, themeBottomImage.height / 2);
    
    UILabel *uploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, plusImage.bottom + 30 * WIDTH_NIT, themeBottomImage.width, 23 * WIDTH_NIT)];
    [themeBottomImage addSubview:uploadLabel];
    uploadLabel.textColor = [UIColor whiteColor];
    uploadLabel.text = @"上传专辑封面";
    uploadLabel.textAlignment = NSTextAlignmentCenter;
    uploadLabel.font = [UIFont systemFontOfSize:15];
    
    self.themeImageView = [[UIImageView alloc] initWithFrame:themeBottomImage.frame];
    [self.view addSubview:self.themeImageView];
    self.themeImageView.layer.cornerRadius = 5 * WIDTH_NIT;
    self.themeImageView.layer.masksToBounds = YES;
    self.themeImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareImageDidTap:)];
    [self.themeImageView addGestureRecognizer:tap];
    
    UIImageView *diskImage = [[UIImageView alloc] initWithFrame:CGRectMake(themeBottomImage.right - 7 * WIDTH_NIT, 0, 52 * WIDTH_NIT, 164.5 * WIDTH_NIT)];
    [self.view addSubview:diskImage];
    diskImage.image = [UIImage imageNamed:@"专辑"];
    diskImage.center = CGPointMake(diskImage.centerX, themeBottomImage.centerY);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(themeBottomImage.left, themeBottomImage.bottom + 10 * WIDTH_NIT, themeBottomImage.width, 35 * WIDTH_NIT)];
    [self.view addSubview:titleLabel];
    titleLabel.text = self.songName;
    titleLabel.textColor = HexStringColor(@"#535353");
    titleLabel.font = TECU_FONT(15);
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"标题";
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, themeBottomImage.bottom + 35 * WIDTH_NIT, titleLabel.width, 32 * WIDTH_NIT)];
    [self.view addSubview:self.nameLabel];
    self.nameLabel.textColor = titleLabel.textColor;
    self.nameLabel.font = NORML_FONT(12);
//    nameLabel.text = self.singer;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
//    nameLabel.text = @"歌手";
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
        self.userId = userId;
        WEAK_SELF;
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                self.singer = [resposeObject[@"name"] emojizedString];
                self.nameLabel.text = self.singer;
            } else {
                self.singer = @"佚名";
                self.nameLabel.text = self.singer;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            self.singer = @"佚名";
            self.nameLabel.text = self.singer;
        }];
    }
    
    self.saveButton = [UIButton new];
    [self.view addSubview:self.saveButton];
    self.saveButton.frame = CGRectMake(0, 0, 250 * WIDTH_NIT, 50 * WIDTH_NIT);
    self.saveButton.layer.cornerRadius = self.saveButton.height / 2;
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.titleLabel.font = JIACU_FONT(18);
    [self.saveButton setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [self.saveButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    self.saveButton.center = CGPointMake(self.view.width / 2, self.view.height - 35 * WIDTH_NIT - 25 * WIDTH_NIT);
//    [saveButton setBackgroundColor:HexStringColor(@"#879999")];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
    [self.saveButton setTitle:@"保存并分享" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *gouView = [[UIView alloc] initWithFrame:CGRectMake(162.5 * WIDTH_NIT, 0, 18 * WIDTH_NIT, 18 * WIDTH_NIT)];
    [self.view addSubview:gouView];
    gouView.backgroundColor = HexStringColor(@"#eeeeee");
    gouView.layer.cornerRadius = 5 * WIDTH_NIT;
    gouView.layer.masksToBounds = YES;
    gouView.center = CGPointMake(gouView.centerX, self.saveButton.top - 25 * HEIGHT_NIT - 9 * WIDTH_NIT);
    
    CGFloat totalWidth = gouView.width + 10 * WIDTH_NIT + [AXGTools getTextWidth:@"同时分享到社区" font:NORML_FONT(12)];
    
    gouView.frame = CGRectMake((self.view.width - totalWidth) / 2, gouView.top, gouView.width, gouView.height);
    
    self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(gouView.left + 2 * WIDTH_NIT, gouView.top, 18 * WIDTH_NIT - 4 * WIDTH_NIT,  (18 * WIDTH_NIT - 4 * WIDTH_NIT) * (18 / 26.0))];
    self.selectImage.center = CGPointMake(self.selectImage.centerX, gouView.centerY);
    [self.view addSubview:self.selectImage];
    self.selectImage.image = [UIImage imageNamed:@"选中"];
    
    UIButton *selectButton = [UIButton new];
    [self.view addSubview:selectButton];
    selectButton.backgroundColor = [UIColor clearColor];
    selectButton.frame = CGRectMake(self.selectImage.left - 10 * WIDTH_NIT, self.selectImage.top - 10 * WIDTH_NIT, self.selectImage.width + 20 * WIDTH_NIT, self.selectImage.height + 20 * WIDTH_NIT);
    [selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *gaiquLabel = [[UILabel alloc] initWithFrame:CGRectMake(gouView.right + 10 * WIDTH_NIT, gouView.top, 200, gouView.height)];
    [self.view addSubview:gaiquLabel];
    gaiquLabel.text = @"同时分享到社区";
    gaiquLabel.textColor = HexStringColor(@"#535353");
    gaiquLabel.font = NORML_FONT(12);
    
}

// 创建编辑页面
- (void)createEditView {
    self.editView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.editView];
    self.editView.backgroundColor = [UIColor blackColor];
    self.editView.hidden = YES;
    
    self.preImageView = [[UIImageView alloc] initWithFrame:self.editView.bounds];
    [self.editView addSubview:self.preImageView];
    self.preImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.preImageView.userInteractionEnabled = YES;
    
    [self createMaskView];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.editView addGestureRecognizer:pinchRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.editView addGestureRecognizer:panRecognizer];
    
}

// 创建遮罩界面
- (void)createMaskView {
    UIView *maskView = [[UIView alloc] initWithFrame:self.editView.bounds];
    [self.editView addSubview:maskView];
    maskView.backgroundColor = [UIColor clearColor];
    
    self.centerView = [[UIView alloc] initWithFrame:self.themeImageView.frame];
    self.centerView.frame = CGRectMake(0, 0, self.view.width, self.view.width);
    [maskView addSubview:self.centerView];
    self.centerView.center = maskView.center;
    self.centerView.backgroundColor = [UIColor clearColor];
    self.centerView.layer.borderWidth = 1;
    self.centerView.layer.borderColor = THEME_COLOR.CGColor;
    
    UIView *mask1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.centerView.left, maskView.height)];
    [maskView addSubview:mask1];
    mask1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIView *mask2 = [[UIView alloc] initWithFrame:CGRectMake(self.centerView.right, 0, maskView.width - self.centerView.right, maskView.height)];
    [maskView addSubview:mask2];
    mask2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIView *mask3 = [[UIView alloc] initWithFrame:CGRectMake(self.centerView.left, 0, self.centerView.width, self.centerView.top)];
    [maskView addSubview:mask3];
    mask3.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIView *mask4 = [[UIView alloc] initWithFrame:CGRectMake(self.centerView.left, self.centerView.bottom, self.centerView.width, maskView.height - self.centerView.bottom)];
    [maskView addSubview:mask4];
    mask4.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [maskView addSubview:cancelButton];
    cancelButton.frame = CGRectMake(0, self.view.height - 60 * HEIGHT_NIT, 120 * WIDTH_NIT, 60 * HEIGHT_NIT);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    cancelButton.backgroundColor = [UIColor redColor];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [maskView addSubview:confirmButton];
    confirmButton.frame = CGRectMake(self.view.width - 120 * WIDTH_NIT, self.view.height - 60 * HEIGHT_NIT, 120 * WIDTH_NIT, 60 * HEIGHT_NIT);
    [confirmButton setTitle:@"选取" forState:UIControlStateNormal];
    [confirmButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateNormal];
    confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    confirmButton.backgroundColor = [UIColor redColor];
    
}

#pragma mark - 移动缩放操作

// 缩放
-(void)scale:(id)sender {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = self.preImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.preImageView setTransform:newTransform];
    
    WEAK_SELF;
    if (self.preImageView.width <= self.view.width) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            STRONG_SELF;
            [self.preImageView setTransform:self.transform];
        } completion:^(BOOL finished) {
            
        }];
        
    } else if (self.preImageView.width >= self.view.width * 3) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            STRONG_SELF;
            CGAffineTransform largeTransform = CGAffineTransformScale(self.transform, 3, 3);
            [self.preImageView setTransform:largeTransform];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    //    [self showOverlayWithFrame:photoImage.frame];
}

// 旋转
-(void)rotate:(id)sender {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = self.preImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self.preImageView setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    //    [self showOverlayWithFrame:photoImage.frame];
}

// 移动
-(void)move:(id)sender {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.editView];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [self.preImageView center].x;
        _firstY = [self.preImageView center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    
    if (translatedPoint.x < 0) {
        [self.preImageView setCenter:CGPointMake(0, translatedPoint.y)];
    } else if (translatedPoint.x > self.view.width) {
        [self.preImageView setCenter:CGPointMake(self.view.width, translatedPoint.y)];
    } else if (translatedPoint.y < 64) {
        [self.preImageView setCenter:CGPointMake(translatedPoint.x, 64)];
    } else if (translatedPoint.y > self.view.height) {
        [self.preImageView setCenter:CGPointMake(translatedPoint.x, self.view.height)];
    } else {
        [self.preImageView setCenter:translatedPoint];
    }
    //    [self showOverlayWithFrame:photoImage.frame];
}

#pragma mark - Action

// 登录后刷新用户信息
- (void)refreshUser {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
        self.userId = userId;
        WEAK_SELF;
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                self.singer = [resposeObject[@"name"] emojizedString];
                self.nameLabel.text = self.singer;
            } else {
                self.singer = @"佚名";
                self.nameLabel.text = self.singer;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            self.singer = @"佚名";
            self.nameLabel.text = self.singer;
        }];
    }
}

// 同时分享到社区
- (void)selectButtonAction:(UIButton *)sender {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    self.selectImage.hidden = !self.selectImage.hidden;
    
}

// 保存按钮方法
- (void)saveButtonAction:(UIButton *)sender {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    

//    // 上传成功，推到分享页
//    ShareViewController *createShareVC = [[ShareViewController alloc] init];
//    
//    createShareVC.songTitle = self.songName;
//    createShareVC.mp3Url = self.mp3Url;
//    createShareVC.webUrl = self.webUrl;
//    //    createShareVC.lrcUrl = self.lyricURL;
//    //        createShareVC.lyricStr = self.lyricStr;
//    createShareVC.image = self.avatar;
//    createShareVC.shareImage.image = self.avatar;
//    createShareVC.songWriter = self.singer;
//    createShareVC.isAgree = !self.selectImage.hidden;
//    
//    [self.navigationController pushViewController:createShareVC animated:YES];
    
    
    // 发布界面_保存并分享埋点
    [MobClick event:@"release_save"];
    
    
    if (!self.avatar) {
        [self popAlertView];
        return;
    }
    
    // 分享登录
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        
        [self uploadImage];
        
    } else {
        AXG_LOGIN(LOGIN_LOCATION_SHARE);
    }
    
    
}

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 取消按钮方法
- (void)cancelButtonAction:(UIButton *)sender {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    self.editView.hidden = YES;
}

// 确定按钮方法
- (void)confirmButtonAction:(UIButton *)sender {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    self.centerView.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIImage *snapshot = [self getImage];
    self.avatar = [self getImageFromBigImage:snapshot withRect:CGRectMake(self.centerView.left + 1, self.centerView.top + 1, self.centerView.width - 2, self.centerView.height - 2)];
    self.themeImageView.image = self.avatar;
    self.editView.hidden = YES;
    
}

// 上传图片
- (void)uploadImage {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    if (self.avatar) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //@"http://localhost/demo/upload.php"
        
        NSData *data = UIImagePNGRepresentation(self.avatar);
        
        //    123.59.134.79/core/home/index/upload_img
        
        NSString *fileName = [self.mp3Url stringByReplacingOccurrencesOfString:@"mp3" withString:@"png"];
        
        NSLog(@"%@", fileName);
        
        WEAK_SELF;
        [manager POST:UPLOAD_USER_IMG parameters:@{@"key":@"value"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (formData) {
                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            STRONG_SELF;
            
            [self uploadCommunity];
            
            NSLog(@"success --- %@", responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error --- %@", error);
            [KVNProgress showErrorWithStatus:@"网络不给力"];
        }];
        
    } else {
        [self popAlertView];
    }
}

// 上传到社区
- (void)uploadCommunity {
    
    // 查询用户id
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *account = [wrapper objectForKey:(id)kSecAttrAccount];
    if (account.length != 0) {
        
        // 查询用户id
        self.userId = [wrapper objectForKey:(id)kSecValueData];
        
    }
    
    // 是否公开，"0"公开 "1"不公开
    NSString *public = @"";
    
    if (self.selectImage.hidden) {
        public = @"1";
    } else {
        public = @"0";
    }
    
    NSLog(@"%@_____________%@", self.userId, self.mp3Url);
    
    // http:\/\/service.woyaoxiege.com\/music\/mp3\/a900f0038487f8a3896d38e5792e8c2e_1942.mp3
    
    NSString *preCodeStr = [self.mp3Url substringFromIndex:40];
    
    NSString *codeStr = [preCodeStr substringToIndex:preCodeStr.length - 4];
    
    NSLog(@"%@----%@----%@----%@", self.mp3Url, preCodeStr, codeStr, self.userId);
    
    // 设备信息
    NSString *phoneName = [AXGTools deviceName];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    NSString *tag = app.song_tag;
    NSString *acId = app.activityId;
    NSString *isSing = @"";
    NSString *isGai = @"";
    NSString *originSongName = app.originSongName;
    NSString *lyricWriter = @"";
    NSString *songWriter = @"";
    NSString *songSinger = @"";
    
    if ([tag isEqualToString:@"演唱"]) {
        isSing = @"1";
        songSinger = self.userId;
    } else {
        isSing = @"0";
        
        songSinger = app.songSinger;
    }
    
    if ([tag isEqualToString:@"改曲"]) {
        isGai = @"1";
    } else {
        isGai = @"0";
    }
    
    // 作词
    if (app.lyricWriter.length == 0) {
        lyricWriter = self.userId;
    } else {
        lyricWriter = app.lyricWriter;
    }
    
    // 作曲
    if (app.songWriter.length == 0) {
        songWriter = self.userId;
    } else {
        songWriter = app.songWriter;
    }
    
    // -0还是0,所以置换一下
    if ([songSinger isEqualToString:@"-0"]) {
        songSinger = @"-11";
    }
    if (!app.template_id) {
        app.template_id = @"0";
    }
    NSString *addSongUrl = [NSString stringWithFormat:UPLOAD_COMMUNITY, self.userId, codeStr, phoneName, public, tag, isSing, acId, isGai, originSongName, lyricWriter, songWriter, songSinger, app.template_id];
    
    NSLog(@"*************%@", addSongUrl);
    NSLog(@"*************%@", [addSongUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    WEAK_SELF;
    
    [XWAFNetworkTool getUrl:[addSongUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        NSLog(@"!!!!!!!!!!!!!!!%@", resposeObject);
        //        [KVNProgress showSuccessWithStatus:@"上传成功"];
        
        // 上传成功，推到分享页
        ShareViewController *createShareVC = [[ShareViewController alloc] init];
        
        createShareVC.songTitle = self.songName;
        createShareVC.mp3Url = self.mp3Url;
        createShareVC.webUrl = self.webUrl;
        //    createShareVC.lrcUrl = self.lyricURL;
//        createShareVC.lyricStr = self.lyricStr;
        createShareVC.image = self.avatar;
        createShareVC.shareImage.image = self.avatar;
        createShareVC.songWriter = self.singer;
        createShareVC.isAgree = !self.selectImage.hidden;
        
        [self.navigationController pushViewController:createShareVC animated:YES];
        
        //        [self shareToWhere:self.shareChannleId];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        NSLog(@"上传失败");
    }];
}

// 弹出上传图片的alert
- (void)popAlertView {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请先上传专辑封面" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 选取图片方法
- (void)shareImageDidTap:(UITapGestureRecognizer *)tap {
    
    NSLog(@"fuction == %s", __FUNCTION__);
    
    [MobClick event:@"share_shareImage"];
    
    self.centerView.layer.borderColor = THEME_COLOR.CGColor;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    
    [AXGMessage showImageSelectMessageOnView:self.view leftImage:[UIImage imageNamed:@"弹出框_拍照"] rightImage:[UIImage imageNamed:@"弹出框_相册"]];
    WEAK_SELF;
    [AXGMessage shareMessageView].leftButtonBlock = ^ () {
        STRONG_SELF;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    };
    [AXGMessage shareMessageView].rightButtonBlock = ^ () {
        STRONG_SELF;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:NULL];
    };
    
    
//    WEAK_SELF;
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        STRONG_SELF;
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:picker animated:YES completion:NULL];
//    }];
//    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        STRONG_SELF;
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        [self presentViewController:picker animated:YES completion:NULL];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alert addAction:cameraAction];
//    [alert addAction:photoAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:^{
//        
//    }];
    
}

#pragma mark - PickController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.avatar = info[UIImagePickerControllerOriginalImage];
    
    // 处理完毕，回到个人信息页面
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    //    self.shareImage.image = self.avatar;
    self.preImageView.image = self.avatar;
    self.transform = self.preImageView.transform;
    self.editView.hidden = NO;
    
}

#pragma mark - 图片处理
// 从view截取
- (UIImage *)getImage {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.width, self.view.height), NO, 1.0);  //NO，YES 控制是否透明
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 生成后的image
    
    return image;
}

// 根据给定得图片，从其指定区域截取一张新得图片

- (UIImage *)getImageFromBigImage:(UIImage *)bigImage withRect:(CGRect)subRect {
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subRect);
    CGSize size;
    size.width = subRect.size.width;
    size.height = subRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subRect, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

/**
 * 保存图片
 */
- (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    NSData* imageData;
    
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(tempImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(tempImage);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSArray *nameAry=[fullPathToFile componentsSeparatedByString:@"/"];
    NSLog(@"===fullPathToFile===%@",fullPathToFile);
    NSLog(@"===FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
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
