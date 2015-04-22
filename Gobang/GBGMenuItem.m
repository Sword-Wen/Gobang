//
//  GBGMenuItem.m
//  Gobang
//
//  Created by franklyn on 15/4/22.
//  Copyright (c) 2015年 Cat Studio. All rights reserved.
//

#import "GBGMenuItem.h"

@implementation GBGMenuItem

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate clickStartBtn];
}

@end
