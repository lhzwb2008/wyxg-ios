//
//  TianciViewController.m
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TianciViewController.h"
//#import "MidiParserManager.h"
#import "TianciMainView.h"
#import "TianciTextView.h"
#import "TianciLyricModel.h"
#import "TianciDBFile.h"
#import "NSObject+ModelToDictionary.h"
#import "NSDictionary+Common.h"
#import "XianQuShiTingViewController.h"
#import "PlayShareObjects.h"
#import "AppDelegate.h"



#define ZOUYIN_URL  @"https://service.woyaoxiege.com/core/home/index/zouyin?title=%@&content=%@&yuanqu=%@"

@interface TianciViewController ()

@property (nonatomic, strong) UILabel *topTipView;

//@property (nonatomic, strong) MidiParserManager *parserManager;

@property (nonatomic, strong) TianciMainView *tianCiMainView;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, assign) BOOL willPopAlert;
/**
 *  存放LyricModel模型的数组，模型里边包括歌词对应的下标和歌词 (存放草稿箱方便)
 */
@property (nonatomic, strong) NSMutableArray *finalLyricModelArray;

@property (nonatomic, strong) NSMutableArray *finalLyricArray;

@property (nonatomic, copy) NSString *tianciName;
@property (nonatomic, copy) NSString *tianciContent;

@end

@implementation TianciViewController
#pragma mark - 初始化界面

//- (MidiParserManager *)parserManager {
//    if (_parserManager == nil) {
//        _parserManager = [MidiParserManager new];
//    }
//    return _parserManager;
//}

- (NSMutableArray *)finalLyricModelArray {
    if (_finalLyricModelArray == nil) {
        _finalLyricModelArray = [NSMutableArray array];
    }
    return _finalLyricModelArray;
}

- (NSMutableArray *)finalLyricArray {
    if (_finalLyricArray == nil) {
        _finalLyricArray = [NSMutableArray array];
    }
    return _finalLyricArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.willPopAlert = YES;
}

- (void)changeSongToEmpty {
    // 这里不继承
}

