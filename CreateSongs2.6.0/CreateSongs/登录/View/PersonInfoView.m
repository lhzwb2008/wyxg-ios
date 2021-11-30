//
//  PersonInfoView.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/4/23.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonInfoView.h"
#import "AXGHeader.h"
#import <UMCommon/MobClick.h>
#import "AFNetworking.h"
#import "XWAFNetworkTool.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "KVNProgress.h"
#import "AreaPickerView.h"

#define PICKER_HEIGHT 170 * HEIGHT_NIT

#define MAX_SCALE 2.5
#define MIN_SCALE 1.0
#define INFO_TXT_COLOR [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0 alpha:1]

@implementation PersonInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexStringColor(@"#eeeeee");
        [self createNavView];
        [self createPersonInformation];
        [self createMaskMaskView];
        [self createTextEditView];
        [self createDatePickView];
        [self createLocationPicker];
    }
    return self;
}

#pragma mark - 初始化界面

// 创建导航栏
- (void)createNavView {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 64)];
    [self addSubview:navView];
    navView.backgroundColor = HexStringColor(@"#879999");
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, self.width - 110, 44)];
    [navView addSubview:navTitle];
    navTitle.center = CGPointMake(navTitle.centerX, 42);
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitle setFont:TECU_FONT(18)];
    navTitle.text = @"修改资料";
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 100 * WIDTH_NIT - 16, 0, 100 * WIDTH_NIT, 30)];
    rightLabel.center =CGPointMake(rightLabel.centerX, navTitle.centerY);
    [navView addSubview:rightLabel];
    rightLabel.text = @"保存";
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.font = ZHONGDENG_FONT(15);
    rightLabel.textAlignment = NSTextAlignmentRight;
    
    UIButton *navRightButton = [UIButton new];
    navRightButton.frame = CGRectMake(self.width - 64, 0, 64, 64);
    [navView addSubview:navRightButton];
    navRightButton.backgroundColor = [UIColor clearColor];
    [navRightButton addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 创建个人信息界面
- (void)createPersonInformation {
    
    /************************** blockView1 *****************************/
    
    CGFloat navH = kDevice_Is_iPhoneX ? 88 : 64;
    self.blockView1 = [[UIView alloc] initWithFrame:CGRectMake(0, navH + 35 * HEIGHT_NIT, self.width, 148 * HEIGHT_NIT)];
    [self addSubview:self.blockView1];
    self.blockView1.backgroundColor = [UIColor whiteColor];
//    self.blockView1.layer.shadowOpacity = 0.3;
//    self.blockView1.layer.shadowRadius = 1.5;
//    self.blockView1.layer.shadowOffset = CGSizeMake(0, 1.5);
//    self.blockView1.layer.shadowColor = [UIColor blackColor].CGColor;
    
    // 头像
    UILabel *headImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, 0, 50, 60 * HEIGHT_NIT)];
    [self.blockView1 addSubview:headImageLabel];
    headImageLabel.text = @"头像";
    headImageLabel.font = ZHONGDENG_FONT(15);
    headImageLabel.textColor = HexStringColor(@"#535353");
    
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - (16 * WIDTH_NIT + 45 * HEIGHT_NIT), 0, 45 * HEIGHT_NIT, 45 * HEIGHT_NIT)];
    self.headImage.center = CGPointMake(self.headImage.centerX, headImageLabel.centerY);
    self.headImage.image = [UIImage imageNamed:@"修改资料头像"];
    [self.blockView1 addSubview:self.headImage];
    self.headImage.layer.cornerRadius = self.headImage.width / 2;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.borderColor = HexStringColor(@"#879999").CGColor;
    self.headImage.layer.borderWidth = 0.5;
    self.headImage.userInteractionEnabled = YES;
    
    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.blockView1.width, 0.5)];
    [self.blockView1 addSubview:line0];
    line0.backgroundColor = HexStringColor(@"#879999");
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, headImageLabel.bottom - 0.5, self.width - 16 * WIDTH_NIT, 0.5)];
    [self.blockView1 addSubview:line1];
    line1.backgroundColor = line0.backgroundColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareImageDidTap:)];
    [self.headImage addGestureRecognizer:tap];
    
    // 昵称
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, line1.bottom, 50, 44 * HEIGHT_NIT)];
    [self.blockView1 addSubview:nickLabel];
    nickLabel.text = @"昵称";
    nickLabel.textColor = HexStringColor(@"#535353");
    nickLabel.font = ZHONGDENG_FONT(15);
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, nickLabel.bottom - 0.5, self.width - 16 * WIDTH_NIT, 0.5)];
    [self.blockView1 addSubview:line2];
    line2.backgroundColor = line1.backgroundColor;
    
    self.nickName = [[UITextField alloc] initWithFrame:CGRectMake(self.width - 200 - 16 * WIDTH_NIT, nickLabel.top, 200, nickLabel.height)];
    [self.blockView1 addSubview:self.nickName];
    self.nickName.textAlignment = NSTextAlignmentRight;
    self.nickName.font = JIACU_FONT(15);
    self.nickName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName:HexStringColor(@"#a0a0a0"), NSFontAttributeName:NORML_FONT(15)}];
    self.nickName.textColor = [UIColor colorWithHexString:@"#535353"];
    
    UIButton *nickBotton = [UIButton new];
    nickBotton.frame = CGRectMake(0, self.nickName.top, self.width, self.nickName.height);
    nickBotton.tag = 1000;
    nickBotton.backgroundColor = [UIColor clearColor];
    [self.blockView1 addSubview:nickBotton];
    [nickBotton addTarget:self action:@selector(showTextEditView:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, nickLabel.bottom, nickLabel.width, nickLabel.height)];
    [self.blockView1 addSubview:genderLabel];
    genderLabel.font = nickLabel.font;
    genderLabel.textColor = nickLabel.textColor;
    genderLabel.text = @"性别";
    
    self.gender = [[UITextField alloc] initWithFrame:CGRectMake(self.width - 100 - 16 * WIDTH_NIT, genderLabel.top, 100, genderLabel.height)];
    [self.blockView1 addSubview:self.gender];
    self.gender.textAlignment = NSTextAlignmentRight;
    self.gender.enabled = NO;
    self.gender.textColor = self.nickName.textColor;
    self.gender.font = self.nickName.font;
    self.gender.userInteractionEnabled = YES;
    self.gender.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择" attributes:@{NSForegroundColorAttributeName:HexStringColor(@"#a0a0a0"), NSFontAttributeName:NORML_FONT(15)}];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, genderLabel.bottom - 0.5, self.width, 0.5)];
    [self.blockView1 addSubview:line3];
    line3.backgroundColor = line1.backgroundColor;
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, self.gender.top, self.width, self.gender.height)];
//    tapView.center = self.gender.center;
    tapView.backgroundColor = [UIColor clearColor];
    [self.blockView1 addSubview:tapView];
    
    UITapGestureRecognizer *genderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderTapAction:)];
    [tapView addGestureRecognizer:genderTap];
    
    
    /************************** blockView2 *****************************/
    
    self.blockView2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.blockView1.bottom + 35 * HEIGHT_NIT, self.width, 88 * HEIGHT_NIT)];
    [self addSubview:self.blockView2];
    self.blockView2.backgroundColor = [UIColor clearColor];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, self.blockView1.bottom + 17.5 * HEIGHT_NIT, self.width, 17.5 * HEIGHT_NIT)];
    [self addSubview:tipsLabel];
