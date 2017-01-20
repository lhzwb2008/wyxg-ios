//
//  PersonBaseController.m
//  CreateSongs
//
//  Created by axg on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonBaseController.h"
#import "UIView+Common.h"
#import "SettingViewController.h"
#import "MobClick.h"
#import "XieciViewController.h"
#import "PersonFocusBtn.h"
#import "NavLeftButton.h"
#import "NavRightButton.h"


@interface PersonBaseController ()
@end

@implementation PersonBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createHeadView];
//    [self createWorkCollection];
//    [self createLikeCollection];
//    [self createFocusTable];
//    [self createFollowTable];
//    [self createNavView];
}

- (instancetype)initWIthUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (NSMutableArray *)dataSourceLike {
    if (_dataSourceLike == nil) {
        _dataSourceLike = [NSMutableArray array];
    }
    return _dataSourceLike;
}

- (NSMutableArray *)dataSourceFocus {
    if (_dataSourceFocus == nil) {
        _dataSourceFocus = [NSMutableArray array];
    }
    return _dataSourceFocus;
}

- (NSMutableArray *)dataSourceWorks {
    if (_dataSourceWorks == nil) {
        _dataSourceWorks = [NSMutableArray array];
    }
    return _dataSourceWorks;
}

- (NSMutableArray *)dataSourceFollow {
    if (_dataSourceFollow == nil) {
        _dataSourceFollow = [NSMutableArray array];
    }
    return _dataSourceFollow;
}
// 创建头视图
- (void)createHeadView {
    
    
    if (kDevice_Is_iPhone6Plus) {
        self.head_Height = PERSON_HEAD_HEIGHT;
    } else if (kDevice_Is_iPhone6) {
        self.head_Height = PERSON_HEAD_HEIGHT;
    }
    else {
        self.head_Height = 402;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.wallView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEAD_HEIGHT)];
    self.wallView.contentMode = UIViewContentModeScaleAspectFill;
