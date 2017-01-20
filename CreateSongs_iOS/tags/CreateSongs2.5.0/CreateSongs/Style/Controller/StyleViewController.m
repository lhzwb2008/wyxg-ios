//
//  StyleViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/19.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "StyleViewController.h"
#import "AXGSlider.h"
#import "ReleaseViewController.h"
#import "TYCommonClass.h"
#import "PlayViewController.h"
#import "MobClick.h"
#import "AXGTools.h"

#define DEFUALTROW1 1
#define DEFUALTROW2 1
#define DEFUALTROW3 1

@interface StyleViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, strong) UIImageView *selectImage;

@end

@implementation StyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    
    self.emotion = arc4random() % 2;
    self.genere = arc4random() % 4;
    
    NSInteger sourceType = arc4random() % 2;
    if (sourceType == 0) {
        self.source = 6;
    } else {
        self.source = 2;
    }
    
    [self createPickView];
    
    [self.view bringSubviewToFront:self.navView];
    
    NSLog(@"%d", self.source);
    
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    self.navTitle.text = @"风格";
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createPickView {
    
    // 三个标题
    UILabel *songTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navView.bottom, 100, 100 * HEIGHT_NIT)];
    songTypeLabel.center = CGPointMake(self.view.width / 2, songTypeLabel.centerY);
    [self.view addSubview:songTypeLabel];
    songTypeLabel.text = @"伴奏";
    songTypeLabel.font = TECU_FONT(15);
    songTypeLabel.textAlignment = NSTextAlignmentCenter;
    songTypeLabel.textColor = HexStringColor(@"#441D11");
    
    UILabel *moodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, songTypeLabel.width, songTypeLabel.height)];
    moodLabel.center = CGPointMake(songTypeLabel.centerX - 107.5 * WIDTH_NIT, songTypeLabel.centerY);
    [self.view addSubview:moodLabel];
    moodLabel.font = songTypeLabel.font;
    moodLabel.textAlignment = NSTextAlignmentCenter;
    moodLabel.textColor = songTypeLabel.textColor;
    moodLabel.text = @"心情";
    
    UILabel *singerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, songTypeLabel.width, songTypeLabel.height)];
    [self.view addSubview:singerLabel];
    singerLabel.center = CGPointMake(songTypeLabel.centerX + 107.5 * WIDTH_NIT, songTypeLabel.centerY);
    singerLabel.text = @"主唱";
    singerLabel.textColor = songTypeLabel.textColor;
    singerLabel.textAlignment = NSTextAlignmentCenter;
    singerLabel.font = songTypeLabel.font;
    
    UIImageView *moodImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.bottom + 67 * HEIGHT_NIT, 5 * HEIGHT_NIT, 22 * HEIGHT_NIT)];
    [self.view addSubview:moodImage];
    moodImage.center = CGPointMake(moodLabel.centerX, moodImage.centerY);
    moodImage.image = [UIImage imageNamed:@"icon"];
    
    UIImageView *songTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, moodImage.top, moodImage.width, moodImage.height)];
    [self.view addSubview:songTypeImage];
    songTypeImage.center = CGPointMake(songTypeLabel.centerX, songTypeImage.centerY);
    songTypeImage.image = [UIImage imageNamed:@"icon"];
    
    UIImageView *singerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, moodImage.top, moodImage.width, moodImage.height)];
    [self.view addSubview:singerImage];
    singerImage.center = CGPointMake(singerLabel.centerX, singerImage.centerY);
    singerImage.image = [UIImage imageNamed:@"icon"];
    
    // pickerView
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100 * HEIGHT_NIT + self.navView.bottom, self.view.width, 200 * HEIGHT_NIT)];
    [self.view addSubview:self.pickView];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    self.pickView.backgroundColor = HexStringColor(@"#FFDC74");
    
    [self.pickView selectRow:self.emotion+300 inComponent:0 animated:NO];
    [self.pickView selectRow:self.genere+300 inComponent:1 animated:NO];
    [self.pickView selectRow:self.source+300 inComponent:2 animated:NO];
    
    // 曲速
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.pickView.bottom + 25 * HEIGHT_NIT, self.view.width, 35 * HEIGHT_NIT)];
    [self.view addSubview:rateLabel];
    rateLabel.text = @"曲速";
    rateLabel.textColor = HexStringColor(@"441D11");
    rateLabel.font = TECU_FONT(15);
    rateLabel.textAlignment = NSTextAlignmentCenter;
    
    AXGSlider *slider = [[AXGSlider alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 102 * HEIGHT_NIT)];
    [self.view addSubview:slider];
    slider.center = CGPointMake(self.view.width / 2, self.pickView.bottom + 105 * HEIGHT_NIT);

    // 滑动改变的block
    WEAK_SELF;
    slider.sliderDidChangedBlock = ^ (CGFloat value) {
        STRONG_SELF;
        self.rate = value;
    };
    self.rate = slider.speedScale;
    // 制作歌曲按钮
    UIButton *createButton = [UIButton new];
    [self.view addSubview:createButton];
    createButton.frame = CGRectMake(0, 0, 250 * WIDTH_NIT, 50 * WIDTH_NIT);
