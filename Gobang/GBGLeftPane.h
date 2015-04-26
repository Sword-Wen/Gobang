//
//  GBGLeftPane.h
//  Gobang
//
//  Created by franklyn on 15/4/21.
//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GBGMenuItem.h"

@interface GBGLeftPane : SKSpriteNode
{
@private
    GBGMenuItem *startGame;
}

-(void)setStartBtnDelegate:(id<GBGStartBtnDelegate>)delegate;
-(void)setStartBtnTitle;
-(void)setEndBtnTitle;

@end
