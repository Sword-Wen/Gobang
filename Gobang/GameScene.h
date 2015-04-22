//
//  GameScene.h
//  Gobang
//

//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GBGLeftPane.h"

#define GBG_MAX_ROW_NUMBER 6
#define GBG_MAX_COLUMN_NUMBER 7
#define GBG_MAX_DEEP 2  /* begin from 0 */

typedef enum : int {
    noneColor = 0,
    whiteColor,
    redColor
} GBChessPieceColor;

@interface GameScene : SKScene <SKPhysicsContactDelegate, GBGStartBtnDelegate>


@end
