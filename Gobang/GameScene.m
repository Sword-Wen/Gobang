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

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if (self.isFalling == FALSE) {
        return;
    }
    
    self.isFalling = FALSE;
    int row = chessPieceNumOfPerPipe[self.currentColumn]-1;

    if ([self isWinWithColumn:self.currentColumn Row:row Color:statusMap[self.currentColumn][row] Depth:GBG_MAX_DEEP]) {
        NSLog(@"Success at %i, %i.", self.currentColumn + 1, row + 1);
        [self doneSuccess];
    }
    else{
        switch (self.nextColorType) {
            case whiteColor:
                [(GBGLeftPane*)[self childNodeWithName:@"leftpane"] showWhiteChessPad];
                break;
                
            case redColor:
                [(GBGLeftPane*)[self childNodeWithName:@"leftpane"] showRedChessPad];
                break;
                
            default:
                [(GBGLeftPane*)[self childNodeWithName:@"leftpane"] showNoneChessPad];
                break;
        }
    }
}

-(void)doneSuccess
{
    GBGPosition posChess;
    for (NSValue *posChessVaule in succChess) {
        [posChessVaule getValue:&posChess];
        
        /*  */
        [self enumerateChildNodesWithName:@"white" usingBlock:^(SKNode *node, BOOL *stop) {
            GBGChessNode *tmpChess = (GBGChessNode*)node;
            if ((tmpChess.column == posChess.column) && (tmpChess.row == posChess.row)) {
                SKAction *fadeout = [SKAction fadeOutWithDuration:0.5];
                SKAction *fadein = [SKAction fadeInWithDuration:0.5];
                SKAction *plus = [SKAction sequence:@[fadeout,fadein]];
                [tmpChess runAction:[SKAction repeatActionForever:plus]];
            }
        }];
        
        [self enumerateChildNodesWithName:@"red" usingBlock:^(SKNode *node, BOOL *stop) {
            GBGChessNode *tmpChess = (GBGChessNode*)node;
            if ((tmpChess.column == posChess.column) && (tmpChess.row == posChess.row)) {
                SKAction *fadeout = [SKAction fadeOutWithDuration:0.5];
                SKAction *fadein = [SKAction fadeInWithDuration:0.5];
                SKAction *plus = [SKAction sequence:@[fadeout,fadein]];
                [tmpChess runAction:[SKAction repeatActionForever:plus]];
            }
        }];
    }
    
    isStarting = FALSE;
    [(GBGLeftPane*)[self childNodeWithName:@"leftpane"] setStartBtnTitle];
}

-(void)clickMenuBtn:(GBGMenuItemType)miType
{
    switch (miType) {
        case gbgMiStart:
            [self clickStartMenuBtn];
            break;
            
        case gbgMiSetting:
            [self clickSettingMenuBtn];
            break;
            
        default:
            break;
    }
}

-(void)clickStartMenuBtn
{
    if (!isStarting) {
        [self resetScene];
        isStarting =TRUE;
        [(GBGLeftPane*)[self childNodeWithName:@"leftpane"] setEndBtnTitle];
        [(GBGLeftPane*)[self childNodeWithName:@"leftpane"] showWhiteChessPad];
    }
    else{
        isStarting = FALSE;
        [(GBGLeftPane*)[self childNodeWithName:@"leftpane"] setStartBtnTitle];
        [(GBGLeftPane*)[self childNodeWithName:@"leftpane"] showNoneChessPad];
    }
}

-(void)clickSettingMenuBtn
{
    NSLog(@"Clicked setting menu.");
}

-(void)resetData
{
    self.row = GBG_MAX_ROW_NUMBER;
    self.column = GBG_MAX_COLUMN_NUMBER;
    self.nextColorType = whiteColor;
    self.currentColumn = 0;
    self.isFalling = FALSE;
    isStarting = FALSE;
    
    for (int i = 0; i < GBG_MAX_COLUMN_NUMBER; i++) {
        chessPieceNumOfPerPipe[i] = 0;
    }
    
    for (int i = 0; i < GBG_MAX_COLUMN_NUMBER; i++) {
        for (int j = 0; j < GBG_MAX_ROW_NUMBER; j++) {
            statusMap[i][j] = noneColor;
        }
    }
    
    if (!succChess) {
        succChess = [NSMutableArray arrayWithCapacity:GBG_MAX_DEEP+1];
    }
    [succChess removeAllObjects];
}

