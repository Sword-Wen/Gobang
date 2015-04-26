//
//  GameScene.h
//  Gobang
//

//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GBGLeftPane.h"
#import "GBGChessNode.h"

#define GBG_MAX_ROW_NUMBER 6
#define GBG_MAX_COLUMN_NUMBER 7
#define GBG_MAX_DEEP 5  /* begin from 0 */

typedef enum : int {
    noneColor = 0,
    whiteColor,
    redColor
} GBChessPieceColor;

typedef struct{
    int column;
    int row;
}GBGPosition;

@interface GameScene : SKScene <SKPhysicsContactDelegate, GBGStartBtnDelegate>
{
@private
    BOOL isStarting;
    SKTexture *greenChessTexture;
    SKTexture *redChessTexture;
    NSMutableArray *succChess;
}


@end