//    tipsLabel.text = @"选填资料（方便我们进一步联系您）";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"选填资料（方便我们进一步联系您）"];
    [string addAttribute:NSForegroundColorAttributeName value:HexStringColor(@"#a0a0a0") range:NSMakeRange(0, string.length)];
    [string addAttributes:@{NSFontAttributeName:NORML_FONT(12)} range:NSMakeRange(0, 4)];
    [string addAttributes:@{NSFontAttributeName:NORML_FONT(10)} range:NSMakeRange(4, string.length - 4)];
    tipsLabel.attributedText = string;
    
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, 0, 100, 44 * HEIGHT_NIT)];
    [self.blockView2 addSubview:birthdayLabel];
    birthdayLabel.textColor = HexStringColor(@"#a0a0a0");
    birthdayLabel.text = @"生日";
    birthdayLabel.font = ZHONGDENG_FONT(15);
    
    self.birthTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.width - 200 - 16 * WIDTH_NIT, birthdayLabel.top, 200, birthdayLabel.height)];
    [self.blockView2 addSubview:self.birthTextField];
    self.birthTextField.textAlignment = NSTextAlignmentRight;
    self.birthTextField.font = JIACU_FONT(15);
//    self.birthTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择" attributes:@{NSForegroundColorAttributeName:NEW_PLACEHOLDER_COLOR}];
    self.birthTextField.userInteractionEnabled = YES;
    self.birthTextField.enabled = NO;
    self.birthTextField.textColor = self.nickName.textColor;
    
    UIView *birthTapView = [[UIView alloc] initWithFrame:CGRectMake(0, self.birthTextField.top, self.width, self.birthTextField.height)];
//    birthTapView.center = self.birthTextField.center;
    [self.blockView2 addSubview:birthTapView];
    birthTapView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *birthdayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(birthdayPickShow:)];
    [birthTapView addGestureRecognizer:birthdayTap];
    
    UIView *wLine0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.blockView1.width, 0.5)];
    [self.blockView2 addSubview:wLine0];
    wLine0.backgroundColor = [UIColor whiteColor];
    
    UIView *wLine1 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, self.birthTextField.bottom - 0.5, self.width - 16 * WIDTH_NIT, 0.5)];
    [self.blockView2 addSubview:wLine1];
    wLine1.backgroundColor = wLine0.backgroundColor;
    
    UITextView *heightText = [UITextView new];
    heightText.text = @"我要写歌";
    heightText.font = self.birthTextField.font;
    self.originHeight = heightText.contentSize.height;
    
    NSLog(@"create origin height %lf", self.originHeight);
    
    self.signitureLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, birthdayLabel.bottom, 100, birthdayLabel.height)];
    [self.blockView2 addSubview:self.signitureLabel];
    self.signitureLabel.textColor = birthdayLabel.textColor;
    self.signitureLabel.text = @"个性签名";
    self.signitureLabel.font = birthdayLabel.font;
    
    self.signitureText = [[UITextView alloc] initWithFrame:CGRectMake(self.width - 168 - 16 * WIDTH_NIT, self.birthTextField.bottom + (44 * HEIGHT_NIT - self.originHeight) / 2, 168, self.originHeight)];
    [self.blockView2 addSubview:self.signitureText];
    self.signitureText.textAlignment = NSTextAlignmentRight;
    self.signitureText.font = self.birthTextField.font;
    self.signitureText.textColor = self.birthTextField.textColor;
    self.signitureText.delegate = self;
    self.signitureText.backgroundColor = [UIColor clearColor];
    
