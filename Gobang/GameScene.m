//
//  GameScene.m
//  Gobang
//
//  Created by franklyn on 15/4/15.
//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import "GameScene.h"

static const uint32_t gbgBorderCategory = 0x01 << 0;
static const uint32_t gbgChessPieceCategory = 0x01 << 1;

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
@property int currentColumn;
@property BOOL isFalling;

@end // GameScene ()


@implementation GameScene

int chessPieceNumOfPerPipe[GBG_MAX_COLUMN_NUMBER] = {0};
GBChessPieceColor statusMap[GBG_MAX_COLUMN_NUMBER][GBG_MAX_ROW_NUMBER] = {noneColor};

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"enter didBeginContact Func");
    self.isFalling = FALSE;
    int row = chessPieceNumOfPerPipe[self.currentColumn]-1;
    if ([self isSuccessWithColumn:self.currentColumn Row:row withColor:statusMap[self.currentColumn][row]]) {
        NSLog(@"Success at %i, %d", self.currentColumn+1, row+1);
    }
}

-(void)clickStartBtn
{
    NSLog(@"enter clickStartBtn method:");
    [self resetScene];
}

-(void)resetScene
{
    [self enumerateChildNodesWithName:@"white" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"red" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    for (int i = 0; i < GBG_MAX_COLUMN_NUMBER; i++) {
        chessPieceNumOfPerPipe[i] = 0;
    }
    
    for (int i = 0; i < GBG_MAX_COLUMN_NUMBER; i++) {
        for (int j = 0; j < GBG_MAX_ROW_NUMBER; j++) {
            statusMap[i][j] = noneColor;
        }
    }
    
    self.row = GBG_MAX_ROW_NUMBER;
    self.column = GBG_MAX_COLUMN_NUMBER;
    self.nextColorType = whiteColor;
    self.currentColumn = 0;
    self.isFalling = FALSE;
}

-(void)appendChessPieceWithColumn:(int)column
{
    if ((column > self.column - 1) || chessPieceNumOfPerPipe[column] >= self.row){
        return;
    }
    if (self.isFalling == TRUE)
        return;
    
    self.isFalling = TRUE;
    chessPieceNumOfPerPipe[column]++;
    
    SKSpriteNode * testNode = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(self.widthOfPipe * 0.9, self.widthOfPipe * 0.9)];
    testNode.position = CGPointMake([self getMidXOfPipe:column], self.size.height * 0.9);
    if (self.nextColorType == whiteColor) {
        testNode.color = [SKColor whiteColor];
        testNode.name = @"white";
        self.nextColorType = redColor;
    }
    else if (self.nextColorType == redColor){
        testNode.color = [SKColor redColor];
        testNode.name = @"red";
        self.nextColorType = whiteColor;
    }
    testNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:testNode.size];
    testNode.physicsBody.dynamic = YES;
    testNode.physicsBody.categoryBitMask = gbgChessPieceCategory;
    testNode.physicsBody.collisionBitMask = gbgChessPieceCategory | gbgBorderCategory;
    testNode.physicsBody.contactTestBitMask = gbgChessPieceCategory | gbgBorderCategory;
    testNode.physicsBody.restitution = 0.0f;
    [self addChild:testNode];

    int row = chessPieceNumOfPerPipe[column]-1;
    if (self.nextColorType == whiteColor) {
        statusMap[column][row] = redColor;
    }
    else if (self.nextColorType == redColor){
        statusMap[column][row] = whiteColor;
    }
    self.currentColumn = column;
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
        pipeNode.physicsBody.categoryBitMask = gbgBorderCategory;
        pipeNode.physicsBody.collisionBitMask = gbgChessPieceCategory;
        pipeNode.physicsBody.contactTestBitMask = gbgChessPieceCategory;
        pipeNode.physicsBody.restitution = 0.0f;
        [self addChild:pipeNode];
    }
}

-(void)createLeftPane
{
    GBGLeftPane *leftPane = [[GBGLeftPane alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(self.spaceOfLeft, self.size.height)];
    leftPane.anchorPoint = CGPointMake(0, 0);
    leftPane.position = CGPointMake(0, 0);
    [self addChild:leftPane];
    [leftPane setStartBtnDelegate:self];
}

-(void)didMoveToView:(SKView *)view
{
    
    if (!self.contentCreated) {
        /* set number of rows and columns */
        self.row = GBG_MAX_ROW_NUMBER;
        self.column = GBG_MAX_COLUMN_NUMBER;
        self.nextColorType = whiteColor;
        self.physicsWorld.contactDelegate = self;
        self.currentColumn = 0;
        self.isFalling = FALSE;
        
        /* Created border here here */
        [self createPipes];
        
        /* Created the left pane in the game scene */
        [self createLeftPane];
        
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
