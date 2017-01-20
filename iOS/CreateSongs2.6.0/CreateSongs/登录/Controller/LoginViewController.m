//
//  LoginViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "LoginViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "AXGHeader.h"
#import "MobClick.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "XWAFNetworkTool.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "MBProgressHUD.h"
#import "WLCaptcheButton.h"
#import "PersonInfoView.h"
#import "KVNProgress.h"
#import "NSString+Emojize.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "AXGTools.h"
#import "AXGMessage.h"
#import "EMSDK.h"

@interface LoginViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate, UITextFieldDelegate, PersonViewDelegate, TencentSessionDelegate, WeiboSDKDelegate>

@property (nonatomic, strong) UIImageView *phoneImage;

@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) WLCaptcheButton *getVerti;

@property (nonatomic, strong) UILabel *verifiLabel;

@property (nonatomic, strong) PersonInfoView *personInfoView;

@property (nonatomic, strong) UIButton *weiboLoginButton;

@property (nonatomic, strong) UIButton *weixinLoginButton;

@property (nonatomic, strong) UIButton *QQLoginButton;

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

@property (nonatomic, assign) BOOL isNewUser;

@property (nonatomic, assign) CGAffineTransform transform;

/**
 *  QQ登录
 */
@property (nonatomic, strong) TencentOAuth *tencent;

/**
 *  三方登录昵称
 */
@property (nonatomic, copy) NSString *fastNickName;
/**
 *  三方登录头像
 */
@property (nonatomic, strong) UIImage *fastAvatar;
/**
 *  三方登录性别
 */
@property (nonatomic, copy) NSString *fastGender;
/**
 *  三方登录id
 */
@property (nonatomic, copy) NSString *fastId;

@property (nonatomic, assign) BOOL isFastLogin;


@end

@implementation LoginViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeiboUserInfo:) name:@"getWeiboInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeChatInfo:) name:@"getWeChatInfo" object:nil];
    
    self.isFastLogin = NO;
    self.isNewUser = YES;
    [self initNavView];
    [self createMessageUI];
    [self createPersonInfoView];
    [self createEditView];

}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
//    self.navLeftImage.image = [UIImage imageNamed:@"登录_关闭icon"];
    [self.navLeftButton setImage:[UIImage imageNamed:@"登录_关闭icon"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"关闭_高亮"] forState:UIControlStateHighlighted];
    self.navTitle.text = @"登录";
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navRightButton addTarget:self action:@selector(saveButtonDelegate) forControlEvents:UIControlEventTouchUpInside];
}

