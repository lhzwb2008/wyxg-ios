//
//  SendNoteViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SendNoteViewController.h"
#import "AXGHeader.h"
#import "XWAFNetworkTool.h"
#import "AFNetworking.h"
#import "KVNProgress.h"
#import "LoginViewController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "AXGMessage.h"
#import "MobClick.h"
#import "NavLeftButton.h"
#import "NavRightButton.h"
#import "SongModel.h"
#import "SelectSongViewController.h"

@interface SendNoteViewController ()<UITextViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextView *contentText;

@property (nonatomic, strong) UIView *toolView;

@property (nonatomic, strong) UIImageView *pickImage;

@property (nonatomic, strong) UIImage *avatar;

@property (nonatomic, strong) UIView *bottomImageView;

@property (nonatomic, strong) UIView *bottomSongView;

@property (nonatomic, strong) UIImageView *pickSongImage;

@property (nonatomic, strong) SongModel *songModel;

@property (nonatomic, strong) UILabel *txtNumberLabel;

@property (nonatomic, strong) UILabel *placeHolderText;

@property (nonatomic, assign) CGRect frame1;

@property (nonatomic, assign) CGRect frame2;

@end

@implementation SendNoteViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTextView];
    [self createToolView];
    
    [self createNavView];
    //注册为被通知者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyChangeShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyChangeHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *vcName = NSStringFromClass([self class]);
    [MobClick beginLogPageView:vcName];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSString *vcName = NSStringFromClass([self class]);
    [MobClick endLogPageView:vcName];
}

#pragma mark - 初始化界面

// 导航栏
- (void)createNavView {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [self.view addSubview:navView];
    navView.backgroundColor = HexStringColor(@"#FFDC74");
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [navView addSubview:titleLabel];
    titleLabel.font = TECU_FONT(18*HEIGHT_NIT);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#441D11"];
    titleLabel.text = @"新话题";
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 23, 20)];
    [navView addSubview:backImage];
    backImage.center = CGPointMake(backImage.centerX, 42);
