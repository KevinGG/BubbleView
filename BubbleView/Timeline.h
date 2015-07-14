//
//  Timeline.h
//  Test
//
//  Created by KangNing on 7/9/15.
//  Copyright (c) 2015 iAK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timeline : NSObject

@property(strong) NSMutableArray* timeline;

- (void)setNextDelay:(NSTimeInterval)delay;
- (NSTimeInterval)nextDelay;
- (void)resetIndex;

@end