//    self.signiturePlaceholder = [[UILabel alloc] initWithFrame:self.signitureText.frame];
//    [self.blockView2 addSubview:self.signiturePlaceholder];
//    self.signiturePlaceholder.textAlignment = NSTextAlignmentRight;
//    self.signiturePlaceholder.text = @"还没有个性签名";
//    self.signiturePlaceholder.textColor = NEW_PLACEHOLDER_COLOR;
//    self.signiturePlaceholder.font = [UIFont systemFontOfSize:13];
    
    self.signatureButton = [UIButton new];
    self.signatureButton.frame = CGRectMake(0, self.signitureText.top, self.width, self.signitureText.height);
    self.signatureButton.tag = 1001;
    self.signatureButton.backgroundColor = [UIColor clearColor];
    [self.blockView2 addSubview:self.signatureButton];
    [self.signatureButton addTarget:self action:@selector(showTextEditView:) forControlEvents:UIControlEventTouchUpInside];
    
    /************************** blockView3 *****************************/
    
    self.blockView3 = [[UIView alloc] initWithFrame:CGRectMake(0, self.blockView2.bottom, self.width, 44 * HEIGHT_NIT * 5)];
    [self addSubview:self.blockView3];
    self.blockView3.backgroundColor = [UIColor clearColor];
    
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, 0, 100, 44 * HEIGHT_NIT)];
    [self.blockView3 addSubview:weiboLabel];
    weiboLabel.textColor = birthdayLabel.textColor;
    weiboLabel.text = @"微博昵称";
    weiboLabel.font = birthdayLabel.font;
    
    self.weiboText = [[UITextField alloc] initWithFrame:CGRectMake(self.width - 200 - 16 * WIDTH_NIT, 0, 200, weiboLabel.height)];
    [self.blockView3 addSubview:self.weiboText];
    self.weiboText.font = self.birthTextField.font;
    self.weiboText.textColor = self.birthTextField.textColor;
    self.weiboText.textAlignment = NSTextAlignmentRight;
//    self.weiboText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName:NEW_PLACEHOLDER_COLOR}];
    
    UIView *wLine2 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, 0, self.blockView3.width - 16 * WIDTH_NIT, 0.5)];
    [self.blockView3 addSubview:wLine2];
    wLine2.backgroundColor = wLine0.backgroundColor;
    
    UIButton *weiboButton = [UIButton new];
    weiboButton.frame = CGRectMake(0, self.weiboText.top, self.width, self.weiboText.height);
    weiboButton.tag = 1002;
    weiboButton.backgroundColor = [UIColor clearColor];
    [self.blockView3 addSubview:weiboButton];
    [weiboButton addTarget:self action:@selector(showTextEditView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *wLine3 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, weiboLabel.bottom - 0.5, self.width - 16 * WIDTH_NIT, 0.5)];
    [self.blockView3 addSubview:wLine3];
    wLine3.backgroundColor = wLine1.backgroundColor;
    
    UILabel *QQLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, weiboLabel.bottom, 100, 44 * HEIGHT_NIT)];
    [self.blockView3 addSubview:QQLabel];
    QQLabel.textColor = weiboLabel.textColor;
    QQLabel.text = @"QQ";
    QQLabel.font = weiboLabel.font;
    
    self.QQText = [[UITextField alloc] initWithFrame:CGRectMake(self.width - 200 - 16 * WIDTH_NIT, weiboLabel.bottom, 200, QQLabel.height)];
    [self.blockView3 addSubview:self.QQText];
    self.QQText.font = self.weiboText.font;
    self.QQText.textColor = self.weiboText.textColor;
    self.QQText.textAlignment = NSTextAlignmentRight;
//    self.QQText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName:NEW_PLACEHOLDER_COLOR}];
    
    UIButton *qqButton = [UIButton new];
    qqButton.frame = CGRectMake(0, self.QQText.top, self.width, self.QQText.height);
    qqButton.tag = 1003;
    qqButton.backgroundColor = [UIColor clearColor];
    [self.blockView3 addSubview:qqButton];
    [qqButton addTarget:self action:@selector(showTextEditView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *wLin4 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, QQLabel.bottom - 0.5, self.width - 16 * WIDTH_NIT, 0.5)];
    [self.blockView3 addSubview:wLin4];
    wLin4.backgroundColor = wLine0.backgroundColor;
    
    UILabel *weChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, QQLabel.bottom, 100, 44 * HEIGHT_NIT)];
    [self.blockView3 addSubview:weChatLabel];
    weChatLabel.textColor = QQLabel.textColor;
    weChatLabel.text = @"微信号";
    weChatLabel.font = QQLabel.font;
    
    self.weChatText = [[UITextField alloc] initWithFrame:CGRectMake(self.width - 200 - 16 * WIDTH_NIT, QQLabel.bottom, 200, weChatLabel.height)];
    [self.blockView3 addSubview:self.weChatText];
    self.weChatText.font = self.QQText.font;
    self.weChatText.textColor = self.QQText.textColor;
    self.weChatText.textAlignment = NSTextAlignmentRight;
