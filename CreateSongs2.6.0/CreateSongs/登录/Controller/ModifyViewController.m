//
//  ModifyViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ModifyViewController.h"
#import "PersonInfoView.h"
#import "KVNProgress.h"
#import "AFHTTPSessionManager.h"
#import "UserModel.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "AXGMessage.h"
#import "NSString+Emojize.h"
//#import "UIViewController+MMDrawerController.h"
#import "CreateSongs-Swift.h"
//#import "KYDrawerController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>

@interface ModifyViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, PersonViewDelegate>

@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, strong) UIImage *avatar;

@property (nonatomic, strong) UIView *editView;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIImageView *preImageView;

@property (nonatomic, strong) UIView *navMaskView;

// 记录缩放大小
@property (nonatomic, assign) CGFloat lastScale;

// 记录旋转角度
@property (nonatomic, assign) CGFloat lastRotation;

// 记录X坐标
@property (nonatomic, assign) CGFloat firstX;

// 记录Y坐标
@property (nonatomic, assign) CGFloat firstY;

@property (nonatomic, assign) CGAffineTransform transform;

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self createPersonInfo];
    
    [self.view bringSubviewToFront:self.navView];
    
    [self createEditView];
    [self getData];
    [self createEdgePanView];
    
    [self reloadMsg];
    
//    if (self.fromDrawer) {
//        self.navLeftImage.image = [UIImage imageNamed:@"菜单icon"];
//    } else {
//        self.navLeftImage.image = [UIImage imageNamed:@"返回"];
//    }
    
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    
    if (self.fromDrawer) {
//        self.navLeftImage.image = [UIImage imageNamed:@"菜单icon"];
        [self.navLeftButton setImage:[UIImage imageNamed:@"菜单icon"] forState:UIControlStateNormal];
        [self.navLeftButton setImage:[UIImage imageNamed:@"菜单_高亮"] forState:UIControlStateHighlighted];
    } else {
//        self.navLeftImage.image = [UIImage imageNamed:@"返回"];
        [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [self.navRightButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    }
    
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    self.navTitle.text = @"修改资料";
    
    [self.navRightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.navRightButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateNormal];
    self.navRightButton.titleLabel.font = ZHONGDENG_FONT(15);
    
//    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 100 * WIDTH_NIT - 16, 0, 100 * WIDTH_NIT, 30)];
//    rightLabel.center =CGPointMake(rightLabel.centerX, self.navTitle.centerY);
//    [self.navView addSubview:rightLabel];
//    rightLabel.text = @"保存";
//    rightLabel.textColor = [UIColor whiteColor];
//    rightLabel.font = ZHONGDENG_FONT(15);
//    rightLabel.textAlignment = NSTextAlignmentRight;
    
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navRightButton addTarget:self action:@selector(saveAciton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navMaskView = [[UIView alloc] initWithFrame:self.navView.bounds];
    [self.navView addSubview:self.navMaskView];
    self.navMaskView.backgroundColor = [UIColor blackColor];
    self.navMaskView.alpha = 0.5;
    self.navMaskView.hidden = YES;
    
}

// 创建打开手势界面
- (void)createEdgePanView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 20, self.view.height - 64)];
    //    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanAction)];
    edgePan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:edgePan];
}

