//
//  GBGLeftPane.m
//  Gobang
//
//  Created by franklyn on 15/4/21.
//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import "GBGLeftPane.h"

@implementation GBGLeftPane

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    if (self = [super initWithColor:color size:size]) {
        /* Created menu items in left pane. */
        startGame = [GBGMenuItem labelNodeWithFontNamed:@"Chalkduster"];
        startGame.text = @"Start Game";
        startGame.fontSize = 35;
        startGame.fontColor = [SKColor blackColor];
        startGame.position = CGPointMake(self.size.width / 2, self.size.height*0.8);
        startGame.userInteractionEnabled = YES;
        [self addChild:startGame];
    }
    return self;
}

-(void)setStartBtnDelegate:(id<GBGStartBtnDelegate>)delegate
{
    startGame.delegate = delegate;
}

@end