//    self.wallView.backgroundColor = [UIColor redColor];
    self.wallView.image = [UIImage imageNamed:@"个人中心背景"];
    [self.view addSubview:self.wallView];

    
    CGFloat headImgHeight = 200;
    
    self.infoHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, self.head_Height * HEIGHT_NIT)];
    self.infoHeadViewPoint = self.infoHeadView.center;
    self.infoHeadView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.infoHeadView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 200 * HEIGHT_NIT, SCREEN_W, (181) * HEIGHT_NIT)];
    [self.infoHeadView addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
//    bgView.backgroundColor = [UIColor whiteColor];

    
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(40 * WIDTH_NIT, 152 * HEIGHT_NIT, 80 * HEIGHT_NIT, 80 * HEIGHT_NIT)];
    self.headImage.image = [UIImage imageNamed:@"头像"];
    self.headImage.layer.cornerRadius = self.headImage.width / 2;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.userInteractionEnabled = YES;
    self.headImage.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.headImage.layer.borderWidth = 0.5f;
    self.headImage.center = CGPointMake(SCREEN_W / 2, bgView.top);
    
    [self.infoHeadView addSubview:self.headImage];
    
    UIView *editBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95 * WIDTH_NIT, 15 * HEIGHT_NIT)];
    [self.infoHeadView addSubview:editBottom];
    editBottom.center = CGPointMake(self.headImage.centerX, self.nickName.centerY + 7 * HEIGHT_NIT + 20 * HEIGHT_NIT);

    
    self.signature = [[UILabel alloc] initWithFrame:CGRectMake(86 * WIDTH_NIT, self.headImage.bottom + 15*HEIGHT_NIT, self.view.width - 86 * WIDTH_NIT * 2, editBottom.height * 2)];
    self.signature.centerX = self.headImage.centerX;
    [self.infoHeadView addSubview:self.signature];
    //    self.signature.backgroundColor = [UIColor redColor];
    self.signature.text = @"";
    self.signature.font = [UIFont systemFontOfSize:10*WIDTH_NIT];
    self.signature.textColor = [UIColor colorWithHexString:@"#535353"];
    self.signature.numberOfLines = 2;

    PersonFocusBtn *focusBtn = [PersonFocusBtn buttonWithType:UIButtonTypeCustom];
    focusBtn.frame = CGRectMake(0, self.signature.top + (23+10)*HEIGHT_NIT, 85*HEIGHT_NIT, 25*HEIGHT_NIT);
    focusBtn.clipsToBounds = YES;
    focusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    focusBtn.centerX = self.headImage.centerX - 12.5 * WIDTH_NIT - 42.5 * WIDTH_NIT;
    focusBtn.layer.cornerRadius = focusBtn.height/2;
    focusBtn.titleLabel.font = JIACU_FONT(12);
    [focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    [focusBtn setImage:[UIImage imageNamed:@"个人中心关注加号icon"] forState:UIControlStateNormal];
    [focusBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//    [focusBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFDC74"]];
    [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"私信黄背景"] forState:UIControlStateNormal];
    [self.infoHeadView addSubview:focusBtn];
    self.focusBtn = focusBtn;
    
    UIButton *sixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sixinButton.frame = CGRectMake(focusBtn.right + 25 * WIDTH_NIT, focusBtn.top, focusBtn.width, focusBtn.height);
    sixinButton.layer.cornerRadius = sixinButton.height / 2;
    sixinButton.layer.masksToBounds = YES;
    sixinButton.titleLabel.font = focusBtn.titleLabel.font;
    [sixinButton setTitle:@"私信" forState:UIControlStateNormal];
    [sixinButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateNormal];
    [sixinButton setTitleColor:HexStringColor(@"#ffdc74") forState:UIControlStateHighlighted];
    [sixinButton setBackgroundImage:[UIImage imageNamed:@"私信黄背景"] forState:UIControlStateNormal];
    [sixinButton setBackgroundImage:[UIImage imageNamed:@"私信白背景"] forState:UIControlStateHighlighted];
    [self.infoHeadView addSubview:sixinButton];
    self.sixinButton = sixinButton;
//    [sixinButton addTarget:self action:@selector(sixinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size1 = [@"10" getWidth:@"10" andFont:NORML_FONT(12)];
    CGSize size2 = [@"作品" getWidth:@"作品" andFont:NORML_FONT(15)];
    
    self.worksCount = [[UILabel alloc] initWithFrame:CGRectMake(0, self.infoHeadView.bottom-(18+10)*HEIGHT_NIT-size1.height-size2.height, SCREEN_W / 4, 12)];
    [self.infoHeadView addSubview:self.worksCount];
    self.worksCount.textAlignment = NSTextAlignmentCenter;
    self.worksCount.font = JIACU_FONT(12);
    self.worksCount.text = @"0";
    
    UILabel *zuopinLable = [UILabel new];
    zuopinLable.frame = CGRectMake(0, self.worksCount.bottom+10*HEIGHT_NIT, self.worksCount.width, 15);
    zuopinLable.textAlignment = NSTextAlignmentCenter;
    zuopinLable.font = JIACU_FONT(15);
//    zuopinLable.textColor = [UIColor colorWithHexString:@"#ffffff"];
    zuopinLable.text = @"作品";
    zuopinLable.center = CGPointMake(self.worksCount.centerX, zuopinLable.centerY);
    [self.infoHeadView addSubview:zuopinLable];
    self.worksLabel = zuopinLable;
    
    self.likeCount = [[UILabel alloc] initWithFrame:CGRectMake(self.worksCount.right, self.worksCount.top, self.worksCount.width, self.worksCount.height)];
    [self.infoHeadView addSubview:self.likeCount];
    self.likeCount.textAlignment = NSTextAlignmentCenter;
    self.likeCount.font = NORML_FONT(12);
    self.likeCount.text = @"0";
    
    UILabel *likeLabel = [UILabel new];
    likeLabel.frame = CGRectMake(0, self.likeCount.bottom+10*HEIGHT_NIT, self.worksCount.width, 15);
    likeLabel.textAlignment = NSTextAlignmentCenter;
    likeLabel.font = NORML_FONT(15);
//    likeLabel.textColor = [UIColor colorWithHexString:@"#535353"];
    likeLabel.text = @"喜欢";
    likeLabel.center = CGPointMake(self.likeCount.centerX, likeLabel.centerY);
    [self.infoHeadView addSubview:likeLabel];
    self.likeLabel = likeLabel;
    
    self.focusCount = [[UILabel alloc] initWithFrame:CGRectMake(self.likeCount.right, self.likeCount.top, self.likeCount.width, self.likeCount.height)];
    [self.infoHeadView addSubview:self.focusCount];
    self.focusCount.textAlignment = NSTextAlignmentCenter;
    self.focusCount.font = NORML_FONT(12);
    self.focusCount.text = @"0";
    
    
    UILabel *focusLabel = [UILabel new];
    focusLabel.frame = CGRectMake(0, self.focusCount.bottom+10*HEIGHT_NIT, self.worksCount.width, 15);
    focusLabel.textAlignment = NSTextAlignmentCenter;
    focusLabel.font = NORML_FONT(15);
//    focusLabel.textColor = [UIColor colorWithHexString:@"#535353"];
    focusLabel.text = @"关注";
    focusLabel.center = CGPointMake(self.focusCount.centerX, focusLabel.centerY);
    [self.infoHeadView addSubview:focusLabel];
    self.focusLabel = focusLabel;
    
    self.followCount = [[UILabel alloc] initWithFrame:CGRectMake(self.focusCount.right, self.focusCount.top, self.focusCount.width, self.focusCount.height)];
    [self.infoHeadView addSubview:self.followCount];
    self.followCount.textAlignment = NSTextAlignmentCenter;
    self.followCount.font = NORML_FONT(12);
    self.followCount.text = @"0";
    
    UILabel *followLabel = [UILabel new];
    followLabel.frame = CGRectMake(0, self.followCount.bottom+10*HEIGHT_NIT, self.worksCount.width, 15);
    followLabel.textAlignment = NSTextAlignmentCenter;
    followLabel.font = NORML_FONT(15);
//    followLabel.textColor = [UIColor colorWithHexString:@"#535353"];
    followLabel.text = @"粉丝";
    followLabel.center = CGPointMake(self.followCount.centerX, followLabel.centerY);
    [self.infoHeadView addSubview:followLabel];
    self.followLabel = followLabel;
    
    zuopinLable.textColor = [UIColor colorWithHexString:@"#441D11"];
    likeLabel.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
    focusLabel.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
    followLabel.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
    self.worksCount.textColor = [UIColor colorWithHexString:@"#441D11"];
    self.likeCount.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
    self.focusCount.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
    self.followCount.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
    

    UILabel *seperateLine = [UILabel new];
    seperateLine.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    seperateLine.frame = CGRectMake(0, self.head_Height*HEIGHT_NIT-0.5, self.view.width, 0.5*HEIGHT_NIT);
    [self.infoHeadView addSubview:seperateLine];
    
    self.moveLabel = [UILabel new];
    self.moveLabel.frame = CGRectMake(0, 0, 40*WIDTH_NIT, 2*HEIGHT_NIT);
    self.moveLabel.center = CGPointMake(zuopinLable.centerX, seperateLine.centerY-0.25*HEIGHT_NIT);
    self.moveLabel.backgroundColor = [UIColor colorWithHexString:@"#441D11"];
    [self.infoHeadView addSubview:self.moveLabel];
}

