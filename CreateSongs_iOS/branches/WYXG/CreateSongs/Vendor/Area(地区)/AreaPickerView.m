//
//  AreaPickerView.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/6/29.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AreaPickerView.h"
#import "AXGHeader.h"

@implementation AreaPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createPicker];
    }
    return self;
}

- (void)createPicker {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
    self.rootArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    self.provinceArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.cityArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.areaArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.arraySelected = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 获取数据
    [self.rootArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.provinceArr addObject:obj[@"state"]];
    }];
    
    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.rootArr firstObject][@"cities"]];
    [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.cityArr addObject:obj[@"city"]];
    }];
    
    self.areaArr = [citys firstObject][@"area"];
    
    self.province = self.provinceArr[0];
    self.city = self.cityArr[0];
    if (self.areaArr.count != 0) {
        self.area = self.areaArr[0];
    }else{
        self.area = @"";
    }
    
    self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    [self addSubview:self.picker];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArr.count;
    } else if (component == 1) {
        return self.cityArr.count;
    }
    return self.areaArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.arraySelected = self.rootArr[row][@"cities"];
        
        [self.cityArr removeAllObjects];
        [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.cityArr addObject:obj[@"city"]];
        }];
        
        self.areaArr = [NSMutableArray arrayWithArray:[self.arraySelected firstObject][@"areas"]];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component == 1) {
        if (self.arraySelected.count == 0) {
            self.arraySelected = [self.rootArr firstObject][@"cities"];
        }
        
        self.areaArr = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:row][@"areas"]];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else{
        
    }
    
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    NSString *text;
    if (component == 0) {
        text = self.provinceArr[row];
    }else if (component == 1){
        text = self.cityArr[row];
    }else{
        if (self.areaArr.count > 0) {
            text = self.areaArr[row];
        }else{
            text = @"";
        }
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:NORML_FONT(16)];
    [label setText:text];
    return label;
    
}

- (void)reloadData
{
    NSInteger index0 = [self.picker selectedRowInComponent:0];
    NSInteger index1 = [self.picker selectedRowInComponent:1];
    NSInteger index2 = [self.picker selectedRowInComponent:2];
    self.province = self.provinceArr[index0];
    self.city = self.cityArr[index1];
    if (self.areaArr.count != 0) {
        self.area = self.areaArr[index2];
    }else{
        self.area = @"";
    }
    
    if (self.areaInfoBlock) {
        self.areaInfoBlock(self.province, self.city, self.area);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
