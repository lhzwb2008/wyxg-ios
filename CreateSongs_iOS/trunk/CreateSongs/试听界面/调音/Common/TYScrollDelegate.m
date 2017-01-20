
//
//  TYScrollDelegate.m
//  SentenceMidiView
//
//  Created by axg on 16/5/30.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "TYScrollDelegate.h"

@implementation TYScrollDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tyScrollBlock) {
        self.tyScrollBlock(scrollView.contentOffset.x);
    }
}

@end
