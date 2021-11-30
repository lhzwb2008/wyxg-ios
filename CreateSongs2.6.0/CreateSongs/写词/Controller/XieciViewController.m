//
//  XieciViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/20.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "XieciViewController.h"

#import "FormatPickView.h"
#import "HECollecPicker.h"
#import "CreateSongs-Swift.h"
#import "PlayViewController.h"
#import "StyleViewController.h"
#import "AppDelegate.h"
#import "AXGMediator+MediatorModuleAActions.h"

//#import "CreateSongs-Bridging-Header.h"

@interface XieciViewController ()

@property (nonatomic, strong) lyricFormatManager *lyricManager;

@property (nonatomic, strong) HECollecPicker *formatPickView;

@property (nonatomic, assign) BOOL willPopAlert;

@property (nonatomic, strong) NSMutableArray *lastLyricArr;

@end

@implementation XieciViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LYricFormatSeletView *seletView;
    
    [self changeSongToEmpty];

    self.willPopAlert = YES;
    
    self.lastLyricArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initNavView];
    
    [self createLyricView];
    [self createLyricPickView];
    [self createBottomButton];
    
    [self.view bringSubviewToFront:self.navView];
    // 初始化草稿箱过来的数据
    [self reloadXieciFromDrafts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)changeSongToEmpty {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.lyricWriter = @"";
    app.songWriter = @"";
    app.songSinger = @"";
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    self.navTitle.text = @"写词";
    
//    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 100 * WIDTH_NIT - 16, 0, 100 * WIDTH_NIT, 30)];
//    rightLabel.center =CGPointMake(rightLabel.centerX, self.navTitle.centerY);
//    [self.navView addSubview:rightLabel];
//    rightLabel.text = @"保存";
//    rightLabel.textColor = [UIColor whiteColor];
//    rightLabel.font = ZHONGDENG_FONT(15);
//    rightLabel.textAlignment = NSTextAlignmentRight;
    
    [self.navRightButton setTitle:@"保存" forState:UIControlStateNormal];
//    [self.navRightButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateNormal];
//    self.navRightButton.titleLabel.font = ZHONGDENG_FONT(15);
    
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navRightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}