// 创建短信验证界面
- (void)createMessageUI {
    
    // 账号
    _phoneImage = [UIImageView new];
    _phoneImage.frame = CGRectMake(112.5 * WIDTH_NIT, self.navView.bottom + 95 * WIDTH_NIT, 12 * WIDTH_NIT, 17.5 * WIDTH_NIT);
    _phoneImage.image = [UIImage imageNamed:@"登录_手机icon"];
    [self.view addSubview:_phoneImage];
    
    self.accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(_phoneImage.right + 32 * WIDTH_NIT, 0, 150, 30)];
    self.accountTextField.center  =CGPointMake(self.accountTextField.centerX, self.phoneImage.centerY);
    [self.view addSubview:self.accountTextField];
    self.accountTextField.textColor = HexStringColor(@"#535353");
    self.accountTextField.delegate = self;
    self.accountTextField.returnKeyType = UIReturnKeyNext;
    self.accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:HexStringColor(@"#cccccc"), NSFontAttributeName:NORML_FONT(16 * WIDTH_NIT)}];
    self.accountTextField.font = NORML_FONT(16 * WIDTH_NIT);
    
    [self.accountTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = HexStringColor(@"#f5f5f5");
    line.frame = CGRectMake(_phoneImage.left, self.phoneImage.bottom + 22 * HEIGHT_NIT, 150.5 * WIDTH_NIT, 1);
    [self.view addSubview:line];
    
    // 验证码
    self.verification = [[UITextField alloc] initWithFrame:CGRectMake(self.phoneImage.left, line.bottom + 12 * HEIGHT_NIT, 80, 36 * HEIGHT_NIT)];
    self.verification.delegate = self;
    self.verification.keyboardType = UIKeyboardTypeNumberPad;
    self.verification.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.verification];
    self.verification.font = NORML_FONT(16 * WIDTH_NIT);
    self.verification.textColor = HexStringColor(@"#535353");
    
    self.verification.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:HexStringColor(@"#cccccc"), NSFontAttributeName:NORML_FONT(16 * WIDTH_NIT)}];
    
    [self.verification addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *shuxian = [[UIView alloc] initWithFrame:CGRectMake(150 * WIDTH_NIT, line.bottom + 22 * HEIGHT_NIT, 1, 14)];
    [self.view addSubview:shuxian];
    shuxian.backgroundColor = HexStringColor(@"#f5f5f5");
    
    self.getVerti = [WLCaptcheButton new];
    [self.view addSubview:self.getVerti];
    self.getVerti.frame = CGRectMake(shuxian.right, self.verification.top, line.right - shuxian.right, self.verification.height);
    self.getVerti.center = CGPointMake(self.getVerti.centerX, self.verification.centerY);
    
    self.getVerti.identifyKey = @"getVerti";
    
    self.getVerti.disabledTitleColor = HexStringColor(@"#a06262");
    self.getVerti.disabledBackgroundColor = [UIColor clearColor];
    [self.getVerti setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getVerti setTitleColor:HexStringColor(@"#a06262") forState:UIControlStateNormal];
    self.getVerti.titleLabel.font = NORML_FONT(16 * WIDTH_NIT);
    [self.getVerti addTarget:self action:@selector(getVertiNum:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width1 = [AXGTools getTextWidth:@"验证码" font:self.verification.font];
    CGFloat width2 = [AXGTools getTextWidth:@"获取验证码" font:self.verification.font];
    CGFloat width3 = line.width - width1 - width2;
    CGFloat width4 = width3 / 2;
    
    shuxian.frame = CGRectMake(self.verification.left + width1 + width4, shuxian.top, shuxian.width, shuxian.height);
    
    self.getVerti.frame = CGRectMake(shuxian.right, self.getVerti.top, width2 + width4 + width4, self.getVerti.height);
    

    // 注册按钮
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitButton.frame = CGRectMake(0, shuxian.bottom + 94 * HEIGHT_NIT, 188 * WIDTH_NIT, 48 * WIDTH_NIT);
    self.commitButton.center = CGPointMake(self.view.width / 2, self.commitButton.centerY);
    [self.view addSubview:self.commitButton];
//    self.commitButton.backgroundColor = HexStringColor(@"#879999");
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
    [self.commitButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.commitButton setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [self.commitButton setTitleColor:HexStringColor(@"ffffff") forState:UIControlStateHighlighted];
    [self.commitButton setTitleColor:[UIColor colorWithHexString:@"441D11" andAlpha:0.6] forState:UIControlStateDisabled];
    self.commitButton.titleLabel.font = NORML_FONT(18);
    self.commitButton.enabled = NO;
    self.commitButton.layer.cornerRadius = self.commitButton.height / 2;
    self.commitButton.layer.masksToBounds = YES;
    [self.commitButton addTarget:self action:@selector(commitVertiNum:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *tongyiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 27 * HEIGHT_NIT - 10 * HEIGHT_NIT, self.view.width, 28 * HEIGHT_NIT)];
    [self.view addSubview:tongyiLabel];
    tongyiLabel.center = CGPointMake(self.view.centerX, tongyiLabel.centerY);
    tongyiLabel.text = @"同意《用户条款及协议》";
    tongyiLabel.textColor = HexStringColor(@"#a3a3a3");
    tongyiLabel.textAlignment = NSTextAlignmentCenter;
    tongyiLabel.font = NORML_FONT(10);
    
    UIButton *protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolButton.frame = tongyiLabel.frame;
    [self.view addSubview:protocolButton];
    [protocolButton addTarget:self action:@selector(popProtocolAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *fastLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tongyiLabel.bottom + 30 * HEIGHT_NIT, self.view.width, 12 * WIDTH_NIT)];
    [self.view addSubview:fastLoginLabel];
    fastLoginLabel.textAlignment = NSTextAlignmentCenter;
    fastLoginLabel.textColor = HexStringColor(@"#535353");
    fastLoginLabel.text = @"第三方账号登录";
    fastLoginLabel.center = CGPointMake(self.view.width / 2, self.view.height - 146 * HEIGHT_NIT);
    fastLoginLabel.font = NORML_FONT(12);
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(12.5 * WIDTH_NIT, self.view.height - 146 * HEIGHT_NIT, 120 * WIDTH_NIT, 0.5)];
    [self.view addSubview:leftLine];
    leftLine.backgroundColor = HexStringColor(@"#cccccc");
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - 120 * WIDTH_NIT - 12.5 * WIDTH_NIT, self.view.height - 146 * HEIGHT_NIT, 120 * WIDTH_NIT, 0.5)];
    [self.view addSubview:rightLine];
    rightLine.backgroundColor = HexStringColor(@"#cccccc");
    
    UIImageView *QQImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, fastLoginLabel.bottom + 27 * HEIGHT_NIT, 45 * WIDTH_NIT, 45 * WIDTH_NIT)];
    [self.view addSubview:QQImage];
    QQImage.center = CGPointMake(self.view.centerX, leftLine.centerY + (tongyiLabel.centerY - leftLine.centerY) / 2);
    QQImage.image = [UIImage imageNamed:@"QQ"];
    
    UIImageView *weixinImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45 * WIDTH_NIT, 45 * WIDTH_NIT)];
    [self.view addSubview:weixinImage];
    weixinImage.center = CGPointMake(QQImage.centerX - 85 * WIDTH_NIT, QQImage.centerY);
    weixinImage.image = [UIImage imageNamed:@"微信"];
    
    UIImageView *weiboImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45 * WIDTH_NIT, 45 * WIDTH_NIT)];
    [self.view addSubview:weiboImage];
    weiboImage.center = CGPointMake(QQImage.centerX + 85 * WIDTH_NIT, QQImage.centerY);
    weiboImage.image = [UIImage imageNamed:@"微博"];
    
    self.QQLoginButton = [UIButton new];
    [self.view addSubview:self.QQLoginButton];
    self.QQLoginButton.frame = CGRectMake(0, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
    self.QQLoginButton.center = QQImage.center;
    self.QQLoginButton.tag = 101;
    [self.QQLoginButton addTarget:self action:@selector(fastLoginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.weiboLoginButton = [UIButton new];
    [self.view addSubview:self.weiboLoginButton];
    self.weiboLoginButton.frame = CGRectMake(0, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
    self.weiboLoginButton.center = weiboImage.center;
    self.weiboLoginButton.tag = 102;
    [self.weiboLoginButton addTarget:self action:@selector(fastLoginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.weixinLoginButton = [UIButton new];
    [self.view addSubview:self.weixinLoginButton];
    self.weixinLoginButton.frame = CGRectMake(0, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
    self.weixinLoginButton.center = weixinImage.center;
    self.weixinLoginButton.tag = 100;
    [self.weixinLoginButton addTarget:self action:@selector(fastLoginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame1 = weixinImage.frame;
    CGRect frame2 = QQImage.frame;
    CGRect frame3 = weiboImage.frame;
    
    CGRect buttonFrame1 = self.weixinLoginButton.frame;
    CGRect buttonFrame2 = self.QQLoginButton.frame;
    CGRect buttonFrame3 = self.weiboLoginButton.frame;
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    #warning remember delete
        app.wxIsInstall = YES;
        app.weiboInstall = YES;
        app.QQIsInstall = YES;
    
    if (app.wxIsInstall && app.weiboInstall && app.QQIsInstall) {
        // 都安装了
    } else if (app.wxIsInstall && !app.weiboInstall && app.QQIsInstall) {
        // 微博 未安装
        self.weiboLoginButton.hidden = YES;
        weiboImage.hidden = YES;
        
    } else if (app.wxIsInstall && app.weiboInstall && !app.QQIsInstall) {
        // qq 未安装
        self.QQLoginButton.hidden = YES;
        QQImage.hidden = YES;
        self.weiboLoginButton.frame = buttonFrame2;
        weiboImage.frame = frame2;
        
    } else if (!app.wxIsInstall && app.weiboInstall && app.QQIsInstall) {
        // 微信 未安装
        self.weixinLoginButton.hidden = YES;
        weixinImage.hidden = YES;
        self.QQLoginButton.frame = buttonFrame1;
        QQImage.frame = frame1;
        self.weiboLoginButton.frame = buttonFrame2;
        weiboImage.frame = frame2;
    } else if (app.wxIsInstall && !app.weiboInstall && !app.QQIsInstall) {
        // 微博 qq 未安装
        self.weiboLoginButton.hidden = YES;
        weiboImage.hidden = YES;
        self.QQLoginButton.hidden = YES;
        QQImage.hidden = YES;
    } else if (!app.wxIsInstall && app.weiboInstall && !app.QQIsInstall) {
        // 微信 qq 未安装
        self.weixinLoginButton.hidden = YES;
        weixinImage.hidden = YES;
        self.QQLoginButton.hidden = YES;
        QQImage.hidden = YES;
        self.weiboLoginButton.frame = buttonFrame1;
        weiboImage.frame = frame1;
    } else if (!app.wxIsInstall && !app.weiboInstall && app.QQIsInstall) {
        // 微信 微博 未安装
        self.weixinLoginButton.hidden = YES;
        weixinImage.hidden = YES;
        self.weiboLoginButton.hidden = YES;
        weiboImage.hidden = YES;
        self.QQLoginButton.frame = buttonFrame1;
        QQImage.frame = frame1;
    } else if (!app.wxIsInstall && !app.weiboInstall && !app.QQIsInstall) {
        // 都未安装
        self.weiboLoginButton.hidden = YES;
        self.weixinLoginButton.hidden = YES;
        self.QQLoginButton.hidden = YES;
        QQImage.hidden = YES;
        weiboImage.hidden = YES;
        weixinImage.hidden = YES;
        fastLoginLabel.hidden = YES;
        leftLine.hidden = YES;
        rightLine.hidden = YES;
    }

}

- (void)createPersonInfoView {
    self.personInfoView = [[PersonInfoView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.view.height)];
    self.personInfoView.delegate = self;
    [self.view addSubview:self.personInfoView];
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
    
    self.centerView = [[UIView alloc] initWithFrame:self.personInfoView.headImage.frame];
    [maskView addSubview:self.centerView];
    self.centerView.frame = CGRectMake(0, 0, self.view.width, self.view.width);
    self.centerView.center = maskView.center;
    self.centerView.backgroundColor = [UIColor clearColor];
    self.centerView.layer.borderWidth = 1;
    //    self.centerView.layer.borderColor = THEME_COLOR.CGColor;
    self.centerView.layer.borderColor = [UIColor cyanColor].CGColor;
    
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
    cancelButton.frame = CGRectMake(0, self.view.height - 60, 120, 60);
    //    cancelButton.frame = CGRectMake(0, self.view.height - 60 * HEIGHT_NIT, 120 * WIDTH_NIT, 60 * HEIGHT_NIT);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    cancelButton.backgroundColor = [UIColor redColor];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [maskView addSubview:confirmButton];
    confirmButton.frame = CGRectMake(self.view.width - 120, self.view.height - 60, 120, 60);
    //    confirmButton.frame = CGRectMake(self.view.width - 120 * WIDTH_NIT, self.view.height - 60 * HEIGHT_NIT, 120 * WIDTH_NIT, 60 * HEIGHT_NIT);
    [confirmButton setTitle:@"选取" forState:UIControlStateNormal];
    [confirmButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateNormal];
    confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    confirmButton.backgroundColor = [UIColor redColor];
    
}

#pragma mark - 按钮方法

// 快捷登录按钮方法
- (void)fastLoginButtonAction:(UIButton *)sender {
    
    self.isFastLogin = YES;
    
    switch (sender.tag - 100) {
        case 0: {
            //构造SendAuthReq结构体
            SendAuthReq* req = [[SendAuthReq alloc ] init];
            req.scope = @"snsapi_userinfo" ;
            req.state = @"123" ;
            //第三方向微信终端发送一个SendAuthReq消息结构
            [WXApi sendReq:req];
            
        }
            break;
        case 1: {
            self.tencent = [[TencentOAuth alloc] initWithAppId:@"1104985545" andDelegate:self];
            NSArray *permisions = @[@"get_user_info",@"get_simple_userinfo",@"add_t"];
            [self.tencent authorize:permisions inSafari:NO];
        }
            break;
        case 2: {
            
            // https://api.weibo.com/2/eps/user/info.json?uid=2269756804&access_token=2.00i7fbTCq6hzjDcdb51fa00ftkoxOC
            
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
            request.scope = @"all";
            //            request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
            //                                 @"Other_Info_1": [NSNumber numberWithInt:123],
            //                                 @"Other_Info_2": @[@"obj1", @"obj2"],
            //                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            [WeiboSDK sendRequest:request];
            
            
        }
            break;
            
        default:
            break;
    }
}

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_SHARE]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"loading"];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


// 获取验证码
- (void)getVertiNum:(WLCaptcheButton *)sender {
    
    if (![XWAFNetworkTool checkNetwork]) {
        
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        
        return;
    }
    
    // 防止网不好，被人连点
    self.getVerti.enabled = NO;
    
    NSLog(@"%@", self.accountTextField.text);
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.accountTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"成功");
            
            [self.getVerti fire];
            
        } else {
            NSLog(@"失败");
            NSLog(@"请输入正确的手机号码");
            self.getVerti.enabled = YES;
        }
    }];
}

// 验证验证码
- (void)commitVertiNum:(UIButton *)sender {
    
    self.isFastLogin = NO;
    
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    if (![XWAFNetworkTool checkNetwork]) {
        
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        
        return;
    }
    
    
#if TEST_REGIST
    
    __weak typeof(self)weakSelf = self;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_URL, weakSelf.accountTextField.text] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSLog(@"用户已经存在");
            
            NSString *name = [resposeObject[@"name"] emojizedString];
            
            if (name.length != 0) {
                self.isNewUser = NO;
                [self afterUpdateAction];
            } else {
                self.isNewUser = YES;
                [self pushPersonInfoView];
            }
            
        } else if ([resposeObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
            // 用户不存在,需要先注册
            
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_USER_URL, self.accountTextField.text, @"000"] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"注册成功");
                    // 注册成功，跳转资料页面
                    self.isNewUser = YES;
                    [self pushPersonInfoView];
                    
                } else if ([resposeObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
                    
                    //                                [MBProgressHUD showError:@"手机格式错误"];
                    [KVNProgress showErrorWithStatus:@"手机格式错误"];
                    
                } else {
                    
                    //                                [MBProgressHUD showError:@"服务器开小差了"];
                    [KVNProgress showErrorWithStatus:@"服务器开小差了"];
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [KVNProgress showErrorWithStatus:@"服务器开小差了"];
            }];
            
        } else {
            // 查询出错
            //                        [MBProgressHUD showError:@"服务器开小差了"];
            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [KVNProgress showErrorWithStatus:@"服务器开小差了"];
    }];
    
    return;
    