// 私信按钮方法
- (void)sixinButtonAction:(UIButton *)sender {
    NSLog(@"父类点击私信");
}

- (void)isFocus:(BOOL)isFocus {
    if (isFocus) {
        [self.focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.focusBtn setTitleColor:[UIColor colorWithHexString:@"#FFDC74"] forState:UIControlStateNormal];
//        [self.focusBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"私信白背景"] forState:UIControlStateNormal];
        
    } else {
        [self.focusBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.focusBtn setImage:[UIImage imageNamed:@"个人中心关注加号icon"] forState:UIControlStateNormal];
        [self.focusBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//        [self.focusBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFDC74"]];
        [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"私信黄背景"] forState:UIControlStateNormal];
    }
}

- (UICollectionViewFlowLayout *)getLayoutForCollection {
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    return flowLayout;
}
// 创建作品collection
- (void)createWorkCollection {
    self.worksCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[self getLayoutForCollection]];
    [self.view addSubview:self.worksCollectionView];
    self.worksCollectionView.backgroundColor = [UIColor clearColor];
    self.worksCollectionView.delegate = self.collectionDelegate1;
    self.worksCollectionView.dataSource = self.collectionDelegate1;
    self.collectionDelegate1.indentifier = collectionIdentifier1;
    self.collectionDelegate1.headIndentifier = collectionHeadIdentifier1;
    self.collectionDelegate1.footIndentifier = collectionFootIdentifier1;
    self.collectionDelegate1.isPersonCenter = YES;
    [self.worksCollectionView reloadData];
    [self.likeCollectionView reloadData];
    self.collectionDelegate1.pageType = workPage;
    self.collectionDelegate1.pageCenter = personCenter;
    [self.worksCollectionView registerClass:[WorkCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier1];
    [self.worksCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeadIdentifier1];
    [self.worksCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFootIdentifier1];
    
    self.worksCollectionView.alwaysBounceVertical = YES;
    
    // 没有歌曲时的站位
    
    self.xieciLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 115 * HEIGHT_NIT, self.view.width, 115 * HEIGHT_NIT)];
    [self.worksCollectionView addSubview:self.xieciLabel];
    self.xieciLabel.font = NORML_FONT(15);
    self.xieciLabel.textColor = HexStringColor(@"#A0A0A0");
    self.xieciLabel.text = @"还没有作品哦";
    self.xieciLabel.textAlignment = NSTextAlignmentCenter;
    self.xieciLabel.userInteractionEnabled = YES;
    
    self.xieciImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height - 106 * HEIGHT_NIT - 127 * HEIGHT_NIT, 91.5 * HEIGHT_NIT, 127 * HEIGHT_NIT)];
    [self.worksCollectionView addSubview:self.xieciImage];
    self.xieciImage.image = [UIImage imageNamed:@"个人空状态"];
    self.xieciImage.center = CGPointMake(self.view.centerX, self.xieciImage.centerY);
    
    