// 创建选择歌词界面
- (void)createLyricPickView {
    CGFloat navH = kDevice_Is_iPhoneX ? 88 : 64;
    self.formatPickView = [[HECollecPicker alloc] initWithFrame:CGRectMake(0, navH, self.view.width, 45 * HEIGHT_NIT)];
    [self.view addSubview:self.formatPickView];
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LyricFormat" ofType:@"plist"];
    
    NSDictionary *lyricDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    NSString *mapPath = [[NSBundle mainBundle] pathForResource:@"LyricFormatMap" ofType:@"plist"];
    NSDictionary *mapDic = [NSDictionary dictionaryWithContentsOfFile:mapPath];
    
    
    NSArray *tucaoArray = lyricDic[@"tucao"];
    NSArray *zhufuArray = lyricDic[@"zhufu"];
    NSArray *weimeiArray = lyricDic[@"wenyi"];
    NSArray *biaobaiArray = lyricDic[@"biaobai"];
    
    
    NSMutableArray *firstArray = [NSMutableArray array];
    NSMutableArray *secondArray = [NSMutableArray array];
    NSMutableArray *thirdArray = [NSMutableArray array];
    NSMutableArray *fourthArray = [NSMutableArray array];
    NSMutableArray *finalArray = [NSMutableArray array];
    NSMutableArray *otherArray = [NSMutableArray array];
    
    NSInteger i1 = 1;
    NSInteger i2 = 1;
    NSInteger i3 = 1;
    NSInteger i4 = 1;
    NSInteger i5 = 1;
    for (NSDictionary *dic in biaobaiArray) {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([dic[@"type"] isEqualToString:@"1"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"爱情", [NSString stringWithFormat:@"%ld", i1++]] forKey:@"title"];
            [firstArray addObject:tmpDic];
        } else if ([dic[@"type"] isEqualToString:@"2"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"思念", [NSString stringWithFormat:@"%ld", i2++]] forKey:@"title"];
            [secondArray addObject:tmpDic];
        } else if ([dic[@"type"] isEqualToString:@"3"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"爱古", [NSString stringWithFormat:@"%ld", i3++]] forKey:@"title"];
            [thirdArray addObject:tmpDic];
        } else if ([dic[@"type"] isEqualToString:@"4"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"表白", [NSString stringWithFormat:@"%ld", i4++]] forKey:@"title"];
            [fourthArray addObject:tmpDic];
        } else {
            [otherArray addObject:tmpDic];
        }
    }
    [finalArray addObjectsFromArray:firstArray];
    [finalArray addObjectsFromArray:secondArray];
    [finalArray addObjectsFromArray:thirdArray];
    [finalArray addObjectsFromArray:fourthArray];
    [finalArray addObjectsFromArray:otherArray];
    biaobaiArray = [finalArray copy];
    
    [firstArray removeAllObjects];
    [secondArray removeAllObjects];
    [thirdArray removeAllObjects];
    [fourthArray removeAllObjects];
    [otherArray removeAllObjects];
    [finalArray removeAllObjects];
    i1 = 1;
    i2 = 1;
    i3 = 1;
    i4 = 1;
    i5 = 1;
    for (NSDictionary *dic in tucaoArray) {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([dic[@"type"] isEqualToString:@"1"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"吐槽学习", [NSString stringWithFormat:@"%ld", i1++]] forKey:@"title"];
            [firstArray addObject:tmpDic];
        } else if ([dic[@"type"] isEqualToString:@"2"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"吐槽面试", [NSString stringWithFormat:@"%ld", i2++]] forKey:@"title"];
            [secondArray addObject:tmpDic];
        } else if ([dic[@"type"] isEqualToString:@"3"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"吐槽生活", [NSString stringWithFormat:@"%ld", i3++]] forKey:@"title"];
            [thirdArray addObject:tmpDic];
        } else {
            [otherArray addObject:tmpDic];
        }
    }
    [finalArray addObjectsFromArray:firstArray];
    [finalArray addObjectsFromArray:secondArray];
    [finalArray addObjectsFromArray:thirdArray];
    [finalArray addObjectsFromArray:fourthArray];
    [finalArray addObjectsFromArray:otherArray];
    tucaoArray = [finalArray copy];
    
    [firstArray removeAllObjects];
    [secondArray removeAllObjects];
    [thirdArray removeAllObjects];
    [fourthArray removeAllObjects];
    [otherArray removeAllObjects];
    [finalArray removeAllObjects];
    i1 = 1;
    i2 = 1;
    i3 = 1;
    i4 = 1;
    i5 = 1;
    for (NSDictionary *dic in zhufuArray) {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([dic[@"type"] isEqualToString:@"1"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"母亲节", [NSString stringWithFormat:@"%ld", i1++]] forKey:@"title"];
            [firstArray addObject:tmpDic];
        } else if ([dic[@"type"] isEqualToString:@"2"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"爱情", [NSString stringWithFormat:@"%ld", i2++]] forKey:@"title"];
            [secondArray addObject:tmpDic];
        } else if ([dic[@"type"] isEqualToString:@"3"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"学业", [NSString stringWithFormat:@"%ld", i3++]] forKey:@"title"];
            [thirdArray addObject:tmpDic];
        } else if ([dic[@"type"] isEqualToString:@"4"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"问候", [NSString stringWithFormat:@"%ld", i4++]] forKey:@"title"];
            [fourthArray addObject:tmpDic];
        } else if ([dic[@"type"] isEqualToString:@"5"]) {
            [tmpDic setValue:[NSString stringWithFormat:@"%@%@", @"亲情", [NSString stringWithFormat:@"%ld", i5++]] forKey:@"title"];
            [fourthArray addObject:tmpDic];
        } else {
            [otherArray addObject:tmpDic];
        }
    }
    [finalArray addObjectsFromArray:firstArray];
    [finalArray addObjectsFromArray:secondArray];
    [finalArray addObjectsFromArray:thirdArray];
    [finalArray addObjectsFromArray:fourthArray];
    [finalArray addObjectsFromArray:otherArray];
    zhufuArray = [finalArray copy];
    
    self.lyricManager = [[lyricFormatManager alloc] initWithControllerView:self selectFrame:CGRectMake(0, self.formatPickView.bottom, self.view.width, self.view.height - self.navView.bottom) tucaoArray:tucaoArray zhufuArray:zhufuArray weimeiArray:weimeiArray biaobaiArray:finalArray];
    
    WEAK_SELF;
    self.formatPickView.selectedFormatBlock = ^(NSInteger index) {
        STRONG_SELF;
        [self.lyricManager didSelected:index];
    };
    self.formatPickView.appearSelectFormat = ^(NSInteger index) {
        STRONG_SELF;
        NSInteger lyricIndex = 0;
        NSArray *itemArray = nil;
        if (index > 0 && index < 5) {
            switch (index) {
                case 1: {
                    itemArray = self.lyricManager.tucaoArray;
                }
                    break;
                case 2: {
                    itemArray = self.lyricManager.zhufuArray;
                }
                    break;
                case 3: {
                    itemArray = self.lyricManager.weimeiArray;
                }
                    break;
                case 4: {
                    itemArray = self.lyricManager.biaobaiArray;
                }
                    break;
                default:
                    break;
            }
            
            if (itemArray.count > 0) {
                lyricIndex = arc4random() % itemArray.count;
                NSDictionary *dic = [[itemArray objectAtIndex:lyricIndex] mutableCopy];
                NSArray *array = [dic[@"lyric"] componentsSeparatedByString:@","];
                if ([dic[@"title"] isEqualToString:@""]) {
                    [dic setValue:array[0] forKey:@"title"];
                }
                [dic setValue:array forKey:@"lyric"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedLyricFormat" object:dic];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedBlack" object:nil];
            }
        }
    };
    
}