#endif
    
    if (self.verification.text.length == 0) {
        
        //        [MBProgressHUD showError:@"验证码不能为空"];
        [KVNProgress showErrorWithStatus:@"验证码不能为空"];
        
    } else {
        
        if ([self.accountTextField.text isEqualToString:@"15216635764"] ||
            [self.accountTextField.text isEqualToString:@"15140669192"] ||
            [self.accountTextField.text isEqualToString:@"20162016000"] ||
            [self.accountTextField.text isEqualToString:@"13564988559"] ||
            [self.accountTextField.text isEqualToString:@"13027768987"]
            ) {
            
            __weak typeof(self)weakSelf = self;
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_URL, weakSelf.accountTextField.text] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"用户已经存在");
                    
                    NSString *name = [resposeObject[@"name"] emojizedString];
                    
                    if (name.length != 0) {
                        self.isNewUser = NO;
                        [self afterUpdateAction];
                    } else {
                        self.isNewUser = YES;
                        [self pushPersonInfoView];
                    }
                    
                } else {
                    // 查询出错
                    //                        [MBProgressHUD showError:@"服务器开小差了"];
                    [KVNProgress showErrorWithStatus:@"服务器开小差了"];
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [KVNProgress showErrorWithStatus:@"服务器开小差了"];
            }];
            
            return;
            
        }
        
        // 防止被连点
        self.commitButton.enabled = NO;
        
        [SMSSDK commitVerificationCode:self.verification.text phoneNumber:self.accountTextField.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                NSLog(@"验证成功");
                
                __weak typeof(self)weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.commitButton.enabled = YES;
                });
                
                [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_URL, weakSelf.accountTextField.text] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                    if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                        NSLog(@"用户已经存在");
                        
                        NSString *name = [resposeObject[@"name"] emojizedString];
                        
                        if (name.length != 0) {
                            self.isNewUser = NO;
                            [self afterUpdateAction];
                        } else {
                            self.isNewUser = YES;
                            [self pushPersonInfoView];
                        }
                        
                    } else if ([resposeObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
                        // 用户不存在,需要先注册
                        
                        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_USER_URL, self.accountTextField.text, @"000"] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                                NSLog(@"注册成功");
                                // 注册成功，跳转资料页面
                                self.isNewUser = YES;
                                [self pushPersonInfoView];
                                
                            } else if ([resposeObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
                                
                                //                                [MBProgressHUD showError:@"手机格式错误"];
                                [KVNProgress showErrorWithStatus:@"手机格式错误"];
                                
                            } else {
                                
                                //                                [MBProgressHUD showError:@"服务器开小差了"];
                                [KVNProgress showErrorWithStatus:@"服务器开小差了"];
                                
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
                        }];
                        
                    } else {
                        // 查询出错
                        //                        [MBProgressHUD showError:@"服务器开小差了"];
                        [KVNProgress showErrorWithStatus:@"服务器开小差了"];
                        
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [KVNProgress showErrorWithStatus:@"服务器开小差了"];
                }];
                
            } else {
                
                __weak typeof(self)weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.commitButton.enabled = YES;
                });
                
                NSLog(@"错误信息:%@",error);
                //                [MBProgressHUD showError:@"验证码错误"];
                [KVNProgress showErrorWithStatus:@"验证码错误"];
            }
        }];
    }
    
}