//    backImage.image = [UIImage imageNamed:@"返回"];
    
    titleLabel.center = CGPointMake(self.view.width / 2, backImage.centerY);
    
    NavLeftButton *leftButton = [NavLeftButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 64, 64);
    [navView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    
//    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width -  (40 + 16), 30, 40, 20)];
//    [navView addSubview:rightLabel];
//    rightLabel.textColor =  [UIColor colorWithHexString:@"#ffffff"];
//    rightLabel.text = @"发表";
//    rightLabel.textAlignment = NSTextAlignmentRight;
//    rightLabel.font = [UIFont systemFontOfSize:15];
    
    NavRightButton *rightButton = [NavRightButton buttonWithType:UIButtonTypeCustom];
    [navView addSubview:rightButton];
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(self.view.width - 64, 0, 64, 64);
    [rightButton addTarget:self action:@selector(releaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 输入框
- (void)createTextView {
    CGFloat navH = kDevice_Is_iPhoneX ? 88 : 64;
    self.contentText = [[UITextView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, navH + 20 * WIDTH_NIT, self.view.width - 32 * WIDTH_NIT, self.view.height - navH - 20*WIDTH_NIT)];
    [self.view addSubview:self.contentText];
    self.contentText.backgroundColor = [UIColor clearColor];
    self.contentText.textColor = [UIColor colorWithHexString:@"#535353"];
    self.contentText.delegate = self;
    self.contentText.font = ZHONGDENG_FONT(15*WIDTH_NIT);
    self.contentText.returnKeyType = UIReturnKeyDone;
    
    self.placeHolderText = [[UILabel alloc] initWithFrame:CGRectMake(self.contentText.left, self.contentText.top, 200, 15)];
    [self.view addSubview:self.placeHolderText];
    self.placeHolderText.textAlignment = NSTextAlignmentLeft;
    self.placeHolderText.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    self.placeHolderText.font = ZHONGDENG_FONT(15*WIDTH_NIT);
    self.placeHolderText.text = @"是时候聊聊音乐了٩( 'ω' )و";
}

// 工具条
- (void)createToolView {
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 161.5 * HEIGHT_NIT, self.view.width, 161.5 * HEIGHT_NIT)];
    [self.view addSubview:self.toolView];
    
    // 照片预览
    self.bottomImageView = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, 0, 100 * HEIGHT_NIT + 16 * WIDTH_NIT, 117.5 * HEIGHT_NIT)];
    [self.toolView addSubview:self.bottomImageView];
    self.bottomImageView.backgroundColor = [UIColor clearColor];
    
    self.frame1 = self.bottomImageView.frame;
    
    self.pickImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5 * HEIGHT_NIT, 100 * HEIGHT_NIT, 100 * HEIGHT_NIT)];
    [self.bottomImageView addSubview:self.pickImage];
    self.pickImage.backgroundColor = [UIColor blackColor];
    self.pickImage.image = [UIImage imageNamed:@"placeholder"];
    self.pickImage.contentMode = UIViewContentModeScaleAspectFit;
    self.pickImage.layer.cornerRadius = 5;
    self.pickImage.layer.masksToBounds = YES;
    
    UIImageView *cancelImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15 * HEIGHT_NIT, 15 * HEIGHT_NIT)];
    [self.bottomImageView addSubview:cancelImage];
    cancelImage.image = [UIImage imageNamed:@"forum_delete"];
    cancelImage.center = CGPointMake(self.pickImage.right, self.pickImage.top);
    
    UIButton *cancelButton = [UIButton new];
    [self.bottomImageView addSubview:cancelButton];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(deleteImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(0, 0, cancelImage.width * 1.5, cancelImage.height * 1.5);
    cancelButton.center = cancelImage.center;
    
    self.bottomImageView.hidden = YES;
    
    // 歌曲预览
    self.bottomSongView = [[UIView alloc] initWithFrame:CGRectMake(self.bottomImageView.right, 0, 100 * HEIGHT_NIT + 16 * WIDTH_NIT, 117.5 * HEIGHT_NIT)];
    [self.toolView addSubview:self.bottomSongView];
    self.bottomSongView.backgroundColor = [UIColor clearColor];
    
    self.frame2 = self.bottomSongView.frame;
    
    self.pickSongImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5 * HEIGHT_NIT, 100 * HEIGHT_NIT, 100 * HEIGHT_NIT)];
    [self.bottomSongView addSubview:self.pickSongImage];
    self.pickSongImage.backgroundColor = [UIColor clearColor];
    self.pickSongImage.image = [UIImage imageNamed:@"placeholder"];
//    self.pickSongImage.contentMode = UIViewContentModeScaleAspectFit;
    self.pickSongImage.layer.cornerRadius = 7;
    self.pickSongImage.layer.masksToBounds = YES;
    
    UIImageView *maskImage = [UIImageView new];
    [self.bottomSongView addSubview:maskImage];
    maskImage.frame = self.pickSongImage.frame;
    maskImage.layer.cornerRadius = 5;
    maskImage.layer.masksToBounds = YES;
    maskImage.image = [UIImage imageNamed:@"个性推荐模板"];
    
    UIImageView *cancelImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15 * HEIGHT_NIT, 15 * HEIGHT_NIT)];
    [self.bottomSongView addSubview:cancelImage2];
    cancelImage2.image = [UIImage imageNamed:@"forum_delete"];
    cancelImage2.center = CGPointMake(self.pickSongImage.right, self.pickSongImage.top);
    
    UIButton *cancelButton2 = [UIButton new];
    [self.bottomSongView addSubview:cancelButton2];
    cancelButton2.backgroundColor = [UIColor clearColor];
    [cancelButton2 addTarget:self action:@selector(deleteSongButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton2.frame = CGRectMake(0, 0, cancelImage2.width * 1.5, cancelImage2.height * 1.5);
    cancelButton2.center = cancelImage2.center;
    
    self.bottomSongView.hidden = YES;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolView.height - 50 * HEIGHT_NIT, self.toolView.width, 0.5)];
    [self.toolView addSubview:line];
    line.backgroundColor = THEME_COLOR;
    
    // 工具栏按钮
    UIImageView *pickImage = [[UIImageView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, line.bottom + 10 * HEIGHT_NIT, 40 * HEIGHT_NIT, 30 * HEIGHT_NIT)];
    [self.toolView addSubview:pickImage];
    pickImage.image = [UIImage imageNamed:@"发帖相册"];
    
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(0, 0, pickImage.width * 1.1, pickImage.height * 1.1);
    [self.toolView addSubview:button];
    button.center = pickImage.center;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(pickImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *pickSongImage = [[UIImageView alloc] initWithFrame:CGRectMake(pickImage.right + 16 * WIDTH_NIT, pickImage.top, pickImage.width, pickImage.height)];
    [self.toolView addSubview:pickSongImage];
    pickSongImage.image = [UIImage imageNamed:@"发帖歌曲"];
    
    UIButton *button2 = [UIButton new];
    button2.frame = CGRectMake(0, 0, pickSongImage.width * 1.1, pickSongImage.height * 1.1);
    [self.toolView addSubview:button2];
    button2.center = pickSongImage.center;
    button2.backgroundColor = [UIColor clearColor];
    [button2 addTarget:self action:@selector(pickSongButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.txtNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.toolView.width - 100 - 10 * WIDTH_NIT, line.top - 21 * HEIGHT_NIT, 100, 21 * HEIGHT_NIT)];
//    [self.toolView addSubview:self.txtNumberLabel];
//    self.txtNumberLabel.backgroundColor = [UIColor clearColor];
//    self.txtNumberLabel.textColor = [UIColor colorWithHexString:@"#808080"];
//    self.txtNumberLabel.font = [UIFont systemFontOfSize:11];
//    self.txtNumberLabel.text = @"0/140";
//    self.txtNumberLabel.textAlignment = NSTextAlignmentRight;
    
}