// 创建歌词界面
- (void)createLyricView {
    CGFloat navH = kDevice_Is_iPhoneX ? 88 : 64;
    self.songs = [[CreateSongs alloc] initWithFrame:CGRectMake(0, navH + 45 * HEIGHT_NIT, self.view.width, self.view.height - self.navView.height - 45 * HEIGHT_NIT - (50 * WIDTH_NIT))];
    [self.view addSubview:self.songs];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.songs.bottom, self.view.width, 0.5)];
//    [self.view addSubview:lineView];
//    lineView.backgroundColor = HexStringColor(@"#eeeeee");
    
}

// 下一步按钮
- (void)createBottomButton {
    UIButton *nextButton = [UIButton new];
    nextButton.frame = CGRectMake(0, self.view.height - 50 * WIDTH_NIT, self.view.width, 50 * WIDTH_NIT);
    nextButton.center = CGPointMake(self.view.width / 2, nextButton.centerY);
    [self.view addSubview:nextButton];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [nextButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
//    nextButton.backgroundColor = HexStringColor(@"#879999");
    
    nextButton.titleLabel.font = JIACU_FONT(18);
//    nextButton.layer.cornerRadius = nextButton.height / 2;
//    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - Action
// 下一步按钮方法
- (void)nextButtonAction:(UIButton *)sender {
    
    // 写词界面_提交
    [MobClick event:@"xiege_submit"];
    
    [self getSongNameAndContent];
    PlayViewController *pvc = [PlayViewController sharePlayVC];
    pvc.titleStr = self.songName;
    pvc.titleLabel.text = self.songName;
    pvc.navTitleLabel.text = self.songName;
    pvc.lyricContent = self.songContent;
    pvc.requestURL = [NSString stringWithFormat:CREATE_URL_ALL, self.songName, self.songContent];
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSString *lyric in self.lastLyricArr) {
        NSString *str = [lyric stringByReplacingOccurrencesOfString:@"-" withString:@"～"];
        [tmpArray addObject:str];
    }
    [pvc.lyricDataSource removeAllObjects];
    
    
    
    [pvc.lyricDataSource addObjectsFromArray:tmpArray];
    StyleViewController *styleVC = [[StyleViewController alloc] init];
    [self.navigationController pushViewController:styleVC animated:YES];
}

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    
    if (self.willPopAlert) {
        WEAK_SELF;
        [AXGMediator AXGMediator_showAlertWithMessage:@{@"title":@"是否放弃当前歌词",
                                                                         @"leftTitle":@"继续",
                                                                         @"rightTitle":@"放弃"} cancelAction:^(NSDictionary *info) {
            
        } confirmAction:^(NSDictionary *info) {
            STRONG_SELF;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)getSongNameAndContent {
    NSString *content = @"";
    NSString *songName = @"";
    
    NSString *lrcNow = self.songs.titleText.textField.text;
    
    for (InputTextView *textView in _songs.inputViewArray) {
        UITextField *tf = textView.textField;
        lrcNow = [lrcNow stringByAppendingString:tf.text];
    }
    if (lrcNow.length != 0) {
        // 添加改变歌词的统计事件
        [MobClick event:@"xiege_lyric_changed"];
    } else {
        
    }
    
    [self.lastLyricArr removeAllObjects];
    
    for (int i = 0; i < self.songs.lyricNumber; i++) {
        
        NSString *lrc = self.songs.lyTextfArr[i];
        
        if ([lrc isEqualToString:@"x"]) {
            self.lastLyricArr[i] = self.songs.placeHolderTextArr[i];
        } else {
            self.lastLyricArr[i] = self.songs.lyTextfArr[i];
        }
        content = [content stringByAppendingString:self.lastLyricArr[i]];
        
        if (i != self.songs.lyricNumber - 1) {
            content = [content stringByAppendingString:@","];
        }
    }
    
    if (self.songs.titleText.textField.text.length == 0) {
        songName = @"请输入歌名";
    } else {
        songName = self.songs.titleText.textField.text;
    }
    
    // 处理掉歌词中英文的漏网之鱼
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]" options:0 error:nil];
    content = [regularExpression stringByReplacingMatchesInString:content options:0 range:NSMakeRange(0, content.length) withTemplate:@""];
    
    self.songName = songName;
    self.songContent = content;
}

// 右边按钮方法
- (void)rightButtonAction:(UIButton *)sender {
    
    sender.enabled = NO;
    self.willPopAlert = NO;
    
    [self getSongNameAndContent];
    
    NSString *saveTime = [self getCurrentTime];
    
    NSLog(@"savetime %@", saveTime);
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
    [store createTableWithName:TABLE_NAME];
    [store putObject:@{@"title":self.songName, @"content":self.songContent, @"saveTime":saveTime, @"line":[NSNumber numberWithInteger:self.songs.lyricNumber]} withId:saveTime intoTable:TABLE_NAME];
    
//    [KVNProgress showSuccessWithStatus:@"已保存至草稿箱"];
    [AXGMessage showImageToastOnView:self.view image:[UIImage imageNamed:@"弹出框_保存草稿"] type:1];
    
    // 2s后按钮恢复点击
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
}

// 获取当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *dataTime = [formatter stringFromDate:[NSDate date]];
    return dataTime;
}

// 刷新从草稿箱进来的数据
- (void)reloadXieciFromDrafts {
    if (self.lineFromDrafts >= 2) {
        
        self.songs.lyricNumber = self.lineFromDrafts;
        
        self.songs.titleText.textField.text = self.titleFromDrafts;
        
        NSArray *array = [self.contentFromDrafts componentsSeparatedByString:@","];
        for (int i = 0; i < self.lineFromDrafts; i++) {
            self.songs.lyTextfArr[i] = array[i];
        }

        [self.songs.tableView reloadData];
        
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