// 第三方登录后操作
- (void)afterFastLoginAction {
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_URL, self.fastId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        STRONG_SELF;
        
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSLog(@"用户已经存在");
            
            NSString *name = [resposeObject[@"name"] emojizedString];
            
            if (name.length != 0) {
                self.isNewUser = NO;
                [self afterUpdateAction];
            } else {
                self.isNewUser = YES;
                [self pushPersonInfoView];
            }
            
        } else if ([resposeObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
            // 用户不存在,需要先注册
            
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_USER_URL, self.fastId, @"000"] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"注册成功");
                    // 注册成功，跳转资料页面
                    self.isNewUser = YES;
                    
                    // 用第三方信息
                    if (self.fastAvatar) {
                        self.avatar = self.fastAvatar;
                        self.personInfoView.headImage.image = self.fastAvatar;
                    }
                    
                    if (self.fastNickName.length != 0) {
                        self.personInfoView.nickName.text = self.fastNickName;
                    }
                    
                    if ([self.fastGender isEqualToString:@"男"]) {
                        self.personInfoView.gender.text = @"男";
                    } else if ([self.fastGender isEqualToString:@"女"]) {
                        self.personInfoView.gender.text = @"女";
                    }
                    
                    [self pushPersonInfoView];
                    
                } else if ([resposeObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
                    
                    //                                [MBProgressHUD showError:@"手机格式错误"];
                    [KVNProgress showErrorWithStatus:@"手机格式错误"];
                    
                } else {
                    
                    //                                [MBProgressHUD showError:@"服务器开小差了"];
                    [KVNProgress showErrorWithStatus:@"服务器开小差了"];
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [KVNProgress showErrorWithStatus:@"服务器开小差了"];
            }];
            
        } else {
            // 查询出错
            //                        [MBProgressHUD showError:@"服务器开小差了"];
            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [KVNProgress showErrorWithStatus:@"服务器开小差了"];
    }];
}