//    self.xieciImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 390 * HEIGHT_NIT, 60, 80)];
//    [self.view addSubview:self.xieciImage];
//    self.xieciImage.center = CGPointMake(self.view.centerX, self.xieciImage.centerY);
//    self.xieciImage.image = [UIImage imageNamed:@"defaultCenterCat"];
//    
//    self.xieciLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.xieciImage.bottom + 21 * HEIGHT_NIT, self.view.width / 2, 20)];
//    self.xieciLabel.center = CGPointMake(self.view.centerX, self.xieciLabel.centerY);
//    [self.view addSubview:self.xieciLabel];
//    self.xieciLabel.font = [UIFont systemFontOfSize:16];
//    self.xieciLabel.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
//    self.xieciLabel.text = @"快去写歌吧";
//    self.xieciLabel.textAlignment = NSTextAlignmentCenter;
//    self.xieciLabel.userInteractionEnabled = YES;
//    
//    self.xieciButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:self.xieciButton];
//    self.xieciButton.backgroundColor = [UIColor clearColor];
//    self.xieciButton.frame = CGRectMake(self.xieciLabel.left, self.xieciImage.top, self.xieciLabel.width, self.xieciImage.height + self.xieciLabel.height*3);
//    [self.xieciButton addTarget:self action:@selector(enterXieciPage:) forControlEvents:UIControlEventTouchUpInside];
    
    self.xieciImage.hidden = YES;
    self.xieciLabel.hidden = YES;
    self.xieciButton.hidden = YES;
}
/*
 
 self.xieciImage.hidden = YES;
 self.xieciLabel.hidden = YES;
 self.xieciButton.hidden = YES;

 
 self.favorImage.hidden = YES;
 self.favorButton.hidden = YES;
 self.favorLabel.hidden = YES;
 */
