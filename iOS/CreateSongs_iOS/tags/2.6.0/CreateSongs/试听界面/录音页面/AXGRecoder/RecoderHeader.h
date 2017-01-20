//
//  RecoderHeader.h
//  CreateSongs
//
//  Created by axg on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#ifndef RecoderHeader_h
#define RecoderHeader_h
// 获取伴奏
#define GET_WAV_MP3 @"http://service.woyaoxiege.com/music/accmp3/%@.mp3"
// 上传录音文件
#define UPLOAD_RECODER  @"http://service.woyaoxiege.com/core/home/index/upload_song"

// 换伴奏
#define CHANG_BG_MUSIC  @"http://service.woyaoxiege.com/core/home/index/call_acc?content=%@&name=%@&genre=%ld&emotion=%ld&rate=%.1f"
/*
 http:// service.woyaoxiege.com/core/home/index/call_acc?content=%@&name=%@&genre=%ld&emotion=%ld&rate=%f
 */

#endif /* RecoderHeader_h */
