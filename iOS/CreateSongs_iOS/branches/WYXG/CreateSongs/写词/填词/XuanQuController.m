//
//  XuanQuController.m
//  CreateSongs
//
//  Created by axg on 16/8/2.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "XuanQuController.h"
#import "XuanQuCell.h"
#import "XuanQuModel.h"
#import "TianciViewController.h"
#import "XMidiPlayer.h"
#import "MJRefresh.h"
#import "XuanquTempModel.h"
#import "SongLoadingView.h"
#import "MidiParser.h"
#import "AFNetworking.h"

@interface XuanQuController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *songsTableView;

@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic, strong) NSMutableArray *songsArray;

@property (nonatomic, strong) XMidiPlayer *midiPlayer;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) NSInteger currentPlayCellIndex;

// 请求现有曲子模板的歌曲名字
@property (nonatomic, strong) NSArray *requestHeadNames;

@property (nonatomic, strong) XuanQuCell *currentCell;

@end

@implementation XuanQuController

- (NSMutableArray *)songsArray {
    if (_songsArray == nil) {
        _songsArray = [NSMutableArray array];
    }
    return _songsArray;
}

- (NSMutableArray *)itemsArray {
    if (_itemsArray == nil) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (NSString *)setTitleTxt {
    return @"选曲";
}

//- (UIImage *)setLeftBtnImage {
//    return [UIImage imageNamed:@"返回"];
//}

- (void)initNavView {
    [super initNavView];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
}

- (void)initPlayer {
    self.midiPlayer = [[XMidiPlayer alloc] init];
    
    [self.midiPlayer pause];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.lyricWriter = @"";
    app.songWriter = @"";
    app.songSinger = @"";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self initPlayer];
    [self createTableView];
    [self initRefresh];
    [self.navLeftButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.navView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self pausePlay];
}

- (void)leftBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initRefresh {
    
#if XUANQU_FROME_NET
    WEAK_SELF;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONG_SELF;
        [self getDataIsMore:NO];
    }];
    self.songsTableView.mj_header = header;
    
    [self.songsTableView.mj_header beginRefreshing];
#elif !XUANQU_FROME_NET
    [self initDataSource];
