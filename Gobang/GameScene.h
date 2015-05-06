//
//  GameScene.h
//  Gobang
//

//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GBGLeftPane.h"
#import "GBGRightPane.h"
#import "GBGChessNode.h"

#define GBG_MAX_ROW_NUMBER 8
#define GBG_MAX_COLUMN_NUMBER 10
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

@interface GameScene : SKScene <SKPhysicsContactDelegate, GBGMenuBtnDelegate>
{
@private
    BOOL isStarting;
    SKTexture *greenChessTexture;
    SKTexture *redChessTexture;
    NSMutableArray *succChess;
    int chessPieceNumOfPerPipe[GBG_MAX_COLUMN_NUMBER];
    GBChessPieceColor statusMap[GBG_MAX_COLUMN_NUMBER][GBG_MAX_ROW_NUMBER];
}


@end