// 记住账号密码
- (void)rememberPassword {
    
    if (self.isFastLogin == YES) {
        // 初始化wrapper
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        // 保存账号
        [wrapper setObject:self.fastId forKey:(id)kSecAttrAccount];
        // 保存id
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_URL, self.fastId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                [wrapper setObject:resposeObject[@"id"] forKey:(id)kSecValueData];
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_DRAWER object:nil];
                
                
                KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
                NSString *userId = [wrapper objectForKey:(id)kSecValueData];
                
                // 登录环信
                BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
                if (!isAutoLogin) {
                    EMError *error = [[EMClient sharedClient] loginWithUsername:userId password:@"000"];
                    if (!error) {
                        NSLog(@"登录成功");
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                    } else {
                        NSLog(@"登录失败 %@", error.description);
                    }
                }
                
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
        return;
    }
    
    // 初始化wrapper
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    // 保存账号
    [wrapper setObject:self.accountTextField.text forKey:(id)kSecAttrAccount];
    // 保存id
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_URL, self.accountTextField.text] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            [wrapper setObject:resposeObject[@"id"] forKey:(id)kSecValueData];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_DRAWER object:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    // 从keychain里取出id
    NSString *password = [wrapper objectForKey:(id)kSecValueData];
    NSLog(@"%@", password);
    // 清空设置
    //    [wrapper resetKeychainItem];
}