//    self.weChatText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName:NEW_PLACEHOLDER_COLOR}];
    
    UIButton *weChatButton = [UIButton new];
    weChatButton.frame = CGRectMake(0, self.weChatText.top, self.width, self.weChatText.height);
    weChatButton.tag = 1004;
    weChatButton.backgroundColor = [UIColor clearColor];
    [self.blockView3 addSubview:weChatButton];
    [weChatButton addTarget:self action:@selector(showTextEditView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *wLine5 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, weChatLabel.bottom - 0.5, self.width - 16 * WIDTH_NIT, 0.5)];
    [self.blockView3 addSubview:wLine5];
    wLine5.backgroundColor = wLine0.backgroundColor;
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, weChatLabel.bottom, 100, 44 * HEIGHT_NIT)];
    [self.blockView3 addSubview:locationLabel];
    locationLabel.textColor = weChatLabel.textColor;
    locationLabel.text = @"所在地";
    locationLabel.font = weChatLabel.font;
    
    self.locationText = [[UITextField alloc] initWithFrame:CGRectMake(self.width - 200 - 16 * WIDTH_NIT, weChatLabel.bottom, 200, locationLabel.height)];
    [self.blockView3 addSubview:self.locationText];
    self.locationText.font = self.weiboText.font;
    self.locationText.textColor = self.weiboText.textColor;
    self.locationText.textAlignment = NSTextAlignmentRight;
//    self.locationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择" attributes:@{NSForegroundColorAttributeName:NEW_PLACEHOLDER_COLOR}];
    
    UIView *locationTapView = [[UIView alloc] initWithFrame:CGRectMake(0, self.locationText.top, self.width, self.locationText.height)];
    [self.blockView3 addSubview:locationTapView];
    locationTapView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *loacaitonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationPickShow:)];
    [locationTapView addGestureRecognizer:loacaitonTap];
    
    UIView *wLine6 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, locationLabel.bottom - 0.5, self.width - 16 * WIDTH_NIT, 0.5)];
    [self.blockView3 addSubview:wLine6];
    wLine6.backgroundColor = wLine0.backgroundColor;
    
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, locationLabel.bottom, 100, 44 * HEIGHT_NIT)];
    [self.blockView3 addSubview:schoolLabel];
    schoolLabel.textColor = locationLabel.textColor;
    schoolLabel.text = @"学校/公司";
    schoolLabel.font = locationLabel.font;
    
    self.schoolOrCompanyText = [[UITextField alloc] initWithFrame:CGRectMake(self.width - 200 - 16 * WIDTH_NIT, locationLabel.bottom, 200, schoolLabel.height)];
    [self.blockView3 addSubview:self.schoolOrCompanyText];
    self.schoolOrCompanyText.font = self.locationText.font;
    self.schoolOrCompanyText.textColor = self.locationText.textColor;
    self.schoolOrCompanyText.textAlignment = NSTextAlignmentRight;
//    self.schoolOrCompanyText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName:NEW_PLACEHOLDER_COLOR}];
    
    
    UIView *wLine7 = [[UIView alloc] initWithFrame:CGRectMake(0, self.blockView3.height - 0.5, self.blockView3.width, 0.5)];
    [self.blockView3 addSubview:wLine7];
    wLine7.backgroundColor = wLine0.backgroundColor;
    
    UIButton *schoolButton = [UIButton new];
    schoolButton.frame = CGRectMake(0, self.schoolOrCompanyText.top, self.width, self.schoolOrCompanyText.height);
    schoolButton.tag = 1005;
    schoolButton.backgroundColor = [UIColor clearColor];
    [self.blockView3 addSubview:schoolButton];
    [schoolButton addTarget:self action:@selector(showTextEditView:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *promissLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 30 * HEIGHT_NIT, self.width, 30 * HEIGHT_NIT)];
    [self addSubview:promissLabel];
    promissLabel.textAlignment = NSTextAlignmentCenter;
    promissLabel.textColor = HexStringColor(@"#a0a0a0");
    promissLabel.text = @"我要写歌承诺不会泄露您的个人资料";
    promissLabel.font = ZHONGDENG_FONT(10);
    
}

// 创建遮罩
- (void)createMaskMaskView {
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.5;
    self.maskView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMaskView)];
    [self.maskView addGestureRecognizer:tap];
    
}