-(void)resetScene
{
    /* Remove all chess pad. */
    [self enumerateChildNodesWithName:@"white" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"red" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    /* Reset all data. */
    [self resetData];
}

-(void)appendChessPadWithColumn:(int)column
{
    if (!isStarting) {
        return;
    }
    if ((column > self.column - 1) || chessPieceNumOfPerPipe[column] >= self.row){
        return;
    }
    if (self.isFalling == TRUE)
        return;
    
    self.isFalling = TRUE;
    chessPieceNumOfPerPipe[column]++;

    /* Create a chess node. */
    GBGChessNode *testNode = NULL;
    if (self.nextColorType == whiteColor) {
        testNode = [GBGChessNode spriteNodeWithTexture:greenChessTexture size:CGSizeMake(self.widthOfPipe * 0.9, self.widthOfPipe * 0.9)];
        testNode.name = @"white";
        self.nextColorType = redColor;
    }
    else if (self.nextColorType == redColor){
        testNode = [GBGChessNode spriteNodeWithTexture:redChessTexture size:CGSizeMake(self.widthOfPipe * 0.9, self.widthOfPipe * 0.9)];
        testNode.name = @"red";
        self.nextColorType = whiteColor;
    }
    testNode.position = CGPointMake([self getMidXOfPipe:column], self.size.height * 0.9);
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
        testNode.column = column;
        testNode.row =row;
    }
    else if (self.nextColorType == redColor){
        statusMap[column][row] = whiteColor;
        testNode.column = column;
        testNode.row = row;
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

-(void)appendSuccChessPosWithColumn:(int)column Row:(int)row
{
    GBGPosition pos;
    pos.column = column;
    pos.row = row;
    NSValue *posValue = [NSValue valueWithBytes:&pos objCType:@encode(GBGPosition)];
    [succChess addObject:posValue];
}

-(BOOL)isWinWithColumn:(int)column Row:(int)row Color:(GBChessPieceColor)colorType Depth:(int)depth
{
    BOOL result = FALSE;
    int sColumn = 0;
    int sRow = 0;
    
    
    /* Check at first of direction. */
    for (sColumn = column, sRow = 0; sRow <= GBG_MAX_ROW_NUMBER - depth; sRow++) {
        result = TRUE;
        for (int j = sRow, count = 0; count < depth; j++, count++) {
            if (statusMap[sColumn][j] != colorType) {
                result = FALSE;
                break;
            }
            else{
                [self appendSuccChessPosWithColumn:sColumn Row:j];
            }
        }
        if (result == TRUE) {
            return TRUE;
        }
        [succChess removeAllObjects];
    }
    
    /* Check at second of direction. */
    for (sColumn = column, sRow = row; ((sColumn > 0) && (sRow > 0)); sColumn--, sRow--){
    }
    for (int i = sColumn, j = sRow; ((i < GBG_MAX_COLUMN_NUMBER - depth + 1) && (j < GBG_MAX_ROW_NUMBER - depth + 1)); i++,j++) {
        result = TRUE;
        for (int x = i, y = j, count = 0; count < depth; x++, y++, count++) {
            if (statusMap[x][y] != colorType) {
                result = FALSE;
                break;
            }
            else{
                [self appendSuccChessPosWithColumn:x Row:y];
            }
        }
        if (result == TRUE) {
            return TRUE;
        }
        [succChess removeAllObjects];
    }
    
    /* Check at third of direction.  */
    for (sColumn = 0, sRow = row; sColumn < GBG_MAX_COLUMN_NUMBER - depth + 1; sColumn++) {
        result = TRUE;
        for (int j = sColumn, count = 0; count < depth; j++, count++) {
            if (statusMap[j][sRow] != colorType) {
                result = FALSE;
                break;
            }
            else{
                [self appendSuccChessPosWithColumn:j Row:sRow];
            }
        }
        if (result == TRUE) {
            return TRUE;
        }
        [succChess removeAllObjects];
    }
    
    /* Check at fourth of direction. */
    for (sColumn = column, sRow = row; ((sColumn > 0) && (sRow < GBG_MAX_ROW_NUMBER - 1)); sColumn--, sRow++){
    }
    for (int i = sColumn, j = sRow; ((i < GBG_MAX_COLUMN_NUMBER - depth + 1) && (j >= depth - 1)); i++,j--) {
        result = TRUE;
        for (int x = i, y = j; x < (i + depth); x++, y--) {
            if (statusMap[x][y] != colorType) {
                result = FALSE;
                break;
            }
            else{
                [self appendSuccChessPosWithColumn:x Row:y];
            }
        }
        if (result == TRUE) {
            return TRUE;
        }
        [succChess removeAllObjects];
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
    leftPane.name = @"leftpane";
    leftPane.anchorPoint = CGPointMake(0, 0);
    leftPane.position = CGPointMake(0, 0);
    [self addChild:leftPane];
    [leftPane setStartBtnDelegate:self];
    [leftPane setSettingBtnDelegate:self];
}

-(void)createRightPane
{
    GBGRightPane *rightPane = [[GBGRightPane alloc] initWithColor:[SKColor purpleColor] size:CGSizeMake(self.spaceOfRight, self.size.height)];
    rightPane.name = @"rightpane";
    rightPane.anchorPoint = CGPointMake(0, 0);
    rightPane.position = CGPointMake(self.spaceOfLeft + self.widthOfPipe*GBG_MAX_COLUMN_NUMBER, 0);
    [self addChild:rightPane];
}

-(void)didMoveToView:(SKView *)view
{
    
    if (!self.contentCreated) {
        /* set number of rows and columns */
        [self resetData];
        
        /* Created border here here */
        [self createPipes];
        
        /* Created the left pane in the game scene */
        [self createLeftPane];
        
        /* Created the right pane in the game scene */
        [self createRightPane];
        
        /* Created a green and a red chess texture. */
        greenChessTexture = [SKTexture textureWithImageNamed:@"greenChess"];
        redChessTexture = [SKTexture textureWithImageNamed:@"redChess"];
        
        self.physicsWorld.contactDelegate = self;
        
        self.contentCreated = YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        [self appendChessPadWithColumn:[self touchInPipe:touch]];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