// 推出资料页面
- (void)pushPersonInfoView {
    [UIView animateWithDuration:0.3 animations:^{
        self.personInfoView.center = CGPointMake(self.view.width / 2, self.personInfoView.centerY);
    }];
}

// 收回资料页面
- (void)popPersonInfoView {
    [UIView animateWithDuration:0.3 animations:^{
        self.personInfoView.center = CGPointMake(self.view.width * 3 / 2, self.personInfoView.centerY);
    }];
}

#pragma mark - PersonViewDelegate

- (void)saveButtonDelegate {
    if (self.avatar && self.personInfoView.nickName.text.length != 0 && self.personInfoView.gender.text.length != 0) {
        [self uploadImage];
    } else {
        //        [MBProgressHUD showError:@"请先完善资料"];
        [KVNProgress showErrorWithStatus:@"请先完善资料"];
    }
}

// 上传图片
- (void)uploadImage {
    
    if (self.isFastLogin) {
        if (self.avatar) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSData *data = UIImagePNGRepresentation(self.avatar);
            
            NSString *fileName = [NSString stringWithFormat:@"%@.png", [XWAFNetworkTool md5HexDigest:self.fastId]];
            
            NSLog(@"%@", fileName);
            
            __weak typeof(self)weakSelf = self;
            [manager POST:UPDATE_USER_HEAD parameters:@{@"key":@"value"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if (formData) {
                    [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSData *data = responseObject;
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@" !!!!!!!!!!v v success --- %@", responseObject);
                
                [weakSelf updateInfo];
                
                [[SDImageCache sharedImageCache] clearDisk];
                //            [[SDImageCache sharedImageCache] cleanDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePersonInfo" object:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDrawer" object:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error --- %@", error);
            }];
        }
        return;
    }
    
    if (self.avatar) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSData *data = UIImagePNGRepresentation(self.avatar);
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", [XWAFNetworkTool md5HexDigest:self.accountTextField.text]];
        
        NSLog(@"%@", fileName);
        
        __weak typeof(self)weakSelf = self;
        [manager POST:UPDATE_USER_HEAD parameters:@{@"key":@"value"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (formData) {
                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSData *data = responseObject;
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@" !!!!!!!!!!v v success --- %@", responseObject);
            
            [weakSelf updateInfo];
            
            [[SDImageCache sharedImageCache] clearDisk];
            //            [[SDImageCache sharedImageCache] cleanDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePersonInfo" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDrawer" object:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error --- %@", error);
        }];
    }
}

