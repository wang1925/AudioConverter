//
//  HTAudioConverter.h
//  YOLOMusic
//
//  Created by admin on 2018/4/3.
//  Copyright © 2018年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ExtAudioConverter.h"

@interface HTAudioConverter : NSObject
/*
 * video -> m4a
 */
+ (void)extractAudiofromVideoWithPath:(NSString *)srcPath toNewPath:(NSString *)destPath completionHandler:(void (^)(NSString *error))handler;
/*
 * m4a -> mp3
 */
+ (void)convertM4a:(NSString *)m4aPath toMp3:(NSString *)mp3Path completionHandler:(void (^)(NSString *error))handler;

@end
