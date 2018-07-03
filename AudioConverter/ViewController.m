//
//  ViewController.m
//  AudioConverter
//
//  Created by admin on 2018/6/20.
//  Copyright © 2018年 owen. All rights reserved.
//

#import "ViewController.h"
#import "HTAudioConverter.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *m4aBtn;
@property (nonatomic, strong) UIButton *mp3Btn;
@property (nonatomic, strong) UILabel *statusLab;

@end

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

- (void)configUI{
    self.m4aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.m4aBtn.frame = CGRectMake(50, 100, ScreenWidth -100, 50);
    [self.view addSubview:self.m4aBtn];
    self.m4aBtn.backgroundColor = [UIColor redColor];
    [self.m4aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.m4aBtn setTitle:@"Convert to M4A" forState:UIControlStateNormal];
    [self.m4aBtn addTarget:self action:@selector(convertMP4ToM4A) forControlEvents:UIControlEventTouchUpInside];
    // Please import an video first before use this fuction
    self.m4aBtn.enabled = NO;
    
    self.mp3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mp3Btn.frame = CGRectMake(50, 180, ScreenWidth -100, 50);
    [self.view addSubview:self.mp3Btn];
    self.mp3Btn.backgroundColor = [UIColor redColor];
    [self.mp3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mp3Btn setTitle:@"Convert to MP3" forState:UIControlStateNormal];
    [self.mp3Btn addTarget:self action:@selector(convertM4AToMP3) forControlEvents:UIControlEventTouchUpInside];
    
    self.statusLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 250, ScreenWidth -40, 80)];
    [self.view addSubview:self.statusLab];
    self.statusLab.font = [UIFont systemFontOfSize:14];
    self.statusLab.textColor = [UIColor redColor];
    self.statusLab.textAlignment = NSTextAlignmentCenter;
    self.statusLab.numberOfLines = 0;
}

#pragma mark- Action
- (void)convertMP4ToM4A{
    self.statusLab.text = @"Converting...";
    
    NSString *inputPath = [[NSBundle mainBundle] pathForResource:@"Delicate" ofType:@"mp4"];
    NSURL *outputURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"output_m4a.m4a"];
    NSString *outputPath = outputURL.path;
    
    [HTAudioConverter extractAudiofromVideoWithPath:inputPath toNewPath:outputPath completionHandler:^(NSString *error) {
        if (error) {
            NSLog(@"%@",error);
            self.statusLab.text = @"It failed!";
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLab.text = @"It worked!";
            
            AVPlayer *player = [AVPlayer playerWithURL:outputURL];
            AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
            vc.player = player;
            [self presentViewController:vc animated:YES completion:^{
                [player play];
            }];
        });
        
    }];
}
- (void)convertM4AToMP3{
    self.statusLab.text = @"Converting...\nConvet to MP3 will take longer time than M4A";
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // 异步追加任务
        NSString *inputPath = [[NSBundle mainBundle] pathForResource:@"delicate" ofType:@"m4a"];
        NSURL *outputURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"output_mp3.mp3"];
        NSString *outputPath = outputURL.path;
        
        [HTAudioConverter convertM4a:inputPath toMp3:outputPath completionHandler:^(NSString *error) {
            if (error) {
                NSLog(@"%@",error);
                self.statusLab.text = @"It failed!";
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLab.text = @"It worked!";
                
                AVPlayer *player = [AVPlayer playerWithURL:outputURL];
                AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
                vc.player = player;
                [self presentViewController:vc animated:YES completion:^{
                    [player play];
                }];
            });
            
        }];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
