//
//  MEVideoView.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MEVideoView.h"

#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface MEVideoView ()
@property (strong,nonatomic) AVPlayer *player;
@property (readonly,nonatomic) AVPlayerLayer *playerLayer;
@end

@implementation MEVideoView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setPlayer:[AVPlayer playerWithURL:[[NSBundle mainBundle] URLForResource:@"ed_1024_512kb.mp4" withExtension:nil]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_playerItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self.playerLayer setPlayer:self.player];
    
    [self.player play];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
    
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    
    @weakify(self);
    
    [tapGestureRecognizer.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        
        if (self.player.rate == 0)
            [self.player play];
        else
            [self.player pause];
    }];
    
    [self addGestureRecognizer:tapGestureRecognizer];
    
    return self;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

- (void)_playerItemDidPlayToEndTime:(NSNotification *)note {
    [self.player setRate:0];
    [self.player seekToTime:CMTimeMakeWithSeconds(0, 1)];
    [self.player play];
}

@end
