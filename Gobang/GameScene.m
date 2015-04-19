//
//  GameScene.m
//  Gobang
//
//  Created by franklyn on 15/4/15.
//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
{
}

@property BOOL contentCreated;

@property int row;
@property int column;
@property (readonly) CGFloat spaceOfLeft;
@property (readonly) CGFloat spaceOfRight;
@property (readonly) CGFloat widthOfPipe;

@property GBChessPieceColor nextColorType;

@end


@implementation GameScene

int chessPieceNumOfPerPipe[] = {0};
GBChessPieceColor statusMap[GBG_MAX_COLUMN_NUMBER][GBG_MAX_ROW_NUMBER] = {noneColor};

-(void)appendChessPieceWithColumn:(int)column
{
    if ((column > self.column - 1) || chessPieceNumOfPerPipe[column] >= self.row){
        return;
    }
    chessPieceNumOfPerPipe[column]++;
    
    SKSpriteNode * testNode = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(self.widthOfPipe * 0.9, self.widthOfPipe * 0.9)];
    testNode.position = CGPointMake([self getMidXOfPipe:column], self.size.height * 0.9);
    if (self.nextColorType == whiteColor) {
        testNode.color = [SKColor whiteColor];
        testNode.name = @"white";
        self.nextColorType = redColor;
    }
    else{
        testNode.color = [SKColor redColor];
        testNode.name = @"red";
        self.nextColorType = whiteColor;
    }
    testNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:testNode.size];
    testNode.physicsBody.dynamic = YES;
    [self addChild:testNode];

    int row = chessPieceNumOfPerPipe[column]-1;
    if (self.nextColorType == whiteColor) {
        statusMap[column][row] = redColor;
    }
    else{
        statusMap[column][row] = whiteColor;
    }
    
    if ([self isSuccessWithColumn:column Row:row withColor:statusMap[column][row]]) {
        NSLog(@"Success at %i, %d", column+1, row+1);
    }
}

@dynamic widthOfPipe;
-(CGFloat)widthOfPipe
{
    CGFloat widthOfPipe = self.size.width / self.column;
    if ((self.size.height / widthOfPipe) < self.row) {
        widthOfPipe = self.size.height / self.row;
    }
    return widthOfPipe;
}

@dynamic spaceOfLeft;
-(CGFloat)spaceOfLeft
{
    return ((self.size.width - self.widthOfPipe * self.column) / 2);
}

@dynamic spaceOfRight;
-(CGFloat)spaceOfRight
{
    return ((self.size.width - self.widthOfPipe * self.column) / 2);
}

-(BOOL)isSuccessWithColumn:(int)column Row:(int)row withColor:(GBChessPieceColor)colorType
{
    int direction = 1;
    BOOL result = FALSE;
    while (!result && (direction <= 8)) {
        result = [self checkSuccessWithColumn:column Row:row direction:direction color:colorType deep:0];
        direction++;
    }
    
    return result;
}

-(BOOL)checkSuccessWithColumn:(int)column Row:(int)row direction:(int)direction color:(GBChessPieceColor)colorType deep:(int)deep
{
    bool result = FALSE;
    
    if (deep > GBG_MAX_DEEP) {
        return TRUE;
    }
    
    if ((column < 0) || (row < 0) || (column >= self.column) || (row >= self.row)) {
        return FALSE;
    }
    
    if (statusMap[column][row] != colorType) {
        return FALSE;
    }
    
    /* Check whether the next-level is success. */
    switch (direction) {
        case 1:
            result = [self checkSuccessWithColumn:column-1 Row:row+1 direction:1 color:colorType deep:deep+1];
            if ((!result) && (deep == 1)) {
                result = [self checkSuccessWithColumn:column+2 Row:row-2 direction:5 color:colorType deep:deep+1];
            }
            break;
        case 2:
            result = [self checkSuccessWithColumn:column Row:row+1 direction:2 color:colorType deep:deep+1];
            if ((!result) && (deep == 1)) {
                result = [self checkSuccessWithColumn:column Row:row-2 direction:6 color:colorType deep:deep+1];
            }
            break;
        case 3:
            result = [self checkSuccessWithColumn:column+1 Row:row+1 direction:3 color:colorType deep:deep+1];
            if ((!result) && (deep == 1)) {
                result = [self checkSuccessWithColumn:column-2 Row:row-2 direction:7 color:colorType deep:deep+1];
            }
            break;
        case 4:
            result = [self checkSuccessWithColumn:column+1 Row:row direction:4 color:colorType deep:deep+1];
            if ((!result) && (deep == 1)){
                result = [self checkSuccessWithColumn:column-2 Row:row direction:8 color:colorType deep:deep+1];
            }
            break;
        case 5:
            result = [self checkSuccessWithColumn:column+1 Row:row-1 direction:5 color:colorType deep:deep+1];
            if ((!result) && (deep == 1)) {
                result = [self checkSuccessWithColumn:column-2 Row:row+2 direction:1 color:colorType deep:deep+1];
            }
            break;
        case 6:
            result = [self checkSuccessWithColumn:column Row:row-1 direction:6 color:colorType deep:deep+1];
            if ((!result) && (deep == 1)) {
                result = [self checkSuccessWithColumn:column Row:row+2 direction:2 color:colorType deep:deep+1];
            }
            break;
        case 7:
            result = [self checkSuccessWithColumn:column-1 Row:row-1 direction:7 color:colorType deep:deep+1];
            if ((!result) && (deep == 1)) {
                result = [self checkSuccessWithColumn:column+2 Row:row+2 direction:3 color:colorType deep:deep+1];
            }
            break;
        case 8:
            result = [self checkSuccessWithColumn:column-1 Row:row direction:8 color:colorType deep:deep+1];
            if ((!result) && (deep == 1)) {
                result = [self checkSuccessWithColumn:column+2 Row:row direction:4 color:colorType deep:deep+1];
            }
            break;
            
        default:
            result = FALSE;
            break;
    }
    
    return result;
}

-(int)touchInPipe:(UITouch*) touch
{
    CGPoint touchPoint = [touch locationInNode:self];
    if (touchPoint.x < self.spaceOfLeft) {
        return 0xff;
    }
    
    int numPipe = (touchPoint.x - self.spaceOfLeft) / self.widthOfPipe;
    
    return numPipe;
}

-(CGFloat)getMidXOfPipe:(int)number
{
    if (number < 0) {
        return 0;
    }
    
    CGFloat midXOfPipe = self.spaceOfLeft + self.widthOfPipe * (number + 0.5);
    
    return midXOfPipe;
}

-(void)createPipes
{
    /* 根据列数设置管道 */
    for (int i = 0; i < self.column; i++) {
        SKShapeNode *pipeNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.widthOfPipe, self.size.height)];
        pipeNode.name = @"pipe";
        pipeNode.lineWidth = 1.0f;
        pipeNode.position = CGPointMake([self getMidXOfPipe:i], self.size.height / 2);
        pipeNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:pipeNode.path];
        [self addChild:pipeNode];
    }
}

-(void)didMoveToView:(SKView *)view
{
    
    if (!self.contentCreated) {
        /* set number of rows and columns */
        self.row = GBG_MAX_ROW_NUMBER;
        self.column = GBG_MAX_COLUMN_NUMBER;
        self.nextColorType = whiteColor;
        
        /* Created border here here */
        [self createPipes];
        
        self.contentCreated = YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        [self appendChessPieceWithColumn:[self touchInPipe:touch]];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
