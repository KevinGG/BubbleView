//
//  Timeline.m
//  Test
//
//  Created by KangNing on 7/9/15.
//  Copyright (c) 2015 iAK. All rights reserved.
//

#import "Timeline.h"

@implementation Timeline{
    int queueIndex;
}

- (id)init{
    self = [super init];
    if(self){
        queueIndex = 0;
        _timeline = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)setNextDelay:(NSTimeInterval)delay{
    NSNumber *aDelay = [[NSNumber alloc]initWithDouble:delay];
    [_timeline addObject:aDelay];
}

- (NSTimeInterval)nextDelay{
    NSNumber *nextDelay = [_timeline objectAtIndex:queueIndex];
    queueIndex++;
    queueIndex%=[_timeline count];
    return [nextDelay doubleValue];
}

- (void)resetIndex{
    queueIndex = 0;
}

@end