// 进入写词界面
- (void)enterXieciPage:(UIButton *)sender {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.originSongName = @"";
    
    XieciViewController *xieciVC = [[XieciViewController alloc] init];
    [self.navigationController pushViewController:xieciVC animated:YES];
}
// 创建喜欢collection
- (void)createLikeCollection {
    self.likeCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[self getLayoutForCollection]];
    [self.view addSubview:self.likeCollectionView];
    self.likeCollectionView.backgroundColor = [UIColor clearColor];
    //    self.likeCollectionView.backgroundColor = BG_COLOR;
    self.likeCollectionView.delegate = self.collectionDelegate2;
    self.likeCollectionView.dataSource = self.collectionDelegate2;
    self.collectionDelegate2.indentifier = collectionIdentifier2;
    self.collectionDelegate2.footIndentifier = collectionFootIdentifier2;
    self.collectionDelegate2.headIndentifier = collectionHeadIdentifier2;
    self.collectionDelegate2.isPersonCenter = YES;
    [self.worksCollectionView reloadData];
    [self.likeCollectionView reloadData];
    self.collectionDelegate2.pageType = likePage;
    [self.likeCollectionView registerClass:[WorkCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier2];
    [self.likeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeadIdentifier2];
    [self.likeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFootIdentifier2];
    
    self.likeCollectionView.hidden = YES;
    
    self.likeCollectionView.alwaysBounceVertical = YES;
    
    // 没有喜欢歌曲时的站位
    
    self.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 115 * HEIGHT_NIT, self.view.width, 115 * HEIGHT_NIT)];
    [self.likeCollectionView addSubview:self.favorLabel];
    self.favorLabel.font = NORML_FONT(15);
    self.favorLabel.textColor = HexStringColor(@"#A0A0A0");
    self.favorLabel.text = @"还没有作品哦";
    self.favorLabel.textAlignment = NSTextAlignmentCenter;
    self.favorLabel.userInteractionEnabled = YES;
    
    self.favorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height - 106 * HEIGHT_NIT - 127 * HEIGHT_NIT, 91.5 * HEIGHT_NIT, 127 * HEIGHT_NIT)];
    [self.likeCollectionView addSubview:self.favorImage];
    self.favorImage.image = [UIImage imageNamed:@"个人空状态"];
    self.favorImage.center = CGPointMake(self.view.centerX, self.favorImage.centerY);
    