#pragma mark - Action

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

// 发表按钮方法
- (void)releaseButtonAction:(UIButton *)sender {
    
    
//    NSString *post = @"【 关于如何发帖 】\n\n发贴前缀必须为 【XX】\n发帖者可以根据自己帖子的实际内容在【 】进行填写。例如，【作词】【作曲】【教学】【原创】【闲谈】【音乐分享】【求助】 相类似的主题都被允许使用。\n\n在本社区发帖，请遵守这里的每一项规定，对于没有按照格式要求发表的帖子，首次予以警告，第二次将予以删除。\n\n\n\n【 关于分享音乐 】\n\n所有分享音乐的帖子，请在发帖之前，先给你的帖子做一个最初的定义，你分享的音乐，大致属于那一类的，请在标题上做出说明。例如，【欧美音乐】【中文音乐】【日韩音乐】【优美纯音】 等等。\n\n标题的分类可以根据自己的实际情况编写，但内容与标题需要相符合才好。\n如果你的帖子日后要申请置顶帖，发帖的最初一定要使用这种规范的发贴格式。其他的格式，不予受理加精的申请。\n\n\n\n【 关于删除帖子 】\n\n在本社区发帖，必须遵守这里的各种规定，文明发帖，礼貌回复。\n任何不文明的行为在这里都是被禁止的，如果你的帖子违反了本站规定将会被删除。\n\n1.任何包含谩骂、侮辱、人身攻击等不文明内容的发言均会被删除，删后再犯者封禁；\n2.任何纯粹挑衅性质（或包含明显挑衅内容）、会引发互相攻击谩骂（或已引发互骂）的话题均会被删除，删后继续开贴发类似内容者封禁；\n3.单独开贴刊登广告均会被删除（包括提供免费服务）；\n4.过于简单的入门问题（往往已被反复问了无数次）很可能被删除；\n5.内容过于荒谬、具有严重误导性的贴子很可能被删除，本社区不仅是音乐交流园地，也是提供具有一定参考价值资源的地方；\n6.其它严重影响版面秩序但未被上述条款归纳的内容亦可能被删除。\n\n\n\n【 关于音乐求助 】\n\n求助帖将会不定期置顶。\n求作词作曲的，请在标题上作出说明，例如【求词】、【求曲】、【求歌名】、【求曲谱】等；\n求助者尽可能的给出详尽的求助信息；\n发出求助信息后，请耐心等待。\n对于没有给出任何实质性信息的求助帖，不符合发帖规则的求助帖，都将被删除。\n\n\n\n【 关于申请置顶】\n\n申请置顶的帖子，标题必须规范的发贴格式，例如，【 英文歌曲 】、【中文歌曲】等\n申请置顶帖的格式 按照以下要求：\n申请置顶贴的标题：\n申请置顶贴的链接：\n申请置顶贴的分类：\n申请置顶贴的理由：\n没有按照这种规范格式发帖的，不予受理置顶申请。\n帖子的标题与内容不相符的帖子，将无法通过置顶申请。\n\n申请置顶方法：通过官方qq群联系管理人员或者在申请置顶专用帖下回复。\n\n没有属于自己独特的内容，不能给出详细推荐理由的帖子，都将无法通过审核。另外，很多人喜欢在音乐分享贴里添加图片，如果音乐贴里添加的图片，不能增加帖子整体的美观，也不能通过置顶帖的审核。所以，如果没有很好的创意，请谨慎添加图片。\n\n通过审核的置顶帖,将置顶3-5天\n\n\n\n【关于今日话题】\n\n今日话题，必须是互动性极强的帖子，不拘泥于精品帖。\n帖子内容必须积极向上，且具有讨论性或者分享性，但不能存在较大分歧与争议性。\n帖子内音乐数量不限。\n若帖子成为今日话题，保留时间为1-3天。";
    
//    NSString *post = @"【 申请置顶专用帖 】申请置顶请在该帖下按照规定格式回复";
    

    sender.enabled = NO;
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:LOGIN_LOCATION_FORUM_SEND_POST forKey:LOGIN_LOCATION];
        
        AXG_LOGIN(LOGIN_LOCATION_FORUM_SEND_POST);
        sender.enabled = YES;
        
    } else {
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *myId = [wrapper objectForKey:(id)kSecValueData];
        NSDictionary *dic = nil;
        
        if (self.songModel) {
            dic = @{@"user_id":myId, @"content":self.contentText.text, @"is_top":@"0", @"song_id":self.songModel.dataId};
        } else {
            dic = @{@"user_id":myId, @"content":self.contentText.text, @"is_top":@"0"};
        }
        
        if (self.contentText.text.length != 0) {
            
            if (self.avatar) {
                NSData *data = UIImagePNGRepresentation(self.avatar);
                
                [XWAFNetworkTool postUploadWithUrl:ADD_POST fileData:data fileUrl:nil paramter:dic fileName:@"post.png" fileType:@"image/png" success:^(id responseObject) {
                    NSData *data = responseObject;
                    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"success --- %@", str);
                    
                    sender.enabled = YES;
                    
                    [KVNProgress showSuccessWithStatus:@"发布成功"];
                    
                    if ([str isEqualToString:@"{\"status\":0}"]) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPost" object:nil];
                        }];
                    }
                    
                } fail:^{
                    sender.enabled = YES;
                }];
            } else {
                
//                [XWAFNetworkTool postUrlString:ADD_POST body:@{@"user_id":myId, @"content":post, @"is_top":@"1"} response:XWJSON bodyStyle:XWRequestJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//                    
//                    sender.enabled = YES;
//                    
//                    NSLog(@"%@", responseObject);
//                    if ([responseObject[@"status"] isEqualToNumber:@0]) {
//                        [KVNProgress showSuccessWithStatus:@"发布成功"];
//                        [self dismissViewControllerAnimated:YES completion:^{
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPost" object:nil];
//                        }];
//                    }
//                    
//                } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                    sender.enabled = YES;
//                }];
                

                [XWAFNetworkTool postUrlString:ADD_POST body:dic response:XWJSON bodyStyle:XWRequestJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    sender.enabled = YES;
                    
                    NSLog(@"%@", responseObject);
                    if ([responseObject[@"status"] isEqualToNumber:@0]) {
                        [KVNProgress showSuccessWithStatus:@"发布成功"];
                        [self dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPost" object:nil];
                        }];
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    sender.enabled = YES;
                }];
            }
        } else {
            
            [KVNProgress showErrorWithStatus:@"内容不能为空哦"];
            
            NSLog(@"没有输入内容");
            sender.enabled = YES;
        }
    }
}

