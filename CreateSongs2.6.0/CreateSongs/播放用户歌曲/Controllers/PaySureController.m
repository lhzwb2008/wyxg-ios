//
//  PaySureController.m
//  CreateSongs
//
//  Created by axg on 16/8/16.
//  Copyright © 2016年 AXG. All rights reserved.
//

//wxb4ba3c02aa476ea1 测试用
//wxab1c2b71c7ff40c6 true
//com.loveSongs.loveCreateSongs

#import "PaySureController.h"
#import "TradeManager.h"
#import "AFNetworking.h"
#import "KVNProgress.h"
#import "AXGMessage.h"
#import "WXApi.h"
#import "KeychainItemWrapper.h"

@interface PaySureController ()

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UILabel *needPayLeft;
@property (nonatomic, strong) UILabel *needPayRight;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIImageView *flowerImageView;

/**
 *  内部查询订单号
 */
@property (nonatomic, copy) NSString *out_trade_no;

@end

@implementation PaySureController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationActive" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkWXOrderStatus) name:@"applicationActive" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navTitle.text = @"赞赏";
    
    [self initSubViews];
    
    [self createBottomBtn];
    
    self.priceLabel.text = @"0.1";
    
    [self adjustPriceLabelFrame];
    // Do any additional setup after loading the view.
}

- (void)checkWXOrderStatus {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    if (self.user_id.length > 0 && self.song_id.length > 0 && userId.length > 0) {
        
        NSString *url = [NSString stringWithFormat:WXPAY_CHECK_RESULT, self.user_id, self.song_id, self.out_trade_no, 1, userId];
        [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
           
        } success:^(NSURLSessionDataTask *task, id resposeObjects) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resposeObjects options:0 error:nil];
            NSLog(@"%@", dic);
            NSString *title = nil;
            if (!dic[@"trade_state"]) {
                title = @"交易已取消";
                [AXGMessage shareMessageView].line.hidden = NO;
                [AXGMessage shareMessageView].rightLabel.text = @"我已取消支付";
//                [AXGMessage shareMessageView].rightLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
                //ffdc74
                //441D11
//                [AXGMessage shareMessageView].rightLabel.backgroundColor = [UIColor colorWithHexString:@"ffdc74"];
                NSLog(@"已取消");
            } else {
                NSLog(@"%@", dic[@"trade_state"]);
                NSString *status = dic[@"trade_state"];

                if ([status isEqualToString:@"SUCCESS"]) {
                    title = @"交易成功";
                    [AXGMessage hide];
                    [self wxPaySuccess];
                    
                } else if ([status isEqualToString:@"CLOSED"]) {
                    title = @"交易关闭";
                    [AXGMessage shareMessageView].line.hidden = NO;
                    [AXGMessage shareMessageView].rightLabel.text = @"确定";
                } else if ([status isEqualToString:@"USERPAYING"]) {
                    if (self.checkWXPayNum > 10) {
                    } else {
                        [self checkWXOrderStatus];
                        self.checkWXPayNum++;
                    }
                } else if ([status isEqualToString:@"NOTPAY"]) {
                    title = @"未能支付";
                    [AXGMessage shareMessageView].line.hidden = NO;
                    [AXGMessage shareMessageView].rightLabel.text = @"确定";
//                    [AXGMessage shareMessageView].rightLabel.textColor = [UIColor colorWithHexString:@"#441D11"];
                    //ffdc74
                    //441D11
//                    [AXGMessage shareMessageView].rightLabel.backgroundColor = [UIColor colorWithHexString:@"ffdc74"];
                }
            }
            [AXGMessage shareMessageView].titleLabel.text = title;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [AXGMessage hide];
            [KVNProgress showErrorWithStatus:@"支付结果查询失败"];
        }];
    } else {
        [AXGMessage hide];
        [KVNProgress showErrorWithStatus:PAY_ERROR2];
    }
}

- (void)wxPaySuccess {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"wxPayResult"];
    [self.navigationController popViewControllerAnimated:YES];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //    });
}

- (void)wxPayFault {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wxPayResult"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubViews {
    UIImageView *imageView = [UIImageView new];
    imageView.frame = CGRectMake(0, self.navView.bottom + 55*HEIGHT_NIT, 375*HEIGHT_NIT, 274*HEIGHT_NIT);
    imageView.image = [UIImage imageNamed:@"playUser花"];
    [self.view addSubview:imageView];
    
    self.flowerImageView = imageView;
    
    CGSize leftSize = [@"" getWidth:@"需要支付:" andFont:[UIFont boldSystemFontOfSize:15]];
    
    self.needPayLeft = [UILabel new];
    self.needPayLeft.frame = CGRectMake(0, imageView.bottom + 75*HEIGHT_NIT, leftSize.width, leftSize.height);
    self.needPayLeft.centerX = self.view.width / 2 - leftSize.width / 2;
    self.needPayLeft.font = [UIFont boldSystemFontOfSize:15];
    self.needPayLeft.text = @"需要支付:";
    self.needPayLeft.textColor = [UIColor colorWithHexString:@"#441d11"];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.font = [UIFont boldSystemFontOfSize:18];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#df6d6d"];
    self.priceLabel.centerY = self.needPayLeft.centerY;
    
    
    self.needPayRight = [UILabel new];
    self.needPayRight.text = @"元";
    self.needPayRight.font = [UIFont boldSystemFontOfSize:15];
    self.needPayRight.textColor = [UIColor colorWithHexString:@"#441d11"];
    CGSize rightSize = [@"" getWidth:self.needPayRight.text andFont:self.needPayRight.font];
    self.needPayRight.frame = CGRectMake(0, 0, rightSize.width, rightSize.height);
    self.needPayRight.centerY = self.needPayLeft.centerY;
    
    [self.view addSubview:self.needPayLeft];
    [self.view addSubview:self.needPayRight];
    [self.view addSubview:self.priceLabel];
    
    [self adjustPriceLabelFrame];
}