//    self.favorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 390 * HEIGHT_NIT, 60, 80)];
//    [self.view addSubview:self.favorImage];
//    self.favorImage.center = CGPointMake(self.view.centerX, self.favorImage.centerY);
//    self.favorImage.image = [UIImage imageNamed:@"defaultCenterCat2"];
//    
//    self.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.favorImage.bottom + 21 * HEIGHT_NIT, self.view.width / 2, 20)];
//    self.favorLabel.center = CGPointMake(self.view.centerX, self.favorLabel.centerY);
//    [self.view addSubview:self.favorLabel];
//    self.favorLabel.font = [UIFont systemFontOfSize:16];
//    self.favorLabel.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
//    self.favorLabel.text = @"还没有喜欢的歌曲";
//    self.favorLabel.textAlignment = NSTextAlignmentCenter;
//    self.favorLabel.userInteractionEnabled = YES;
//    
//    self.favorButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:self.favorButton];
//    self.favorButton.frame = CGRectMake(self.favorLabel.left, self.favorImage.top, self.favorLabel.width, self.favorImage.height + self.favorLabel.height);
//    [self.favorButton addTarget:self action:@selector(enterHomePageToFavor:) forControlEvents:UIControlEventTouchUpInside];
    
    self.favorImage.hidden = YES;
    self.favorButton.hidden = YES;
    self.favorLabel.hidden = YES;
}
// 没有收藏的歌曲，进入首页
- (void)enterHomePageToFavor:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"turnToHomePage" object:nil];
}
// 创建关注列表
- (void)createFocusTable {
    self.focusTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.focusTableView];
    self.focusTableView.backgroundColor = [UIColor clearColor];
    //    self.focusTableView.backgroundColor = BG_COLOR;
    self.focusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.focusTableView.delegate = self.tableDelegate1;
    self.focusTableView.dataSource = self.tableDelegate1;
    self.tableDelegate1.indentifier = tableViewIdentifier1;
    self.tableDelegate1.isPersonCenter = YES;
    self.tableDelegate1.pageType = focusPage;
    [self.focusTableView registerClass:[FocusTableViewCell class] forCellReuseIdentifier:tableViewIdentifier1];
    
    self.focusTableView.hidden = YES;
    
    // 没有关注站位
    self.focusNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 115 * HEIGHT_NIT, self.view.width, 115 * HEIGHT_NIT)];
    [self.focusTableView addSubview:self.focusNoLabel];
    self.focusNoLabel.font = NORML_FONT(15);
    self.focusNoLabel.textColor = HexStringColor(@"#A0A0A0");
    self.focusNoLabel.text = @"还没有作品哦";
    self.focusNoLabel.textAlignment = NSTextAlignmentCenter;
    self.focusNoLabel.userInteractionEnabled = YES;
    
    self.focusNoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height - 106 * HEIGHT_NIT - 127 * HEIGHT_NIT, 91.5 * HEIGHT_NIT, 127 * HEIGHT_NIT)];
    [self.focusTableView addSubview:self.focusNoImage];
    self.focusNoImage.image = [UIImage imageNamed:@"个人空状态"];
    self.focusNoImage.center = CGPointMake(self.view.centerX, self.focusNoImage.centerY);
    
    self.focusNoImage.hidden = YES;
    self.focusNoLabel.hidden = YES;
}
// 创建粉丝列表
- (void)createFollowTable {
    self.followTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.followTableView];
    self.followTableView.backgroundColor = [UIColor clearColor];
    //    self.followTableView.backgroundColor = BG_COLOR;
    self.followTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.followTableView.delegate = self.tableDelegate2;
    self.followTableView.dataSource = self.tableDelegate2;
    self.tableDelegate2.indentifier = tableViewIdentifier2;
    self.tableDelegate2.isPersonCenter = YES;
    self.tableDelegate2.pageType = followPage;
    [self.followTableView registerClass:[FocusTableViewCell class] forCellReuseIdentifier:tableViewIdentifier2];
    
    self.followTableView.hidden = YES;
    
    self.followNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 115 * HEIGHT_NIT, self.view.width, 115 * HEIGHT_NIT)];
    [self.followTableView addSubview:self.followNoLabel];
    self.followNoLabel.font = NORML_FONT(15);
    self.followNoLabel.textColor = HexStringColor(@"#A0A0A0");
    self.followNoLabel.text = @"还没有作品哦";
    self.followNoLabel.textAlignment = NSTextAlignmentCenter;
    self.followNoLabel.userInteractionEnabled = YES;
    
    self.followNoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height - 106 * HEIGHT_NIT - 127 * HEIGHT_NIT, 91.5 * HEIGHT_NIT, 127 * HEIGHT_NIT)];
    [self.followTableView addSubview:self.followNoImage];
    self.followNoImage.image = [UIImage imageNamed:@"个人空状态"];
    self.followNoImage.center = CGPointMake(self.view.centerX, self.followNoImage.centerY);
    
    self.followNoImage.hidden = YES;
    self.followNoLabel.hidden = YES;
    
}
//- (void)createNavView2 {
//    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
//    [self.view addSubview:navView];
//    navView.backgroundColor = [UIColor colorWithHexString:@"#879999"];
//    self.navView2 = navView;
//    
//    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(18 * WIDTH_NIT, 30, 23, 22.5)];
//    [navView addSubview:backImage];
//    backImage.centerY = 44/2 + 20;
//    backImage.image = [UIImage imageNamed:@"菜单2"];
// 
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 64, 64);
//    [navView addSubview:leftButton];
//    [leftButton addTarget:self
//                   action:@selector(backButtonAction:)
//         forControlEvents:UIControlEventTouchUpInside];
//    
//    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width -  (23 + 18 * WIDTH_NIT), 30, 25, 24)];
//    [navView addSubview:rightImage];
//    rightImage.centerY = backImage.centerY;
//    rightImage.image = [UIImage imageNamed:@"设置2"];
//    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [navView addSubview:rightButton];
//    rightButton.frame = CGRectMake(self.view.width - 64, 0, 64, 64);
//    [rightButton addTarget:self
//                    action:@selector(enterUserInfo)
//          forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    [navView addSubview:titleLable];
//    titleLable.textAlignment = NSTextAlignmentCenter;
//    titleLable.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
//    titleLable.font = [UIFont systemFontOfSize:18];
//    titleLable.center = CGPointMake(self.view.centerX, rightImage.centerY);
//    
////    UILabel *line = [UILabel new];
////    line.frame = CGRectMake(0, navView.height-0.5*HEIGHT_NIT, navView.width, 0.5*HEIGHT_NIT);
////    line.backgroundColor = [UIColor whiteColor];
////    [navView addSubview:line];
//    
//    self.navView2.alpha = 0.0f;
//    
//    self.titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//    self.titleLabel2.textColor = [UIColor whiteColor];
//    self.titleLabel2.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel2.font = TECU_FONT(18);
//    self.titleLabel2.center = CGPointMake(navView.width/2, backImage.centerY);
//    [navView addSubview:self.titleLabel2];
//}
- (void)createNavView {
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    self.bottomView.alpha = 0.0f;
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#FFDC74"];
    [self.view addSubview:self.bottomView];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [self.view addSubview:navView];
    navView.backgroundColor = [UIColor clearColor];
    self.navView = navView;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [navView addSubview:self.titleLabel];
    self.titleLabel.textColor = HexStringColor(@"#441D11");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = TECU_FONT(18);
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 23, 20)];
    backImage.center = CGPointMake(backImage.centerX, 42);
    [navView addSubview:backImage];
