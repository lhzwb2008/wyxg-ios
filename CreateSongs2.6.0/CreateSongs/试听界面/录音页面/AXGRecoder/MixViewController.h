//
//  MixViewController.h
//  AXGMixVoice
//
//  Created by axg on 16/7/4.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AEAudioController;

@interface MixViewController : UITableViewController

- (instancetype)initWIthAudioController:(AEAudioController *)audioController;

@end