// 选取图片按钮方法
- (void)pickImageButtonAction:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    [AXGMessage showImageSelectMessageOnView:self.view leftImage:[UIImage imageNamed:@"弹出框_拍照"] rightImage:[UIImage imageNamed:@"弹出框_相册"]];
    AXGMessage *showView = [AXGMessage shareMessageView];
    WEAK_SELF;
    showView.leftButtonBlock = ^{
        STRONG_SELF;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    };
    showView.rightButtonBlock = ^{
        STRONG_SELF;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:NULL];
    };
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        STRONG_SELF;
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:picker animated:YES completion:NULL];
//    }];
//    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        STRONG_SELF;
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        [self presentViewController:picker animated:YES completion:NULL];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alert addAction:cameraAction];
//    [alert addAction:albumAction];
//    [alert addAction:cancelAction];
//    
//    [self presentViewController:alert animated:YES completion:^{
//        
//    }];
}

// 选取歌曲方法
- (void)pickSongButtonAction:(UIButton *)sender {
    
    SelectSongViewController *selecVC = [[SelectSongViewController alloc] init];
    WEAK_SELF;
    selecVC.songSelectBlock = ^ (SongModel *model) {
        STRONG_SELF;
        
        self.songModel = model;
        
        [self.pickSongImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_SONG_IMG, model.code]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        if (self.bottomImageView.hidden) {
            self.bottomSongView.frame = _frame1;
        } else {
            self.bottomSongView.frame = _frame2;
        }
        
        self.bottomSongView.hidden = NO;
        
    };
    
    [self presentViewController:selecVC animated:YES completion:^{
        
    }];
    
}

