//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XOpenAL.h"
#import "AppDelegate.h"

@implementation XOpenAL
ALCcontext *context;
ALCdevice *device;

static BOOL isDisposed = false;

//初始化设备
+ (void)xInit {
    isDisposed = false;
    
    
    
//    AppDelegate *app = [[UIApplication sharedApplication] delegate];
//    if (!app.deviceIsReady) {
    
        device = alcOpenDevice((ALCchar*)ALC_DEFAULT_DEVICE_SPECIFIER);
        if (device == NULL)
        {
            NSLog(@"No device");
        }
        //Create a context
        context=alcCreateContext(device,NULL);
        
        //Set active context
        alcMakeContextCurrent(context);
        
        // Clear Error Code
        alGetError();

//        app.deviceIsReady = YES;
//    }
}

+ (void)backGround {
    NSLog(@"backGround");
    alcMakeContextCurrent(NULL);
}

+ (void)active {
    NSLog(@"Active");
//    AudioSessionSetActiveWithFlags(FALSE, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
    AudioSessionSetActive(true);
    alcMakeContextCurrent(context);
}

//关闭设备
+ (void)xDispose{
    isDisposed = true;
    
    context=alcGetCurrentContext();
    
    //Get device for active context
    device=alcGetContextsDevice(context);
    
    //Disable context
    alcMakeContextCurrent(NULL);
    
    //Release context(s)
    alcDestroyContext(context);
    
    //Close device
    alcCloseDevice(device);
}
@end