// 创建个人信息界面
- (void)createPersonInfo {
    self.personInfoView = [[PersonInfoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.personInfoView];
    self.personInfoView.delegate = self;
    
    WEAK_SELF;
    self.personInfoView.showMaskBlock = ^ () {
        STRONG_SELF;
        self.navMaskView.hidden = NO;
    };
    self.personInfoView.hideMaskBlock = ^ () {
        STRONG_SELF;
        self.navMaskView.hidden = YES;
    };
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

#pragma mark - Action

// 刷新站内信数据
- (void)reloadMsg {
    
//    NSMutableArray *mutaArr = [[NSMutableArray alloc] initWithCapacity:0];
//
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
//
//        //     获取用户id
//        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
//        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
//
//        WEAK_SELF;
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_MESSAGE, userId] body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
//            STRONG_SELF;
//            if ([dic1[@"status"] isEqualToNumber:@0]) {
//                NSArray *array = dic1[@"items"];
//
//                for (NSDictionary *dic in array) {
//                    if ([dic[@"is_read"] isEqualToString:@"1"]) {
//
//                    } else {
//                        [mutaArr addObject:dic];
//                    }
//                }
//
//                if (mutaArr.count != 0) {
//                    self.msgView.hidden = NO;
//                } else {
//                    self.msgView.hidden = YES;
//                }
//
//            } else {
//                self.msgView.hidden = YES;
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            self.msgView.hidden = YES;
//        }];
//    } else {
        self.msgView.hidden = YES;
//    }
    
}

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    
    if (self.fromDrawer) {
        [self presentDrawer];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 手势打开抽屉
- (void)edgePanAction {
    [self presentDrawer];
}

- (void)presentDrawer {
    
    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;
    
    [drawerVC setDrawerState:DrawerStateOpened animated:YES];
    
//    [self.mm_drawerController
//     openDrawerSide:MMDrawerSideLeft
//     animated:YES
//     completion:^(BOOL finished) {
//         
//     }];
}

// 保存按钮方法
- (void)saveAciton {
    if (self.avatar && self.personInfoView.nickName.text.length != 0 && self.personInfoView.gender.text.length != 0) {
        [self uploadImage];
    } else {
        //        [MBProgressHUD showError:@"请先完善资料"];
        [KVNProgress showErrorWithStatus:@"请先完善资料"];
    }
}

// 获取用户信息
- (void)getData {
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSDictionary *dic = resposeObject;
            self.userModel = [[UserModel alloc] initWithDictionary:dic error:nil];
            
            NSString *url = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:self.userModel.phone]];
            
            self.avatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            self.personInfoView.headImage.image = self.avatar;
            self.personInfoView.nickName.text = self.userModel.name;
            if ([self.userModel.gender isEqualToString:@"1"]) {
                self.personInfoView.gender.text = @"男";
            } else {
                self.personInfoView.gender.text = @"女";
            }
            self.personInfoView.birthTextField.text = self.userModel.birthday;
            self.personInfoView.signitureText.text = self.userModel.signature;
            self.personInfoView.weiboText.text = self.userModel.weibo;
            self.personInfoView.QQText.text = self.userModel.qq;
            self.personInfoView.weChatText.text = self.userModel.wechat;
            self.personInfoView.locationText.text = self.userModel.location;
            self.personInfoView.schoolOrCompanyText.text = self.userModel.school_company;
            
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
    
    if (self.avatar) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSData *data = UIImagePNGRepresentation(self.avatar);
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", [XWAFNetworkTool md5HexDigest:self.userModel.phone]];
        
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
    
    NSString *fileName = [NSString stringWithFormat:@"%@.png", [XWAFNetworkTool md5HexDigest:self.userModel.phone]];
    NSString *gender = @"";
    if ([self.personInfoView.gender.text isEqualToString:@"男"]) {
        gender = @"1";
    } else {
        gender = @"0";
    }
    
    // 修改
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:UPDATE_USER_URL, self.userModel.phone, self.personInfoView.nickName.text, gender, self.personInfoView.birthTextField.text, self.personInfoView.signitureText.text, self.personInfoView.weiboText.text, self.personInfoView.QQText.text, self.personInfoView.weChatText.text, self.personInfoView.locationText.text, self.personInfoView.schoolOrCompanyText.text] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
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
    
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:UPDATE_USER_URL, self.userModel.phone, [self.personInfoView.nickName.text preEmojizedString], gender, self.personInfoView.birthTextField.text, [self.personInfoView.signitureText.text preEmojizedString], [self.personInfoView.weiboText.text preEmojizedString], [self.personInfoView.QQText.text preEmojizedString], [self.personInfoView.weChatText.text preEmojizedString], self.personInfoView.locationText.text, [self.personInfoView.schoolOrCompanyText.text preEmojizedString]] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
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
    if (self.fromDrawer) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backToPerson" object:nil];
    } else {
        [self backButtonAction:nil];
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

//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    [self presentViewController:picker animated:YES completion:NULL];
    
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
    
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
//        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//        [actionSheet showInView:self.view];
}

// sheetview
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    
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
