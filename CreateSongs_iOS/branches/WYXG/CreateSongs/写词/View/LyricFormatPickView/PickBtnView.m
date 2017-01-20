//
//  PickBtnView.m
//  CreateSongs
//
//  Created by axg on 16/6/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PickBtnView.h"
#import "UIColor+expanded.h"

@implementation PickBtnView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#b2b2b2"];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelected:)];
        
        [self addSubview:self.titleLabel];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}


- (void)setLightLevel:(NSInteger)lightLevel {
    _lightLevel = lightLevel;
    switch (_lightLevel) {
        case 0: {
            self.titleLabel.font = [UIFont systemFontOfSize:13];
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#b2b2b2"];
        }
            break;
        case 1: {
            self.titleLabel.font = [UIFont systemFontOfSize:13];
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }
            break;
        case 2: {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }
            break;
        default:
            break;
    }
}

- (void)didSelected:(UITapGestureRecognizer *)tgr {
    if (self.formatBlock) {
        self.formatBlock(self.index, self);
    }
}


@end