// 创建文字输入界面
- (void)createTextEditView {
    self.textEditView = [[UIView alloc] initWithFrame:CGRectMake(25 * WIDTH_NIT, 115 * WIDTH_NIT, self.width - 50 * WIDTH_NIT, 245 * WIDTH_NIT)];
    [self addSubview:self.textEditView];
    self.textEditView.backgroundColor = [UIColor clearColor];
    
    self.originRect = self.textEditView.frame;
    self.startRect = CGRectMake(self.textEditView.left, -self.textEditView.height, self.textEditView.width, self.textEditView.height);
    self.endRect = CGRectMake(self.textEditView.left, self.height, self.textEditView.width, self.textEditView.height);
    
    self.textEditView.frame = self.startRect;

//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100 * WIDTH_NIT, 30 * WIDTH_NIT)];
//    [self.textEditView addSubview:self.titleLabel];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel.text = @"编辑";
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.font = JIACU_FONT(15);
//    self.titleLabel.layer.cornerRadius = self.titleLabel.height / 2;
//    self.titleLabel.layer.masksToBounds = YES;
//    self.titleLabel.backgroundColor = HexStringColor(@"#879999");
    
//    UIImageView *cancelImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.textEditView.width - 30 * WIDTH_NIT, 0, 30 * WIDTH_NIT, 30 * WIDTH_NIT)];
//    cancelImage.image = [UIImage imageNamed:@"登录_x"];
//    [self.textEditView addSubview:cancelImage];
//    cancelImage.layer.cornerRadius = cancelImage.height / 2;
//    cancelImage.layer.masksToBounds = YES;
    
//    self.editBtnCancel = [UIButton new];
//    [self.textEditView addSubview:self.editBtnCancel];
//    self.editBtnCancel.backgroundColor = [UIColor clearColor];
//    self.editBtnCancel.frame = cancelImage.frame;
//    [self.editBtnCancel addTarget:self action:@selector(textEditCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *editingView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 * WIDTH_NIT, 325 * WIDTH_NIT, 150 * WIDTH_NIT)];
    [self.textEditView addSubview:editingView];
    editingView.backgroundColor = [UIColor whiteColor];
    editingView.layer.cornerRadius = 5 * WIDTH_NIT;
    editingView.layer.masksToBounds = YES;
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 * WIDTH_NIT, 30 * WIDTH_NIT, editingView.width - 50 * WIDTH_NIT, 15)];
    [editingView addSubview:self.placeholderLabel];
    self.placeholderLabel.text = @"请输入";
    self.placeholderLabel.textColor = HexStringColor(@"#a0a0a0");
    self.placeholderLabel.font = NORML_FONT(15);
    self.placeholderLabel.hidden = YES;
    
    self.editTextField = [[UITextView alloc] initWithFrame:CGRectMake(22 * WIDTH_NIT, 20 * WIDTH_NIT, editingView.width - 44 * WIDTH_NIT, (100 - 35) * WIDTH_NIT)];
    [editingView addSubview:self.editTextField];
    self.editTextField.delegate = self;
    self.editTextField.backgroundColor = [UIColor clearColor];
    self.editTextField.font = JIACU_FONT(15);
    self.editTextField.textColor = HexStringColor(@"#535353");
    
    self.editingTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(editingView.width - 100 - 22 * WIDTH_NIT, (100 - 35) * WIDTH_NIT, 100, 35 * WIDTH_NIT)];
    [editingView addSubview:self.editingTipsLabel];
    self.editingTipsLabel.text = @"(0/18)";
    self.editingTipsLabel.textAlignment = NSTextAlignmentRight;
    self.editingTipsLabel.textColor = HexStringColor(@"#a0a0a0");
    self.editingTipsLabel.font = NORML_FONT(15);
    
    
    
//    [self.editTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.editBtnConfirm = [UIButton new];
    self.editBtnConfirm.frame = CGRectMake(0, 100 * WIDTH_NIT, editingView.width, 50 * WIDTH_NIT);
    [editingView addSubview:self.editBtnConfirm];
