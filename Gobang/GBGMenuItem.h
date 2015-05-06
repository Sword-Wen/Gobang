//
//  GBGMenuItem.h
//  Gobang
//
//  Created by franklyn on 15/4/22.
//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : int{
    gbgMiStart = 0,
    gbgMiSetting,
}GBGMenuItemType;

@protocol GBGMenuBtnDelegate <NSObject>

-(void)clickMenuBtn:(GBGMenuItemType) miType;

@end // GBGMenuBtnDelegate


@interface GBGMenuItem : SKLabelNode

@property GBGMenuItemType miType;
@property id<GBGMenuBtnDelegate> delegate;

@end // GBGMenuItem