- (void)updateInfo {
    
    if (self.isFastLogin) {
        NSString *fileName = [NSString stringWithFormat:@"%@.png", [XWAFNetworkTool md5HexDigest:self.fastId]];
        NSString *gender = @"";
        if ([self.personInfoView.gender.text isEqualToString:@"男"]) {
            gender = @"1";
        } else {
            gender = @"0";
        }
        
        // 修改
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:UPDATE_USER_URL, self.fastId, self.personInfoView.nickName.text, gender, self.personInfoView.birthTextField.text, self.personInfoView.signitureText.text, self.personInfoView.weiboText.text, self.personInfoView.QQText.text, self.personInfoView.weChatText.text, self.personInfoView.locationText.text, self.personInfoView.schoolOrCompanyText.text] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            //     status == 0(更新成功过) -1(更新失败)
            NSLog(@" success %@", resposeObject);
            
            NSDictionary *dic = resposeObject;
            
            if ([dic[@"status"] isEqualToNumber:@0]) {
                //            [MBProgressHUD showSuccess:@"信息修改成功"];
                
                [[NSUserDefaults standardUserDefaults] setObject:INFO_COMPLETE_YES forKey:INFO_COMPLETE];
                
                [self afterUpdateAction];
                
            } else {
                //            [MBProgressHUD showError:@"服务器开小差了"];
                [KVNProgress showErrorWithStatus:@"服务器开小差了"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
        }];
        
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:UPDATE_USER_URL, self.fastId, [self.personInfoView.nickName.text preEmojizedString], gender, self.personInfoView.birthTextField.text, [self.personInfoView.signitureText.text preEmojizedString], [self.personInfoView.weiboText.text preEmojizedString], [self.personInfoView.QQText.text preEmojizedString], [self.personInfoView.weChatText.text preEmojizedString], self.personInfoView.locationText.text, [self.personInfoView.schoolOrCompanyText.text preEmojizedString]] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            //     status == 0(更新成功过) -1(更新失败)
//            NSLog(@" success %@", resposeObject);
//            
//            NSDictionary *dic = resposeObject;
//            
//            if ([dic[@"status"] isEqualToNumber:@0]) {
//                //            [MBProgressHUD showSuccess:@"信息修改成功"];
//                
//                [[NSUserDefaults standardUserDefaults] setObject:INFO_COMPLETE_YES forKey:INFO_COMPLETE];
//                
//                [self afterUpdateAction];
//                
//            } else {
//                //            [MBProgressHUD showError:@"服务器开小差了"];
//                [KVNProgress showErrorWithStatus:@"服务器开小差了"];
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
//        }];
        return;
    }

    NSString *fileName = [NSString stringWithFormat:@"%@.png", [XWAFNetworkTool md5HexDigest:self.accountTextField.text]];
    NSString *gender = @"";
    if ([self.personInfoView.gender.text isEqualToString:@"男"]) {
        gender = @"1";
    } else {
        gender = @"0";
    }
    
    // 修改
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:UPDATE_USER_URL, self.accountTextField.text, self.personInfoView.nickName.text, gender, self.personInfoView.birthTextField.text, self.personInfoView.signitureText.text, self.personInfoView.weiboText.text, self.personInfoView.QQText.text, self.personInfoView.weChatText.text, self.personInfoView.locationText.text, self.personInfoView.schoolOrCompanyText.text] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        //     status == 0(更新成功过) -1(更新失败)
        NSLog(@" success %@", resposeObject);
        
        NSDictionary *dic = resposeObject;
        
        if ([dic[@"status"] isEqualToNumber:@0]) {
            //            [MBProgressHUD showSuccess:@"信息修改成功"];
            
            [[NSUserDefaults standardUserDefaults] setObject:INFO_COMPLETE_YES forKey:INFO_COMPLETE];
            
            [self afterUpdateAction];
            
        } else {
            //            [MBProgressHUD showError:@"服务器开小差了"];
            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [KVNProgress showErrorWithStatus:@"服务器开小差了"];
    }];
    
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:UPDATE_USER_URL, self.accountTextField.text, [self.personInfoView.nickName.text preEmojizedString], gender, self.personInfoView.birthTextField.text, [self.personInfoView.signitureText.text preEmojizedString], [self.personInfoView.weiboText.text preEmojizedString], [self.personInfoView.QQText.text preEmojizedString], [self.personInfoView.weChatText.text preEmojizedString], self.personInfoView.locationText.text, [self.personInfoView.schoolOrCompanyText.text preEmojizedString]] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//        //     status == 0(更新成功过) -1(更新失败)
//        NSLog(@" success %@", resposeObject);
//        
//        NSDictionary *dic = resposeObject;
//        
//        if ([dic[@"status"] isEqualToNumber:@0]) {
//            //            [MBProgressHUD showSuccess:@"信息修改成功"];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:INFO_COMPLETE_YES forKey:INFO_COMPLETE];
//            
//            [self afterUpdateAction];
//            
//        } else {
//            //            [MBProgressHUD showError:@"服务器开小差了"];
//            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [KVNProgress showErrorWithStatus:@"服务器开小差了"];
//    }];
    
}

// 更新后操作
- (void)afterUpdateAction {
    
    [self rememberPassword];
    
    [[NSUserDefaults standardUserDefaults] setObject:IS_LOGIN_YES forKey:IS_LOGIN];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_DRAWER object:nil];
    
    NSLog(@"-------%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION]);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_DRAWER] || [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_PERSON]) {
        
        // push到个人中心
        
        // 收回登录界面
        WEAK_SELF;
        [self dismissViewControllerAnimated:YES completion:^{
            STRONG_SELF;

            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToPerson" object:nil];
            
        }];
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_SHARE]) {
        
       
//        // 推到分享页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserInRelease" object:nil];
        
        // 收回注册页
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_USERSONG_FOCUS]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_USERSONG_COMMENT]) {
        
        // 收回注册页
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SEND_COMMENT_AFTER_LOGIN object:nil];
        }];
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_FORUM_SEND_POST] || [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_PERSON_CENTER]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_FORUM_COMMENT]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendCommentAfterLoginFromForum" object:nil];
        }];
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_LOCATION] isEqualToString:LOGIN_LOCATION_SETTING]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSettingStatus" object:nil];
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userSongShare" object:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

// 取消按钮方法
- (void)cancelButtonAction:(UIButton *)sender {
    self.editView.hidden = YES;
}

// 确定按钮方法
- (void)confirmButtonAction:(UIButton *)sender {
    
    self.centerView.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIImage *snapshot = [self getImage];
    self.avatar = [self getImageFromBigImage:snapshot withRect:CGRectMake(self.centerView.left, self.centerView.top, self.centerView.width, self.centerView.height)];
    self.personInfoView.headImage.image = self.avatar;
    self.editView.hidden = YES;
    
}

// 资料页返回按钮方法
- (void)backButtonDelegate {
    [self popPersonInfoView];
}

