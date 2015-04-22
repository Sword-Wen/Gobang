//
//  GBGMenuItem.h
//  Gobang
//
//  Created by franklyn on 15/4/22.
//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol GBGStartBtnDelegate <NSObject>

-(void)clickStartBtn;

@end // GBGStartBtnDelegate

@interface GBGMenuItem : SKLabelNode

@property id<GBGStartBtnDelegate> delegate;

@end