//    createButton.backgroundColor = HexStringColor(@"#879999");
    [createButton setTitle:@"制作歌曲" forState:UIControlStateNormal];
    [createButton setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [createButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    [createButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [createButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
    createButton.titleLabel.font = JIACU_FONT(18);
    createButton.layer.cornerRadius = createButton.height / 2;
    createButton.layer.masksToBounds = YES;
    createButton.center = CGPointMake(self.view.width / 2, self.view.height - 35 * HEIGHT_NIT - 25 * WIDTH_NIT);
    [createButton addTarget:self action:@selector(createSongButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat textWidth = [AXGTools getTextWidth:@"手动改曲" font:NORML_FONT(12)];
    CGFloat leftGap = (self.view.width - textWidth - 10 * WIDTH_NIT - 14 * WIDTH_NIT) / 2;
    
    UIView *gouView = [[UIView alloc] initWithFrame:CGRectMake(leftGap, 0, 18 * WIDTH_NIT, 18 * WIDTH_NIT)];
    [self.view addSubview:gouView];
    gouView.backgroundColor = HexStringColor(@"#eeeeee");
    gouView.layer.cornerRadius = 5 * WIDTH_NIT;
    gouView.layer.masksToBounds = YES;
    gouView.center = CGPointMake(gouView.centerX, createButton.top - 25 * HEIGHT_NIT - 9 * WIDTH_NIT);
    
    self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(gouView.left + 2 * WIDTH_NIT, gouView.top, 18 * WIDTH_NIT - 4 * WIDTH_NIT,  (18 * WIDTH_NIT - 4 * WIDTH_NIT) * (18 / 26.0))];
    self.selectImage.center = CGPointMake(self.selectImage.centerX, gouView.centerY);
    [self.view addSubview:self.selectImage];
    self.selectImage.hidden = YES;
    self.selectImage.image = [UIImage imageNamed:@"选中"];
    
    UIButton *selectButton = [UIButton new];
    [self.view addSubview:selectButton];
    selectButton.backgroundColor = [UIColor clearColor];
    selectButton.frame = CGRectMake(self.selectImage.left - 10 * WIDTH_NIT, self.selectImage.top - 10 * WIDTH_NIT, self.selectImage.width + 20 * WIDTH_NIT, self.selectImage.height + 20 * WIDTH_NIT);
    [selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *gaiquLabel = [[UILabel alloc] initWithFrame:CGRectMake(gouView.right + 10 * WIDTH_NIT, gouView.top, 50, gouView.height)];
    [self.view addSubview:gaiquLabel];
    gaiquLabel.text = @"手动改曲";
    gaiquLabel.textColor = HexStringColor(@"#535353");
    gaiquLabel.font = NORML_FONT(12);
    
}

#pragma mark - Action
- (void)createSongButtonAction:(UIButton *)sender {
    
    // 每次点击这个按钮将tag置空
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.song_tag = @"";
    
    // 风格界面，制作歌曲
    [MobClick event:@"style_createSong"];
    
    if (self.source == 1 || self.source == 2) {
        [TYCommonClass sharedTYCommonClass].songType = manSong;
    } else {
        [TYCommonClass sharedTYCommonClass].songType = womanSong;
    }
    PlayViewController *pvc = [PlayViewController sharePlayVC];
    pvc.emotion = self.emotion;
    pvc.genere = self.genere;
    
    NSLog(@"source  -----   %d", self.source);
    
    
    pvc.source = self.source;
    pvc.songSpeed = self.rate;
    [pvc removeOldTyView];
    
    // 选风格
    [MobClick event:[NSString stringWithFormat:@"play_style%d", self.genere]];
    // 选心情
    if (self.emotion == 0) {
        [MobClick event:@"play_mood_happy"];
    } else {
        [MobClick event:@"play_mood_sad"];
    }
    // 选歌手
    [MobClick event:[NSString stringWithFormat:@"play_singer%d", self.source]];

    app.songSinger = [NSString stringWithFormat:@"-%d", self.source];
    
    if (self.selectImage.hidden) {
        [pvc changeBtnType:XL_BTN_TYPE];
    } else {
        [pvc changeBtnType:TY_BTN_TYPE];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"loading"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"fastMode" forKey:@"musicMode"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    [self.navigationController pushViewController:[PlayViewController sharePlayVC] animated:YES];
}

// 是否改曲
- (void)selectButtonAction:(UIButton *)sender {
    self.selectImage.hidden = !self.selectImage.hidden;
}

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPickViewDataSource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    
    NSArray *moodArray = @[@"高兴icon", @"悲伤icon"];
    NSArray *songType = @[@"流行icon", @"摇滚icon", @"民谣icon", @"电子icon"];
    NSArray *singer = @[@"萝莉icon", @"暖男icon", @"正太icon", @"娃娃icon", @"御姐icon"];
    
    UIView *pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 107.5 * WIDTH_NIT, 51 * WIDTH_NIT)];
//    pView.backgroundColor = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40 * WIDTH_NIT, 51 * WIDTH_NIT)];
    imageView.center = CGPointMake(pView.width / 2, pView.height / 2);
    [pView addSubview:imageView];
    
    if (component == 0) {
        imageView.image = [UIImage imageNamed:moodArray[row%2]];
    } else if (component == 1) {
        imageView.image = [UIImage imageNamed:songType[row%4]];
    } else {
        imageView.image = [UIImage imageNamed:singer[row%5]];
    }
    
    return pView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 107.5 * WIDTH_NIT;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 70 * WIDTH_NIT;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 2000;
    } else if (component == 1) {
        return 4000;
    }
    return 5000;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.emotion = row%2;
    } else if (component == 1) {
        self.genere = row%4;
    } else {
        self.source = row%5;
        if (self.source == 4) {
            self.source = 5;
        } else if (self.source == 0) {
            self.source = 6;
        }
    }
    NSLog(@"%d---%d---%d---%d---%ld", component, row, self.emotion, self.genere, self.source);
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
