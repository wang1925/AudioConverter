//
//  HTAudioConverter.m
//  YOLOMusic
//
//  Created by admin on 2018/4/3.
//  Copyright © 2018年 owen. All rights reserved.
//

#import "HTAudioConverter.h"

@implementation HTAudioConverter

// video -> M4a
+ (void)extractAudiofromVideoWithPath:(NSString *)srcPath toNewPath:(NSString *)destPath completionHandler:(void (^)(NSString *error))handler{
    NSLog(@"m4a convert start:%@",[NSDate date]);
    NSURL *videoURL = [NSURL fileURLWithPath:srcPath];
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];

    AVMutableComposition *newAudioAsset = [AVMutableComposition composition];

    AVMutableCompositionTrack *dstCompositionTrack;
    dstCompositionTrack = [newAudioAsset addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [dstCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                 ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];

    AVAssetExportSession *exportSesh = [[AVAssetExportSession alloc] initWithAsset:newAudioAsset presetName:AVAssetExportPresetAppleM4A];

    exportSesh.outputFileType = AVFileTypeAppleM4A;
    exportSesh.outputURL=[NSURL fileURLWithPath:destPath];

    [exportSesh exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus  status = exportSesh.status;
        NSLog(@"exportAsynchronouslyWithCompletionHandler: %li\n", (long)status);

        if(AVAssetExportSessionStatusFailed == status) {
            NSLog(@"m4a convert failure: %@\n", exportSesh.error);
            handler(exportSesh.error.localizedDescription);
        } else if(AVAssetExportSessionStatusCompleted == status) {
            NSLog(@"m4a convert success: %@",[NSDate date]);
            handler(nil);
            //            NSError *error;
        }
    }];
}
// m4a -> mp3
+ (void)convertM4a:(NSString *)m4aPath toMp3:(NSString *)mp3Path completionHandler:(void (^)(NSString *error))handler{
    NSLog(@"mp3 convert start: %@",[NSDate date]);
    ExtAudioConverter *converter = [[ExtAudioConverter alloc] init];
    converter.inputFilePath = m4aPath;
    converter.outputFilePath = mp3Path;
    converter.outputFormatID = kAudioFormatMPEGLayer3;
    if ([converter convert]) {
        NSLog(@"mp3 convert success: %@",[NSDate date]);
        handler(nil);
    }else {
        NSLog(@"mp3 convert failure: %@",[NSDate date]);
        handler(@"convert failure");
    }
}

@end
