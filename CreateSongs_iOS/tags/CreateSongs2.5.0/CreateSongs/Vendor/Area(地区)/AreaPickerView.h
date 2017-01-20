//
//  AreaPickerView.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/6/29.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AreaInfoBlock)(NSString *province, NSString *city, NSString *area);

@interface AreaPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSMutableArray *rootArr;

@property (nonatomic, strong) NSMutableArray *provinceArr;

@property (nonatomic, strong) NSMutableArray *cityArr;

@property (nonatomic, strong) NSMutableArray *areaArr;

@property (nonatomic, strong) NSMutableArray *arraySelected;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) AreaInfoBlock areaInfoBlock;

@end