// 删除图片按钮方法
- (void)deleteImageButtonAction:(UIButton *)sender {
    self.avatar = nil;
    self.bottomImageView.hidden = YES;
    
    self.bottomSongView.frame = _frame1;
    
}

// 删除歌曲预览按钮方法
- (void)deleteSongButtonAction:(UIButton *)sender {
    self.pickSongImage.image = nil;
    self.songModel = nil;
    self.bottomSongView.hidden = YES;
    
    self.bottomImageView.frame = _frame1;
    
}

// 确定选择图片方法
- (void)confirmSelectImageAction:(UIButton *)sender {
    
}

#pragma mark - PickController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.avatar = info[UIImagePickerControllerOriginalImage];
    
    if (self.avatar.size.width > self.view.width) {
        
        UIImage *image = self.avatar;
        
        self.avatar = [self imageWithImage:image scaledToSize:CGSizeMake(self.view.width, self.view.width * (image.size.height / image.size.width))];
    }
    
    self.pickImage.image = self.avatar;
    
    // 处理完毕，回到个人信息页面
    WEAK_SELF;
    [picker dismissViewControllerAnimated:YES completion:^{
        STRONG_SELF;
        
        if (self.bottomSongView.hidden) {
            self.bottomImageView.frame = _frame1;
        } else {
            self.bottomImageView.frame = _frame2;
        }
        
        self.bottomImageView.hidden = NO;
    }];
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
//    if (textView.text.length > 140) {
//        NSLog(@"输入内容超过140");
//        textView.text = [textView.text substringWithRange:NSMakeRange(0, 140)];
//    }
    
//    self.txtNumberLabel.text = [NSString stringWithFormat:@"%ld/140", textView.text.length];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    self.placeHolderText.hidden = YES;
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (textView.text.length != 0) {
        self.placeHolderText.hidden = YES;
    } else {
        self.placeHolderText.hidden = NO;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        //在这里做你响应return键的代码
        [self.contentText resignFirstResponder];

    }
    return YES;
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
            
            self.toolView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
            
        }];
    }
}

//键盘出来的时候调整replyView的位置
- (void) keyChangeShow:(NSNotification *) notify {
    
    NSDictionary *dic = notify.userInfo;
    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if (keyboardRect.size.height >100) {
        WEAK_SELF;
        [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            STRONG_SELF;
            [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            
            self.toolView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
            
        }];
    }
}

//键盘出来的时候调整replyView的位置
-(void) keyChangeHide:(NSNotification *) notify {
    
    NSDictionary *dic = notify.userInfo;
    //    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    WEAK_SELF;
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        STRONG_SELF;
        [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        
        self.toolView.transform = CGAffineTransformIdentity;
        
    }completion:^(BOOL finished) {

    }];
}


//将图片缩放到指定尺寸
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
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