//    backImage.image = [UIImage imageNamed:@"菜单2"];
    
    self.titleLabel.center = CGPointMake(self.view.width / 2, backImage.centerY);
    
    NavLeftButton *leftButton = [NavLeftButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 64, 64);
    [leftButton setImage:[UIImage imageNamed:@"菜单2"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"菜单_高亮"] forState:UIControlStateHighlighted];
    [navView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width -  (23 + 18 * WIDTH_NIT), 30, 25, 24)];
    [navView addSubview:rightImage];
    rightImage.centerY = backImage.centerY;
//    rightImage.image = [UIImage imageNamed:@"设置2"];
    
//    NavRightButton *rightButton = [NavRightButton buttonWithType:UIButtonTypeCustom];
//    [navView addSubview:rightButton];
//    rightButton.frame = CGRectMake(self.view.width - 64, 0, 64, 64);
//    [rightButton setImage:[UIImage imageNamed:@"设置2"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(enterUserInfo) forControlEvents:UIControlEventTouchUpInside];
}
// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {

//    [self.mm_drawerController
//     openDrawerSide:MMDrawerSideLeft
//     animated:YES
//     completion:^(BOOL finished) {
//         
//     }];
}
/**
 *  头像点击方法
 */
- (void)headTgr:(UITapGestureRecognizer *)tgr {
    
}
//// 进入修改个人信息页面
//- (void)enterUserInfo {
//    
//    SettingViewController *settingVC = [[SettingViewController alloc] init];
//    [self.navigationController pushViewController:settingVC animated:YES];
//    
//}
@end
