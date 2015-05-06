//
//  GBGLeftPane.h
//  Gobang
//
//  Created by franklyn on 15/4/21.
//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GBGMenuItem.h"
#import "GBGChessNode.h"

@interface GBGLeftPane : SKSpriteNode
{
@private
    GBGMenuItem *miStart;
    GBGMenuItem *miSetting;
    GBGChessNode *whiteChessPad;
    GBGChessNode *redChessPad;
}

-(void)setStartBtnDelegate:(id<GBGMenuBtnDelegate>)delegate;
-(void)setStartBtnTitle;
-(void)setEndBtnTitle;
-(void)showWhiteChessPad;
-(void)showRedChessPad;
-(void)showNoneChessPad;

-(void)setSettingBtnDelegate:(id<GBGMenuBtnDelegate>)delegate;

@end // GBGLeftPane