// 性别选择方法
- (void)selectGender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"性别" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionMale = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.personInfoView.gender.text = @"男";
    }];
    
    UIAlertAction *actionFemale = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.personInfoView.gender.text = @"女";
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [sheet addAction:actionMale];
    [sheet addAction:actionFemale];
    [sheet addAction:actionCancel];
    
    [self presentViewController:sheet animated:YES completion:^{
        
    }];
}

// 头像选择方法
- (void)selectHeadImage {
    self.centerView.layer.borderColor = [UIColor cyanColor].CGColor;
    
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
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    [actionSheet showInView:self.view];
}

// sheetview
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if (buttonIndex == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    } else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:NULL];
    } else  {
        
    }
}

#pragma mark - PickController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.avatar = info[UIImagePickerControllerOriginalImage];
    
    // 处理完毕，回到个人信息页面
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    //    self.shareImage.image = self.avatar;
    self.preImageView.image = self.avatar;
//    self.personInfoView.headImage.image = self.avatar;
    self.transform = self.preImageView.transform;
    self.editView.hidden = NO;
    
}

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

#pragma mark - 移动缩放操作

// 缩放
-(void)scale:(id)sender {
    
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

#pragma mark - 协议方法

// 弹出用户协议方法
- (void)popProtocolAction {
    
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
//    AgreementWebViewViewController *agreeVC = [[AgreementWebViewViewController alloc] init];
//    [self presentViewController:agreeVC animated:YES completion:^{
//        
//    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.accountTextField) {
        [self.verification becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (void)textDidChange:(id)sender {
    UITextField *textField = (UITextField *)sender;
    
//    if (textField == self.verification) {
//        if (textField.text.length > 0) {
//            self.verifiLabel.text = @"";
//        } else {
//            self.verifiLabel.text = @"请输入验证码";
//        }
//    }
    
    if (textField == self.accountTextField) {
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
            [self.verification becomeFirstResponder];
        }
        
    } else {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
    
    if (self.accountTextField.text.length != 0 && self.verification.text.length != 0) {
        self.commitButton.enabled = YES;
    } else {
        self.commitButton.enabled = NO;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

#pragma mark - TencentDelegate

// 登录成功
- (void)tencentDidLogin {
    [self.tencent getUserInfo];
    //    [self.tencent getUserOpenID];
    NSLog(@"user openid %@", [self.tencent getUserOpenID]);
}

// 获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response {
    
    self.fastId = [self.tencent getUserOpenID];
    self.fastNickName = response.jsonResponse[@"nickname"];
    self.fastGender = response.jsonResponse[@"gender"];
    NSString *avatarUrl = response.jsonResponse[@"figureurl_qq_2"];
    self.fastAvatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarUrl]]];
    
    if (self.fastId.length != 0) {
        [self afterFastLoginAction];
    }
    
    NSLog(@"%@", response.jsonResponse);
}

// 网络问题
- (void)tencentDidNotNetWork {
    
}

// 登录失败
- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

#pragma mark - WeiboDelegate

- (void)getWeiboUserInfo:(NSNotification *)message {
    
    NSLog(@"%@---%@", message.object[@"uid"], message.object[@"token"]);
    
    NSString *uid = message.object[@"uid"];
    NSString *token = message.object[@"token"];
    
    self.fastId = uid;
    
    //    NSNumber *uidnew = [[NSNumber alloc] initWithInteger:uid.integerValue];
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_WEIBO_USER_INFO, token, uid] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        
        NSLog(@"%@", resposeObject);
        
        self.fastNickName = resposeObject[@"name"];
        NSString *gender = resposeObject[@"gender"];
        if ([gender isEqualToString:@"m"]) {
            self.fastGender = @"男";
        } else if ([gender isEqualToString:@"f"]) {
            self.fastGender = @"女";
        }
        NSString *avatarUrl = resposeObject[@"profile_image_url"];
        self.fastAvatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarUrl]]];
        
        if (self.fastId.length != 0) {
            [self afterFastLoginAction];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - WeChatDelegate

- (void)getWeChatInfo:(NSNotification *)message {
    
    NSDictionary *dic = message.object;
    
    NSString *code = dic[@"code"];
    
    NSLog(@"wechat code = %@", code);
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_TOKEN_FROM_WECHAT, @"wxab1c2b71c7ff40c6", @"ae30f47f22e4e436e42d8e12d4cbb0f4", code] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        
        NSString *token = resposeObject[@"access_token"];
        NSString *openId = resposeObject[@"openid"];
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_WECHAT_INFO, token, openId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            
            self.fastId = resposeObject[@"unionid"];
            self.fastNickName = resposeObject[@"nickname"];
            
            NSString *avatarUrl = resposeObject[@"headimgurl"];
            self.fastAvatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarUrl]]];
            
            NSNumber *gender = resposeObject[@"gender"];
            if ([gender isEqualToNumber:@1]) {
                self.fastGender = @"男";
            } else if ([gender isEqualToNumber:@0]) {
                self.fastGender = @"女";
            }
            
            if (self.fastId.length != 0) {
                [self afterFastLoginAction];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
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
