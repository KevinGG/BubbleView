//
//  Bubble.h
//  Test
//
//  Created by KangNing on 7/8/15.
//  Copyright (c) 2015 iAK. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Rgb2UIColor(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]

@protocol BubbleDelegate <NSObject>

@optional
- (void)bubbleTap:(id)thisBubble;
//detect a collision
- (BOOL)detectCollideWith:(id)thisBubble;
//customize collide effects
- (void)onCollide:(id)thisBubble;
- (void)afterCollide:(id)thisBubble;
- (void)defaultCollide:(id)thisBubble;

@end

@interface Bubble : UIView

@property(strong, nonatomic)id<BubbleDelegate> bubbleDelegate;

@property(strong, nonatomic)NSString *title;

//behavior control
- (void)bubbleTapEnable;
- (void)bubbleTapDisable;
- (void)bubbleDragEnable;
- (void)bubbleDragDisable;
- (void)bubbleTraceBackDragEnable;
- (void)bubbleTraceBackDragDisable;
- (void)bubbleZoomEnable;
- (void)bubbleZoomDisable;
- (void)bubbleDefaultCollisionEnable;
- (void)bubbleDefaultCollisionDisable;
- (void)bubbleFloatEnable;
- (void)bubbleFloatDisable;

//return radius
- (CGFloat)radius;

//animations
- (void)bubbleMoveHorizontal:(CGFloat)unit left:(BOOL)left duration:(NSTimeInterval)duration;
- (void)bubbleMoveVertical:(CGFloat)unit up:(BOOL)up duration:(NSTimeInterval)duration;
- (void)bubbleMove:(CGPoint)vector;
- (void)bubbleMove:(CGPoint)vector duration:(NSTimeInterval)duration;
- (void)bubbleZoom:(CGFloat)times duration:(NSTimeInterval)duration;
- (void)bubbleShake;
- (void)bubbleFadeIn;
- (void)bubbleFlip;
- (void)bubbleSpin;
- (void)bubbleFloat;
- (void)bubbleDefaultCollideWith:(Bubble *)bubble;

//timeline
- (void)addDelay:(NSTimeInterval)delay;
- (void)clearDelay;

//default collision detect
+ (BOOL)detectDefaultCollideFrom:(Bubble*)a to:(Bubble*)b;

//embedded elements
- (void)setImage:(NSString*)imageName;

@end