//    self.editBtnConfirm.backgroundColor = HexStringColor(@"#879999");
    [self.editBtnConfirm setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [self.editBtnConfirm setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
    [self.editBtnConfirm setTitle:@"确 定" forState:UIControlStateNormal];
    [self.editBtnConfirm setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [self.editBtnConfirm setTitleColor:HexStringColor(@"#FFDC74") forState:UIControlStateHighlighted];
    [self.editBtnConfirm addTarget:self action:@selector(textEditConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textEditView.hidden = YES;
    
}

// 创建时间选择器界面
- (void)createDatePickView {
    self.datePickView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, PICKER_HEIGHT)];
    [self addSubview:self.datePickView];
    self.datePickView.backgroundColor = [UIColor whiteColor];
    
    UIDatePicker *datePick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.datePickView.width, self.datePickView.height - 30 * HEIGHT_NIT)];
    [self.datePickView addSubview:datePick];
    datePick.datePickerMode = UIDatePickerModeDate;
    [datePick addTarget:self action:@selector(datePickChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *button = [UIButton new];
    [self.datePickView addSubview:button];
    button.frame = CGRectMake(0, datePick.bottom, self.datePickView.width, 30 * HEIGHT_NIT);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:HexStringColor(@"#535353") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 创建地区选择器
- (void)createLocationPicker {
    self.cityPickView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, PICKER_HEIGHT)];
    [self addSubview:self.cityPickView];
    self.cityPickView.backgroundColor = [UIColor whiteColor];
    
    AreaPickerView *picker = [[AreaPickerView alloc] initWithFrame:CGRectMake(0, 0, self.cityPickView.width, self.cityPickView.height - 30 * HEIGHT_NIT)];
    [self.cityPickView addSubview:picker];
    
    WEAK_SELF;
    picker.areaInfoBlock = ^ (NSString *province, NSString *city, NSString *area) {
        STRONG_SELF;
        self.locationText.text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    };
    
    UIButton *button = [UIButton new];
    [self.cityPickView addSubview:button];
    button.frame = CGRectMake(0, picker.bottom, self.cityPickView.width, 30 * HEIGHT_NIT);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:HexStringColor(@"#535353") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 方法

// 弹起输入框
- (void)showTextEditView:(UIButton *)sender {
    
    self.editTextField.keyboardType = UIKeyboardTypeDefault;
    
    self.editTextField.text = @"";
    
    switch (sender.tag - 1000) {
        case 0: {
            self.titleLabel.text = @"昵称";
            self.editingTipsLabel.text = @"(0/15)";
            self.textType = nickType;
            self.editTextField.text = self.nickName.text;
            
            if (self.nickName.text.length == 0) {
                self.placeholderLabel.hidden = NO;
                self.placeholderLabel.text = @"请输入昵称";
            } else {
                self.placeholderLabel.hidden = YES;
                self.placeholderLabel.text = @"请输入昵称";
            }
            
        }
            break;
        case 1: {
            self.titleLabel.text = @"个性签名";
            self.editingTipsLabel.text = @"(0/30)";
            self.textType = signatureType;
            self.editTextField.text = self.signitureText.text;
            
            if (self.signitureText.text.length == 0) {
                self.placeholderLabel.hidden = NO;
                self.placeholderLabel.text = @"请输入个性签名";
            } else {
                self.placeholderLabel.hidden = YES;
                self.placeholderLabel.text = @"请输入个性签名";
            }
            
        }
            break;
        case 2: {
            self.titleLabel.text = @"微博昵称";
            self.editingTipsLabel.text = @"(0/15)";
            self.textType = weiboType;
            self.editTextField.text = self.weiboText.text;
            
            if (self.weiboText.text.length == 0) {
                self.placeholderLabel.hidden = NO;
                self.placeholderLabel.text = @"请输入微博昵称";
            } else {
                self.placeholderLabel.hidden = YES;
                self.placeholderLabel.text = @"请输入微博昵称";
            }
            
        }
            break;
        case 3: {
            self.titleLabel.text = @"QQ";
            self.editingTipsLabel.text = @"(0/15)";
            self.textType = qqType;
            self.editTextField.text = self.QQText.text;
            self.editTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            if (self.QQText.text.length == 0) {
                self.placeholderLabel.hidden = NO;
                self.placeholderLabel.text = @"请输入QQ";
            } else {
                self.placeholderLabel.hidden = YES;
                self.placeholderLabel.text = @"请输入QQ";
            }
            
        }
            break;
        case 4: {
            self.titleLabel.text = @"微信";
            self.editingTipsLabel.text = @"(0/30)";
            self.textType = weChatType;
            self.editTextField.text = self.weChatText.text;
            
            if (self.weChatText.text.length == 0) {
                self.placeholderLabel.hidden = NO;
                self.placeholderLabel.text = @"请输入微信";
            } else {
                self.placeholderLabel.hidden = YES;
                self.placeholderLabel.text = @"请输入微信";
            }
            
        }
            break;
        case 5: {
            self.titleLabel.text = @"学校/公司";
            self.editingTipsLabel.text = @"(0/30)";
            self.textType = schoolType;
            self.editTextField.text = self.schoolOrCompanyText.text;
            
            if (self.schoolOrCompanyText.text.length == 0) {
                self.placeholderLabel.hidden = NO;
                self.placeholderLabel.text = @"请输入学校/公司";
            } else {
                self.placeholderLabel.hidden = YES;
                self.placeholderLabel.text = @"请输入学校/公司";
            }
            
        }
            break;
            
        default:
            break;
    }
    
    [self.editTextField becomeFirstResponder];
    
    self.textEditView.alpha = 0;
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.textEditView.alpha = 1;
        self.textEditView.frame = self.originRect;
        self.textEditView.hidden = NO;
        self.maskView.hidden = NO;
        if (self.showMaskBlock) {
            self.showMaskBlock();
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

// 弹窗确定按钮
- (void)textEditConfirm:(UIButton *)sender {
    
    switch (self.textType) {
        case nickType: {
            self.nickName.text = self.editTextField.text;
        }
            break;
        case signatureType: {
            self.signitureText.text = self.editTextField.text;
            
            if (self.signitureText.text.length != 0) {
                self.signiturePlaceholder.hidden = YES;
            } else {
                self.signiturePlaceholder.hidden = NO;
            }
            
            CGFloat height = self.signitureText.contentSize.height - self.originHeight;
            
            self.signitureText.frame = CGRectMake(self.signitureText.left, self.birthTextField.bottom + (44 * HEIGHT_NIT - self.originHeight) / 2, 168, self.signitureText.contentSize.height);
            self.signitureLabel.frame = CGRectMake(16 * WIDTH_NIT, self.signitureLabel.top, 100, 44 * HEIGHT_NIT + height);
            self.blockView2.frame = CGRectMake(self.blockView2.left, self.blockView2.top, self.blockView2.width, 88 * HEIGHT_NIT + height);
            
            self.blockView3.frame = CGRectMake(self.blockView3.left, self.blockView2.bottom + 10 * HEIGHT_NIT, self.blockView3.width, self.blockView3.height);
        }
            break;
        case weiboType: {
            self.weiboText.text = self.editTextField.text;
        }
            break;
        case qqType: {
            self.QQText.text = self.editTextField.text;
        }
            break;
        case weChatType: {
            self.weChatText.text = self.editTextField.text;
        }
            break;
        case schoolType: {
            self.schoolOrCompanyText.text = self.editTextField.text;
        }
            break;
            
        default:
            break;
    }
    
    [self textEditCancel:nil];
    
}

// 弹窗取消按钮
- (void)textEditCancel:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.textEditView.frame = self.endRect;
        self.textEditView.alpha = 0;
        
        self.textEditView.hidden = YES;
        self.maskView.hidden = YES;
        if (self.hideMaskBlock) {
            self.hideMaskBlock();
        }
        
    } completion:^(BOOL finished) {
        
        self.textEditView.frame = self.startRect;
        
    }];

    [[UIResponder currentFirstResponder] resignFirstResponder];
}

// 展现遮罩
- (void)showMaskView {
    if (self.showMaskBlock) {
        self.showMaskBlock();
    }
    self.maskView.hidden = NO;
}

// 隐藏遮罩
- (void)hideMaskView {
    if (self.hideMaskBlock) {
        self.hideMaskBlock();
    }
    self.maskView.hidden = YES;
    [self viewHideAction:self.datePickView];
    [self viewHideAction:self.cityPickView];
    [self textEditCancel:nil];
}

// 时间选择器改变方法
- (void)datePickChanged:(UIDatePicker *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [dateFormatter stringFromDate:date.date];
    self.birthTextField.text = string;
}

// 时间选择器出现
- (void)birthdayPickShow:(UIGestureRecognizer *)tap {
    [self viewShowAction:self.datePickView];
    [self showMaskView];
}

// 地区选择器出现
- (void)locationPickShow:(UIGestureRecognizer *)tap {
    [self viewShowAction:self.cityPickView];
    [self showMaskView];
}

- (void)hideButtonAction:(UIButton *)sender {
    [self viewHideAction:sender.superview];
    [self hideMaskView];
}

// 选择器出现方法
- (void)viewShowAction:(UIView *)view {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.frame = CGRectMake(0, self.height - PICKER_HEIGHT, self.width, PICKER_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

// 选择器消失方法
- (void)viewHideAction:(UIView *)view {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.frame = CGRectMake(0, self.height, self.width, PICKER_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

// 完成按钮方法
- (void)completeButtonAction:(UIButton *)sender {
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    [self.delegate saveButtonDelegate];
}

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    
    // 代理方法，回到登录前页面
    [self.delegate backButtonDelegate];
    
}

// 性别选择方法
- (void)genderTapAction:(UITapGestureRecognizer *)tap {
    
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    // 代理方法，使用父countroler弹出
    
    [self.delegate selectGender];
    
}

// 选取图片方法
- (void)shareImageDidTap:(UITapGestureRecognizer *)tap {
    
    [self.delegate selectHeadImage];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textDidChange:(id)sender {
    UITextField *textField = (UITextField *)sender;
    
    NSString *text = textField.text;
    
    if (self.textType == nickType) {
        
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/15)", 15 - textField.text.length + 1];
        
        if (textField.text.length > 15) {
            
            textField.text = [textField.text substringToIndex:15];
            
            NSLog(@"超过15个字");
        }
    } else if (self.textType == signatureType) {
        
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/30)", 30 - textField.text.length + 1];
        
        if (textField.text.length > 30) {
            
            textField.text = [textField.text substringToIndex:30];
            
            NSLog(@"超过30个字");
        }
        
        
        CGFloat height = self.signitureText.contentSize.height - self.originHeight;
        
        self.signitureText.frame = CGRectMake(self.signitureText.left, self.birthTextField.bottom + (44 * HEIGHT_NIT - self.originHeight) / 2, 168, self.signitureText.contentSize.height);
        self.signitureLabel.frame = CGRectMake(16 * WIDTH_NIT, self.signitureLabel.top, 100, 44 * HEIGHT_NIT + height);
        self.blockView2.frame = CGRectMake(self.blockView2.left, self.blockView2.top, self.blockView2.width, 88 * HEIGHT_NIT + height);
        
        self.blockView3.frame = CGRectMake(self.blockView3.left, self.blockView2.bottom + 10 * HEIGHT_NIT, self.blockView3.width, self.blockView3.height);
        
    } else if (self.textType == weChatType) {
        
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/30)", 30 - textField.text.length + 1];
        if (textField.text.length > 30) {
            
            textField.text = [textField.text substringToIndex:30];
            
            NSLog(@"超过30个字");
        }
        
        if (textField.markedTextRange == Nil) {
            NSString *temp = nil;
            NSMutableString *newText = [NSMutableString string];
            
            for(int i = 0; i < [text length]; i++) {
                
                temp = [text substringWithRange:NSMakeRange(i, 1)];
                
                NSString * regex = @"^[A-Za-z0-9]+$";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                BOOL isMatch = [pred evaluateWithObject:temp];
                if (isMatch == NO) {
                    
                    textField.text = [textField.text stringByReplacingOccurrencesOfString:temp withString:@""];
                    
                } else {
                    [newText appendString:temp];
                }
                
            }
        }
    } else if (self.textType == qqType || self.textType == weiboType) {
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/15)", 15 - textField.text.length + 1];
        
        if (textField.text.length > 15) {
            
            textField.text = [textField.text substringToIndex:15];
            
            NSLog(@"超过15个字");
        }
    } else if (self.textType == schoolType) {
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/30)", 30 - textField.text.length + 1];
        
        if (textField.text.length > 30) {
            
            textField.text = [textField.text substringToIndex:30];
            
            NSLog(@"超过30个字");
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
    
//    if (textView.text.length > 30) {
//        
//        textView.text = [textView.text substringToIndex:30];
//        
//        NSLog(@"超过30个字");
//    }
//    
//    CGFloat height = self.signitureText.contentSize.height - self.originHeight;
//    
//    self.signitureText.frame = CGRectMake(self.signitureText.left, self.birthTextField.bottom + (44 * HEIGHT_NIT - self.originHeight) / 2, 168, self.signitureText.contentSize.height);
//    self.signitureLabel.frame = CGRectMake(10 * WIDTH_NIT, self.signitureLabel.top, 100, 44 * HEIGHT_NIT + height);
//    self.blockView2.frame = CGRectMake(self.blockView2.left, self.blockView2.top, self.blockView2.width, 88 * HEIGHT_NIT + height);
//    
//    self.blockView3.frame = CGRectMake(self.blockView3.left, self.blockView2.bottom + 10 * HEIGHT_NIT, self.blockView3.width, self.blockView3.height);
    
    
    UITextView *textField = (UITextView *)textView;
    
    NSString *text = textField.text;
    
    
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:JIACU_FONT(15),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    if (self.textType == nickType) {
        
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/15)", textField.text.length];
        
        if (textField.text.length > 15) {
            
            self.editingTipsLabel.text = @"(15/15)";
            textField.text = [textField.text substringToIndex:15];
            
            NSLog(@"超过15个字");
        }
    } else if (self.textType == signatureType) {
        
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/30)", textField.text.length];
        
        if (textField.text.length > 30) {
            
            self.editingTipsLabel.text = @"(30/30)";
            textField.text = [textField.text substringToIndex:30];
            
            NSLog(@"超过30个字");
        }
        
        
        CGFloat height = self.signitureText.contentSize.height - self.originHeight;
        
        self.signitureText.frame = CGRectMake(self.signitureText.left, self.birthTextField.bottom + (44 * HEIGHT_NIT - self.originHeight) / 2, 168, self.signitureText.contentSize.height);
        self.signitureLabel.frame = CGRectMake(16 * WIDTH_NIT, self.signitureLabel.top, 100, 44 * HEIGHT_NIT + height);
        self.blockView2.frame = CGRectMake(self.blockView2.left, self.blockView2.top, self.blockView2.width, 88 * HEIGHT_NIT + height);
        
        self.blockView3.frame = CGRectMake(self.blockView3.left, self.blockView2.bottom + 10 * HEIGHT_NIT, self.blockView3.width, self.blockView3.height);
        
    } else if (self.textType == weChatType) {
        
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/30)", textField.text.length];
        if (textField.text.length > 30) {
            
            self.editingTipsLabel.text = @"(30/30)";
            textField.text = [textField.text substringToIndex:30];
            
            NSLog(@"超过30个字");
        }
        
        if (textField.markedTextRange == Nil) {
            NSString *temp = nil;
            NSMutableString *newText = [NSMutableString string];
            
            for(int i = 0; i < [text length]; i++) {
                
                temp = [text substringWithRange:NSMakeRange(i, 1)];
                
                NSString * regex = @"^[A-Za-z0-9]+$";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                BOOL isMatch = [pred evaluateWithObject:temp];
                if (isMatch == NO) {
                    
                    textField.text = [textField.text stringByReplacingOccurrencesOfString:temp withString:@""];
                    
                } else {
                    [newText appendString:temp];
                }
                
            }
        }
    } else if (self.textType == qqType || self.textType == weiboType) {
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/15)", textField.text.length];
        
        if (textField.text.length > 15) {
            
            self.editingTipsLabel.text = @"(15/15)";
            textField.text = [textField.text substringToIndex:15];
            
            NSLog(@"超过15个字");
        }
    } else if (self.textType == schoolType) {
        self.editingTipsLabel.text = [NSString stringWithFormat:@"(%ld/30)", textField.text.length];
        
        if (textField.text.length > 30) {
            
            self.editingTipsLabel.text = @"(30/30)";
            textField.text = [textField.text substringToIndex:30];
            
            NSLog(@"超过30个字");
        }
    }
}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    self.placeholderLabel.hidden = YES;
//    return YES;
//}

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    
//    if (self.editTextField.text.length != 0) {
//        self.placeholderLabel.hidden = YES;
//    } else {
//        self.placeholderLabel.hidden = NO;
//    }
//    
//    return YES;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIResponder currentFirstResponder] resignFirstResponder];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