#endif
}
- (void)getDataIsMore:(BOOL)isMore {
    
    if (isMore) {
        [self.songsTableView.mj_header endRefreshing];
    } else {
        [self.songsTableView.mj_footer endRefreshing];
    }
    [self.songsArray removeAllObjects];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    [XWAFNetworkTool getUrl:ZOUYIN_TEMPLATE body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id resposeObjects) {
        XuanquTempModel *model = [[XuanquTempModel alloc] initWithData:resposeObjects error:nil];
        for (XuanquItemsModel *item in model.items) {
            if ([item.status isEqualToString:@"1"]) {
                [self.songsArray addObject:item];
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        [self.songsTableView reloadData];
        [self.songsTableView.mj_header endRefreshing];
        [self.songsTableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.description);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        [self.songsTableView.mj_header endRefreshing];
        [self.songsTableView.mj_footer endRefreshing];
    }];
}

- (void)initDataSource {
    [self.songsArray removeAllObjects];
    self.requestHeadNames = @[@"frx",
                              @"qcxlsc",
                              @"wdgsl",
                              @"hlw",
                              @"zdsjdjt"
                              ];
    
    NSDictionary *lyricDic = @{self.requestHeadNames[0]:@"狼牙月伊人憔悴~,我举杯饮尽了风雪~~,是谁打翻前世柜惹尘埃是非,缘字诀几番轮回~,你锁眉哭红颜唤不回~~,纵然青史已经成灰我爱不灭~,繁华如三千东流水~,我只取一瓢爱了~解,只恋你化身的蝶~,你发如雪凄美了离别,我焚香感动了谁,邀明月让回~忆皎洁,爱在月光下完~美,你发如雪纷飞了眼泪,我等待苍老了谁,红尘醉微醺~的岁月,我用无悔刻永世爱你的碑",
                            self.requestHeadNames[1]:@"跟着我左手右手一个慢动作,右手左手慢动作重播,哦这首歌~给你快~乐~,你有没有爱上我,跟着我鼻子眼睛动一动耳朵,装乖耍帅换不停风格,青春有太多未知的猜测,成长的烦恼算什么~",
                            self.requestHeadNames[2]:@"没有一点点防备,也没有一丝顾虑,你就这样出~现,在我的世界里,带给我惊喜情~不自已,可是你偏又这样,在我不知不觉中悄悄的消失,从我的世界里没有音讯,剩下~的只是回~忆,你存~~在我深深的脑~海~里,我的梦里我的心里我的歌声里,你存~~在我~深深的脑海~里~,我的梦里我的心里我的歌声~里",
                            self.requestHeadNames[3]:@"葫芦娃葫芦娃,一根藤~上七朵花,风吹雨~打都不怕,啦啦啦啦,叮当当咚咚当当,葫芦娃,叮当当咚咚当当,本领大,啦啦啦啦,葫芦娃,葫芦娃,本领~大",
                            self.requestHeadNames[4]:@"曾固执地遥望,以后的路失了方向,曾自嘲地回望,叹息以前梦境一场,脆弱的期待回荡着,迷茫的未来摇晃,不羁的灵魂咆哮,澎湃不甘的狂舞~着,直到世界尽头又将怎样,是否剥夺我的渴望~,燃烧而不熄的热情,怎能与梦想相分散~,就算世界尽头又会怎样,是否淹没我的呐喊~,纵使曾流泪,但我始终坚信自~己~~,笑意灿烂的明天~,我将蜕变飞翔"
                               };
    NSDictionary *titleDic = @{self.requestHeadNames[0]:@"发如雪",
                               self.requestHeadNames[1]:@"青春修炼手册",
                               self.requestHeadNames[2]:@"我的歌声里",
                               self.requestHeadNames[3]:@"葫芦娃",
                               self.requestHeadNames[4]:@"直到世界的尽头"};
    for (NSString *name in self.requestHeadNames) {
        XuanquItemsModel *item = [XuanquItemsModel new];
        item.lrc = lyricDic[name];
        item.name = titleDic[name];
        item.mid = [[NSBundle mainBundle] pathForResource:name ofType:@"mid"];
        [self.songsArray addObject:item];
    }
    [self.songsTableView reloadData];
}

- (NSArray *)getTimeArray {
    NSArray *array = @[@"0:21，0:25，0:30，0:37，0:40，0:46，0:52，0:58，1:04，1:09，1:14，1:18，1:21，1:26，1:30，1:35，1:40",
                       @"0:04，0:09，0:12，0:16，0:19，0:24，0:27，0:31",
                       @"0:16，0:18，0:20，0:21，0:24，0:30，0:32，0:36，0:39，0:44，0:50，0:57，1:04",
                       @"0:12，0:17，0:20，0:23，0:27，0:29，0:30，0:32，0:33，0:37，0:39，0:41",
                       @"00:37，00:39，00:45，00:48，00:51，00:56，01:01，01:04，01:09，01:13，01:18，01:22，01:26，01:31，01:35，01:37，01:42，01:46"
                       ];
    return array;
}

- (NSMutableArray *)characLoactionsArray {
    if (_characLoactionsArray == nil) {
        _characLoactionsArray = [NSMutableArray array];
    }
    return _characLoactionsArray;
}

- (NSArray *)getCharacterLocations:(NSString *)str {
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (int i = 0; i < str.length; i++) {
        unichar temp = [str characterAtIndex:i];
        if (temp == '~') {
            [tmpArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    if (tmpArr.count == 0) {
        [tmpArr addObject:[NSString stringWithFormat:@"%d", 0]];
    }
    return tmpArr;
}

- (void)createTableView {
    self.songsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.songsTableView.backgroundColor = [UIColor clearColor];
    self.songsTableView.delegate = self;
    self.songsTableView.dataSource = self;
    self.songsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor clearColor];
    headView.frame = CGRectMake(0, 0, self.view.width, 44);
    self.songsTableView.tableHeaderView = headView;
    [self.view addSubview:self.songsTableView];
}

- (void)playMidiData:(NSString *)midiUrl withIndex:(NSInteger)index{
    
    if (self.currentCell) {
        [self.currentCell stopAnimation];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    self.currentCell = (XuanQuCell *)[self.songsTableView cellForRowAtIndexPath:indexPath];

    if (self.isPlaying && self.currentPlayCellIndex == index) {
        [self pausePlay];
        
        [self.currentCell stopAnimation];
        
    } else
    if (self.isPlaying && self.currentPlayCellIndex != index) {
        
        [self requestMidiDataToPlay:midiUrl];
        [self.currentCell startAnimation];
        self.isPlaying = YES;
        self.currentPlayCellIndex = index;
    } else
    if (!self.isPlaying) {
        [self requestMidiDataToPlay:midiUrl];
        
        [self.currentCell startAnimation];
        
        self.isPlaying = YES;
        self.currentPlayCellIndex = index;
    }
}

- (void)requestMidiDataToPlay:(NSString *)midiUrl {
    [XWAFNetworkTool getUrl:midiUrl body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id resposeObjects) {
        
        MidiParser *parser1 = [MidiParser new];
        [parser1 configHeadZeroTime:resposeObjects];
        
        NSData *headData = parser1.headData;
        NSData *zeroData = parser1.zeroData;
        NSData *otherData = parser1.otherData;
        
        NSMutableData *finalData = [[NSMutableData alloc] init];
        
        [finalData appendData:headData];
        [finalData appendData:zeroData];
        [finalData appendData:otherData];
        [finalData appendData:zeroData];
        
        [self.midiPlayer initMidiWithData:finalData];
        [self.midiPlayer play];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@", error.description);
    }];
}

- (void)pausePlay {
    [self.midiPlayer pause];
    self.isPlaying = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section], [indexPath row]];
    XuanQuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[XuanQuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.xuanQuModel = self.songsArray[indexPath.row];
    cell.index = indexPath.row;
    WEAK_SELF;
    cell.beginPlayDemo = ^(NSString *midiUrl, NSInteger index) {
        STRONG_SELF;
        [self playMidiData:midiUrl withIndex:index];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *cells = [self cellsForTableView:tableView];
    for (XuanQuCell *cell in cells) {
        [cell stopAnimation];
    }
    [self pausePlay];
    XuanQuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self turnToTianCiView:cell];
}

-(NSArray *)cellsForTableView:(UITableView *)tableView {
    NSInteger sections = tableView.numberOfSections;
    NSMutableArray *cells = [[NSMutableArray alloc]  init];
    for (int section = 0; section < sections; section++) {
        NSInteger rows =  [tableView numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [cells addObject:[tableView cellForRowAtIndexPath:indexPath]];
        }
    }
    return cells;
}
/*
 0:17，0:26，0:34，0:38，0:42，0:51，0:59，01:07，01:11，01:15，01:19，01:23，01:25，01:28，01:31，01:34，01:36，01:40，01:42，01:44，01:51
 */

- (void)turnToTianCiView:(XuanQuCell *)cell {
    
    TianciViewController *tvc = [TianciViewController new];
    tvc.itemModel = cell.xuanQuModel;
    tvc.lyricModelArray = nil;
    tvc.requestSongName = self.requestHeadNames[cell.index];
    
    SongLoadingView *loading = [SongLoadingView new];
    [self.view addSubview:loading];
    [loading initAction];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.originSongName = cell.titleLabel.text;
    app.songWriter = cell.xuanQuModel.user_id;
    app.songSinger = [NSString stringWithFormat:@"-%@", cell.xuanQuModel.singer];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUTINTERVAL;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:cell.xuanQuModel.lrc parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *str_gb18030 = [[NSString alloc] initWithData:responseObject encoding:encode];
        
        if (str_gb18030) {
            
        }
        NSString *lyric = str_gb18030;
        
        if (![lyric componentsSeparatedByString:@","].count > 0) {
            lyric = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        lyric = [self replaceNoneStr:lyric];
        
        NSMutableArray *tmpFormatArray = [NSMutableArray array];
        NSMutableArray *tmpLocationArray  = [NSMutableArray array];
        
        NSArray *lyricArr = [lyric componentsSeparatedByString:@","];
        for (NSString *lyricStr in lyricArr) {
            NSString *tmpStr = [lyricStr stringByReplacingOccurrencesOfString:@"-" withString:@"~"];
            NSArray *locations = [self getCharacterLocations:tmpStr];
            [tmpLocationArray addObject:locations];
            [tmpFormatArray addObject:[tmpStr stringByReplacingOccurrencesOfString:@"~" withString:@""]];
        }
        [loading stopAnimate];
        
        tvc.lyricFormatArray = tmpFormatArray;
        
        tvc.characLocationsArray = tmpLocationArray;
        
#if XUANQU_FROME_NET
        
        [XWAFNetworkTool getUrl:cell.xuanQuModel.time_file body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id resposeObjects) {
            unsigned long encode1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *str_gb180301 = [[NSString alloc] initWithData:resposeObjects encoding:encode1];
            
            if (!str_gb180301) {
                str_gb180301 = [[NSString alloc] initWithData:resposeObjects encoding:NSUTF8StringEncoding];
            }
#elif !XUANQU_FROME_NET
            NSString *str_gb180301 = [[self getTimeArray] objectAtIndex:cell.index];
#endif
            tvc.requestHeadName = str_gb180301;
            [self.navigationController pushViewController:tvc animated:YES];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error.description);
            [KVNProgress showErrorWithStatus:@"时间轴错误"];
            [self.navigationController pushViewController:tvc animated:YES];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//#if XUANQU_FROME_NET
//    [XWAFNetworkTool getUrl:cell.xuanQuModel.lrc body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask *task, id resposeObjects) {
//
//        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        
//        NSString *str_gb18030 = [[NSString alloc] initWithData:resposeObjects encoding:encode];
//        
//        if (str_gb18030) {
//            
//        }
//        
//        NSString *lyric = str_gb18030;
//        
//#elif !XUANQU_FROME_NET
//        NSString *lyric = cell.xuanQuModel.lrc;
//#endif
//        lyric = [self replaceNoneStr:lyric];
//        
//        if (![lyric componentsSeparatedByString:@","].count > 0) {
//            lyric = [[NSString alloc] initWithData:resposeObjects encoding:NSUTF8StringEncoding];
//            lyric = [self replaceNoneStr:lyric];
//        }
//        
//        NSMutableArray *tmpFormatArray = [NSMutableArray array];
//        NSMutableArray *tmpLocationArray  = [NSMutableArray array];
//        
//        NSArray *lyricArr = [lyric componentsSeparatedByString:@","];
//        for (NSString *lyricStr in lyricArr) {
//            NSString *tmpStr = [lyricStr stringByReplacingOccurrencesOfString:@"-" withString:@"~"];
//            NSArray *locations = [self getCharacterLocations:tmpStr];
//            [tmpLocationArray addObject:locations];
//            [tmpFormatArray addObject:[tmpStr stringByReplacingOccurrencesOfString:@"~" withString:@""]];
//        }
//        [loading stopAnimate];
//        
//        tvc.lyricFormatArray = tmpFormatArray;
//        
//        tvc.characLocationsArray = tmpLocationArray;
//        
//#if XUANQU_FROME_NET
//
//        [XWAFNetworkTool getUrl:cell.xuanQuModel.time_file body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//            
//        } success:^(NSURLSessionDataTask *task, id resposeObjects) {
//            unsigned long encode1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//            NSString *str_gb180301 = [[NSString alloc] initWithData:resposeObjects encoding:encode1];
//            
//            if (!str_gb180301) {
//                str_gb180301 = [[NSString alloc] initWithData:resposeObjects encoding:NSUTF8StringEncoding];
//            }
//#elif !XUANQU_FROME_NET
//            NSString *str_gb180301 = [[self getTimeArray] objectAtIndex:cell.index];
//#endif
//            tvc.requestHeadName = str_gb180301;
//            [self.navigationController pushViewController:tvc animated:YES];
//#if XUANQU_FROME_NET
//
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"%@", error.description);
//            [KVNProgress showErrorWithStatus:@"时间轴错误"];
//            [self.navigationController pushViewController:tvc animated:YES];
//        }];
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@", error.description);
//    }];
//#elif !XUANQU_FROME_NET
//    
//#endif
}

- (NSString *)replaceNoneStr:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"~" withString:@"~"];
    str = [str stringByReplacingOccurrencesOfString:@"，" withString:@","];
    return str;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100*HEIGHT_NIT;
}

@end