// 下一步按钮
- (void)createBottomButton {
    UIButton *nextButton = [UIButton new];
    nextButton.frame = CGRectMake(0, self.view.height - 50 * WIDTH_NIT, self.view.width, 50 * WIDTH_NIT);
    nextButton.center = CGPointMake(self.view.width / 2, nextButton.centerY);
    [self.view addSubview:nextButton];
    [nextButton setTitle:@"制作歌曲" forState:UIControlStateNormal];
//    nextButton.backgroundColor = HexStringColor(@"#879999");
//    [nextButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"]];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
    [nextButton setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [nextButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    nextButton.titleLabel.font = JIACU_FONT(18);
//    nextButton.layer.cornerRadius = nextButton.height / 2;
//    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomBtn = nextButton;
//    self.bottomBtn.enabled = NO;
    
    [self changeNextBtnState:NO];
}


- (void)initNavView {
    [super initNavView];
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    self.navTitle.text = @"填词";
    
//    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 100 * WIDTH_NIT - 16, 0, 100 * WIDTH_NIT, 30)];
//    rightLabel.center =CGPointMake(rightLabel.centerX, self.navTitle.centerY);
//    [self.navView addSubview:rightLabel];
//    rightLabel.text = @"保存";
//    rightLabel.textColor = [UIColor whiteColor];
//    rightLabel.font = ZHONGDENG_FONT(15);
//    rightLabel.textAlignment = NSTextAlignmentRight;
    
    [self.navRightButton setTitle:@"保存" forState:UIControlStateNormal];
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navRightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    if (self.willPopAlert) {
        [AXGMessage showTextSelectMessageOnView:self.view title:@"是否放弃已填歌词" leftButton:@"继续" rightButton:@"放弃"];
        WEAK_SELF;
        [AXGMessage shareMessageView].leftButtonBlock = ^ () {
        };
        [AXGMessage shareMessageView].rightButtonBlock = ^ () {
            STRONG_SELF;
            [self.navigationController popViewControllerAnimated:YES];
        };
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
// 创建选择歌词界面
- (void)createLyricPickView {
    self.topTipView = [UILabel new];
    self.topTipView.frame = CGRectMake(0, 64, self.view.width, 25*HEIGHT_NIT);
    self.topTipView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.topTipView.textColor = [UIColor colorWithHexString:@"A0A0A0"];
    self.topTipView.font = NORML_FONT(15*WIDTH_NIT);
    self.topTipView.textAlignment = NSTextAlignmentCenter;
    [self setNumberOfTopView:0 andTotalNumber:13];
    [self.view addSubview:self.topTipView];
}

- (void)setLyricModelArray:(NSArray *)lyricModelArray {
    _lyricModelArray = lyricModelArray;
    [self.finalLyricModelArray removeAllObjects];
    [self.finalLyricModelArray addObjectsFromArray:_lyricModelArray];
}

- (void)setNumberOfTopView:(NSInteger)doneNum andTotalNumber:(NSInteger)totalNum {
    self.topTipView.text = [NSString stringWithFormat:@"已创作%ld/%ld句歌词", doneNum, totalNum];
}

// 创建歌词界面
- (void)createLyricView {
    self.tianCiMainView = [[TianciMainView alloc] initWithFrame:CGRectMake(0, 64 + 25 * HEIGHT_NIT, self.view.width, self.view.height - self.navView.height - 25 * HEIGHT_NIT - 50 * WIDTH_NIT)];
    self.tianCiMainView.backgroundColor = [UIColor clearColor];
    WEAK_SELF;
    self.tianCiMainView.lyTextArray = self.lyricFormatArray;
    self.tianCiMainView.lyricModelArray = self.lyricModelArray;
    
    self.tianCiMainView.tianciShouldDone = ^(BOOL shouldDone){
        STRONG_SELF;
        [self changeNextBtnState:shouldDone];
    };
    [self.view addSubview:self.tianCiMainView];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tianCiMainView.bottom, self.view.width, 0.5)];
//    [self.view addSubview:lineView];
//    lineView.backgroundColor = HexStringColor(@"#eeeeee");
}

- (void)changeNextBtnState:(BOOL)shouldDone {
//    if (shouldDone) {
//        self.bottomBtn.enabled = YES;
//        self.bottomBtn.layer.borderColor = self.bottomBtn.backgroundColor.CGColor;
//        self.bottomBtn.layer.borderWidth = 0;
//        [self.bottomBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"]];
//    } else {
//        self.bottomBtn.enabled = NO;
//        self.bottomBtn.layer.borderColor = self.bottomBtn.backgroundColor.CGColor;
//        self.bottomBtn.layer.borderWidth = 0.5;
//        [self.bottomBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"]];
//    }
    [self setNumberOfTopView:self.tianCiMainView.fullLyricCount andTotalNumber:self.tianCiMainView.lyTextArray.count];
}

- (NSMutableDictionary *)lyricDic {
    if (_lyricDic == nil) {
        _lyricDic = [NSMutableDictionary dictionary];
    }
    return _lyricDic;
}

- (void)getLyricArray {
    [self.finalLyricArray removeAllObjects];
    [self.finalLyricModelArray removeAllObjects];
    NSString *content = @"";
    NSInteger i = 0;
    for (TianciTextView *textView in self.tianCiMainView.inputTextViewArray) {
        if (textView.textField.text.length > 0) {
            TianciLyricModel *model = [TianciLyricModel new];
            model.lyric = textView.textField.text;
            [self.lyricDic setObject:model.lyric forKey:[NSString stringWithFormat:@"%ld", (long)i]];
            
            if (i > 0) {
                content = [content stringByAppendingString:@","];
            }
            content = [content stringByAppendingString:model.lyric];
            
            model.index = textView.index;

            [self.finalLyricModelArray addObject:model];
        }
        i++;
    }
    NSInteger j = 0;
    for (NSString *formatLyric in self.lyricFormatArray) {
        NSString *keyStr = [NSString stringWithFormat:@"%ld", j];
        if ([self.lyricDic haveKey:keyStr]) {
            NSString *valueStr = self.lyricDic[keyStr];
            if (valueStr.length < formatLyric.length) {
                NSMutableString *finalStr = [[NSMutableString alloc] initWithString:formatLyric];
                NSRange range = NSMakeRange(0, valueStr.length);
                NSString *lyric1 = [[finalStr stringByReplacingCharactersInRange:range withString:valueStr] copy];
                [self.finalLyricArray addObject:lyric1];
            } else {
                [self.finalLyricArray addObject:valueStr];
            }
        } else {
            [self.finalLyricArray addObject:self.lyricFormatArray[j]];
        }
        j++;
    }
    
    if (self.tianCiMainView.titleText.textField.text.length > 0) {
        self.tianciName = self.tianCiMainView.titleText.textField.text;
    } else {
        self.tianciName = @"请输入歌名";
    }
    self.tianciContent = content;
}


// 右边按钮方法
- (void)rightButtonAction:(UIButton *)sender {
    
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    sender.enabled = NO;
    self.willPopAlert = NO;
    
    [self getLyricArray];
    
    NSString *saveTime = [self getCurrentTime];
    
    
    if (self.xuanQuModel) {
        [TianciDBFile setObject:self.xuanQuModel.midiData forKey:MD5Hash([NSString stringWithFormat:@"%@%@", @"tianciMidiData", saveTime])];
    } else {
        [TianciDBFile setObject:nil forKey:MD5Hash([NSString stringWithFormat:@"%@%@", @"tianciMidiData", saveTime])];
    }
    
    
    
    NSData *lyricDicData = [NSJSONSerialization dataWithJSONObject:self.lyricDic options:0 error:nil];
    [TianciDBFile setObject:lyricDicData forKey:MD5Hash([NSString stringWithFormat:@"%@%@", @"lyricDic", saveTime])];
    
    
    NSData *lyricFormatData = [NSKeyedArchiver archivedDataWithRootObject:self.lyricFormatArray];
    [TianciDBFile setObject:lyricFormatData forKey:MD5Hash([NSString stringWithFormat:@"%@%@", @"lyricFormat", saveTime])];
    
    
    NSData *locationsData = [NSKeyedArchiver archivedDataWithRootObject:self.characLocationsArray];
    [TianciDBFile setObject:locationsData forKey:MD5Hash([NSString stringWithFormat:@"%@%@", @"characLocations", saveTime])];

    NSString *exceptionStr = nil;
    @try {
        YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
        [store createTableWithName:TIANCI_DB];
        
        NSMutableDictionary *objects = [NSMutableDictionary dictionary];
        
        if (self.tianciName)        {[objects setObject:self.tianciName forKey:@"title"];}
        if (self.tianciContent)     {[objects setObject:self.tianciContent forKey:@"content"];}
        if (saveTime)               {[objects setObject:saveTime forKey:@"saveTime"];}
        if (self.requestHeadName)   {[objects setObject:self.requestHeadName forKey:@"requestHeadName"];}
        if (self.itemModel.acc_mp3) {[objects setObject:self.itemModel.acc_mp3 forKey:@"acc_mp3"];}
        if (self.itemModel.id)      {[objects setObject:self.itemModel.id forKey:@"zouyin_id"];}
        if (self.itemModel.singer)  {[objects setObject:self.itemModel.singer forKey:@"zouyin_singer"];}
        
        [objects setObject:[NSNumber numberWithInteger:self.finalLyricArray.count]
                    forKey:@"line"];
        [objects setObject:MD5Hash([NSString stringWithFormat:@"%@%@", @"tianciMidiData", saveTime])
                    forKey:@"tianciMidiData"];
        [objects setObject:MD5Hash([NSString stringWithFormat:@"%@%@", @"lyricDic", saveTime])
                    forKey:@"lyricDic"];
        [objects setObject:MD5Hash([NSString stringWithFormat:@"%@%@", @"lyricFormat", saveTime])
                    forKey:@"lyricFormat"];
        [objects setObject:MD5Hash([NSString stringWithFormat:@"%@%@", @"characLocations", saveTime])
                    forKey:@"characLocations"];
        
        [store putObject:objects withId:saveTime intoTable:TIANCI_DB];
    }
    @catch (NSException *exception) {
        exceptionStr = exception.description;
        NSLog(@"%@", exception);
    }
    @finally {
        if (exceptionStr) {
            [KVNProgress showSuccessWithStatus:exceptionStr];
        } else {
            [AXGMessage showImageToastOnView:self.view image:[UIImage imageNamed:@"弹出框_保存草稿"] type:1];
            // 2s后按钮恢复点击
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                sender.enabled = YES;
            });
        }
    }
}
// 下一步按钮方法
- (void)nextButtonAction:(UIButton *)sender {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.song_tag = @"改曲";
    
    [self getLyricArray];
    
    XianQuShiTingViewController *xqc = [XianQuShiTingViewController new];
    
    // 最后提交的时候把去除的~还原
    for (NSInteger i = 0; i < self.characLocationsArray.count; i++) {
        NSArray *locations = self.characLocationsArray[i];
        NSMutableString *muStr = [[NSMutableString alloc] initWithString:self.finalLyricArray[i]];
        for (NSString *location in locations) {
            NSInteger locationIndex = [location integerValue];
            if (locationIndex == 0) {
                
            } else {
                if (locationIndex >= muStr.length) {
                    [muStr appendString:@"-"];
                } else {
                    [muStr insertString:@"-" atIndex:locationIndex];
                }
            }
        }
        [self.finalLyricArray replaceObjectAtIndex:i withObject:muStr];
    }
    NSString *content = @"";
    
    NSInteger i = 0;
    for (NSString *lyric in self.finalLyricArray) {
        if (i > 0) {
           content = [content stringByAppendingString:@","];
        }
        content = [content stringByAppendingString:lyric];
        i++;
    }
    app.template_id = self.itemModel.id;
#if XUANQU_FROME_NET
    xqc.zouyinUrl = @{@"title":self.tianciName,
                      @"content":content,
                      @"id":self.itemModel.id,
                      @"singer":self.itemModel.singer,
                      };
#elif !XUANQU_FROME_NET
    NSString *url = [NSString stringWithFormat:ZOUYIN_URL, self.tianciName, content, self.requestSongName];
    xqc.zouyinUrl = url;
#endif
    xqc.lyricDataSource = self.finalLyricArray;
    xqc.isFirstPlay = YES;
    xqc.isFromPlayView = NO;
    xqc.isFromTianciPage = YES;
    xqc.isFirstGetZouyinMp3 = YES;
    xqc.titleStr = self.tianciName;
    xqc.songName = xqc.titleStr;
    xqc.requestHeadName = self.requestHeadName;
    xqc.zouyin_banzouUrl = self.itemModel.acc_mp3;
    xqc.requestSongName = self.requestSongName;
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"loading"];
    
    [PlayViewController sharePlayVC];
//    PlayShareObjects *object = [PlayShareObjects sharedPlayShareObjects];
//    object.lyricDataSource = self.finalLyricArray;
//    object.isFirstPlay = YES;
//    object.isFirstPlay = YES;
//    object.isFromPlayView = NO;
//    object.isFromTianciPage = YES;
//    object.isFirstGetZouyinMp3 = YES;
//    object.titleStr = self.tianciName;
//    object.songName = xqc.titleStr;
//    object.requestHeadName = self.requestHeadName;
//    object.zouyin_banzouUrl = self.itemModel.acc_mp3;
    
    [self.navigationController pushViewController:xqc animated:YES];
}


@end