- (void)adjustPriceLabelFrame {
    CGSize priceSize = [@"" getWidth:self.priceLabel.text andFont:self.priceLabel.font];
    
    self.priceLabel.frame = CGRectMake(self.needPayLeft.right + 6, 0, priceSize.width, priceSize.height);
    self.priceLabel.centerY = self.needPayLeft.centerY;
    CGRect rightFrame = self.needPayRight.frame;
    rightFrame.origin.x = self.priceLabel.right + 5;
    self.needPayRight.frame = rightFrame;
}

- (void)createBottomBtn {
    UIButton *createButton = [UIButton new];
    [self.view addSubview:createButton];
    createButton.frame = CGRectMake(0, 0, 250 * WIDTH_NIT, 50 * WIDTH_NIT);
    //    createButton.backgroundColor = HexStringColor(@"#879999");
    [createButton setTitle:@"微信支付" forState:UIControlStateNormal];
    [createButton setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [createButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    [createButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [createButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
    createButton.titleLabel.font = JIACU_FONT(18);
    createButton.layer.cornerRadius = createButton.height / 2;
    createButton.layer.masksToBounds = YES;
    createButton.center = CGPointMake(self.view.width / 2, self.view.height - 35 * HEIGHT_NIT - 25 * WIDTH_NIT);
    [createButton addTarget:self action:@selector(buyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (![WXApi isWXAppInstalled]) {
        createButton.enabled = NO;
    } else {
        createButton.enabled = YES;
    }
}

- (void)buyBtnAction:(UIButton *)btn {
    self.checkWXPayNum = 0;
    //https://123.59.134.79/core/home/pay/sendOrder?description=@"这是一件测试商品"&price=0.1
    btn.enabled = NO;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:WXPAY_ORDER, @"一朵鲜花", (NSInteger)([self.priceLabel.text floatValue] * 100)] body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id resposeObjects) {
        btn.enabled = YES;
        if (resposeObjects) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resposeObjects options:0 error:nil];
            NSLog(@"%@", dic);
            WXOrder *order = [WXOrder new];
            order.partnerId = dic[@"partnerid"];
            order.prepayId = dic[@"prepayid"];
            order.nonceStr = dic[@"noncestr"];
            order.timeStamp = (UInt32)[dic[@"timestamp"] longLongValue];
            order.package = dic[@"package"];
            order.sign = dic[@"sign"];
            self.out_trade_no = dic[@"out_trade_no"];
            [TradeManager payByWEchatWithOrder:order];
            
            [AXGMessage showPayResultMessageOnView:self.view title:@"交易结果查询中" leftButton:@"" rightButton:@""];
            
            [AXGMessage shareMessageView].line.hidden = YES;
        } else {
            NSLog(@"没有请求到数据");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        btn.enabled = YES;
        [KVNProgress showErrorWithStatus:PAY_ERROR1];
        NSLog(@"%@", error.description);
    }];
//
//    [self wxPaySuccess];
//    [self drawOutFlower];
}


- (void)drawOutFlower {
    
    CGPoint center = self.flowerImageView.center;
    
    CGFloat time = 0.5;
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = time;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    CGPathAddQuadCurveToPoint(path, NULL, 150, 30, 0, 0);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAKeyframeAnimation *keyAnima = [CAKeyframeAnimation animation];
    keyAnima.keyPath = @"transform";
    keyAnima.values = @[@1, @0];
    keyAnima.removedOnCompletion = NO;
    keyAnima.fillMode = kCAFillModeForwards;
    keyAnima.duration = time;
    keyAnima.repeatCount = 1;
    
    CAAnimationGroup *animatiGroup = [CAAnimationGroup animation];
    animatiGroup.animations = [NSArray arrayWithObjects:positionAnimation, keyAnima, nil];
    animatiGroup.duration = time;
    animatiGroup.fillMode = kCAFillModeForwards;
    animatiGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.flowerImageView.layer addAnimation:animatiGroup forKey:@"Expand"];
    
    self.flowerImageView.center = CGPointMake(0, 0);
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
