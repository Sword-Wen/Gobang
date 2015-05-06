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
        /* Create start menu item in left pane. */
        miStart = [GBGMenuItem labelNodeWithFontNamed:@"Chalkduster"];
        miStart.text = @"Start Game";
        miStart.fontSize = 35;
        miStart.fontColor = [SKColor blackColor];
        miStart.position = CGPointMake(self.size.width / 2, self.size.height*0.85);
        miStart.userInteractionEnabled = YES;
        miStart.miType = gbgMiStart;
        [self addChild:miStart];
        
        /* Create setting menu item in left pane. */
        miSetting = [GBGMenuItem labelNodeWithFontNamed:@"Chalkduster"];
        miSetting.text = @"Setting";
        miSetting.fontSize = 35;
        miSetting.fontColor = [SKColor blackColor];
        miSetting.position = CGPointMake(self.size.width / 2, self.size.height*0.75);
        miSetting.userInteractionEnabled = YES;
        miSetting.miType = gbgMiSetting;
        [self addChild:miSetting];
        
        /* Create indication chess pad. */
        SKTexture *whiteTexture = [SKTexture textureWithImageNamed:@"greenChess"];
        whiteChessPad = [GBGChessNode spriteNodeWithTexture:whiteTexture size:CGSizeMake(self.size.width * 0.6, self.size.width * 0.6)];
        whiteChessPad.position = CGPointMake(self.size.width / 2, self.size.width / 2);
        whiteChessPad.hidden = TRUE;
        [self addChild:whiteChessPad];
        
        SKTexture *redTexture = [SKTexture textureWithImageNamed:@"redChess"];
        redChessPad = [GBGChessNode spriteNodeWithTexture:redTexture size:CGSizeMake(self.size.width * 0.6, self.size.width * 0.6)];
        redChessPad.position = CGPointMake(self.size.width / 2, self.size.width / 2);
        redChessPad.hidden = TRUE;
        [self addChild:redChessPad];
    }
    return self;
}

-(void)setStartBtnDelegate:(id<GBGMenuBtnDelegate>)delegate
{
    miStart.delegate = delegate;
}

-(void)setSettingBtnDelegate:(id<GBGMenuBtnDelegate>)delegate
{
    miSetting.delegate = delegate;
}

-(void)setStartBtnTitle
{
    if (miStart != nil) {
        miStart.text = @"Start Game";
    }
}

-(void)setEndBtnTitle
{
    if (miStart != nil) {
        miStart.text = @"End Game";
    }
}

-(void)showWhiteChessPad
{
    whiteChessPad.hidden = FALSE;
    redChessPad.hidden = TRUE;
}

-(void)showRedChessPad
{
    whiteChessPad.hidden = TRUE;
    redChessPad.hidden = FALSE;
}

-(void)showNoneChessPad
{
    whiteChessPad.hidden = TRUE;
    redChessPad.hidden = TRUE;
}

@end
