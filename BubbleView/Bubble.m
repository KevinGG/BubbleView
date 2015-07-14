//
//  Bubble.m
//  Test
//
//  Created by KangNing on 7/8/15.
//  Copyright (c) 2015 iAK. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble{
    CGFloat radius;
    NSTimeInterval totalDelay;
    UIImageView *imageView;
    
    BOOL bubbleTapEnabled;
    BOOL bubbleDragEnabled;
    BOOL bubbleZoomEnabled;
    BOOL bubbleDragAlwaysTraceBack;
    BOOL bubbleDefaultCollisionEnabled;
    
    CGRect traceBackFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)rect{
    self = [super initWithFrame:rect];
    if(self){
        //bubble behavior preset
        bubbleTapEnabled = YES;
        bubbleDragEnabled = NO;
        bubbleZoomEnabled = YES;
        bubbleDragAlwaysTraceBack = NO;
        bubbleDefaultCollisionEnabled = NO;
        
        
        self.layer.cornerRadius = self.frame.size.width/2.0;
        radius = self.frame.size.width/2.0;
        self.clipsToBounds = YES;
        totalDelay = 0.0;
        [self initTapGesture];
        
        //set the auto refresh
        //[NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(autoRefresh) userInfo:nil repeats:YES];
    }
    return self;
}


#pragma mark - behavior control
- (void)bubbleTapEnable{
    bubbleTapEnabled = YES;
}

- (void)bubbleTapDisable{
    bubbleTapEnabled = NO;
}

- (void)bubbleDragEnable{
    bubbleDragEnabled = YES;
}

- (void)bubbleDragDisable{
    bubbleDragEnabled = NO;
}

- (void)bubbleTraceBackDragEnable{
    bubbleDragAlwaysTraceBack = YES;
}

- (void)bubbleTraceBackDragDisable{
    bubbleDragAlwaysTraceBack = NO;
}

- (void)bubbleZoomEnable{
    bubbleZoomEnabled = YES;
}

- (void)bubbleZoomDisable{
    bubbleZoomEnabled = NO;
}

- (void)bubbleDefaultCollisionEnable{
    bubbleDefaultCollisionEnabled = YES;
}

- (void)bubbleDefaultCollisionDisable{
    bubbleDefaultCollisionEnabled = NO;
}


//return radius
- (CGFloat)radius{
    return radius;
}

//update the timeline delay for next set of anime
- (void)addDelay:(NSTimeInterval)delay{
    totalDelay += delay;
}

//clear Delay
- (void)clearDelay{
    totalDelay = 0.0;
}

#pragma mark - bubble animation


- (void)bubbleMoveHorizontal:(CGFloat)unit left:(BOOL)left duration:(NSTimeInterval)duration{
    CGRect bubbleFrame = self.frame;
    if(left){
        bubbleFrame.origin.x -= unit;
    }else{
        bubbleFrame.origin.x += unit;
    }
    
    [UIView animateWithDuration:duration delay:totalDelay options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.frame = bubbleFrame;
    } completion:^(BOOL finished) {
//        NSString* direction = left?@"left":@"right";
//        NSLog(@"Bubble moved %@ for %f", direction, unit);
    }];
}

- (void)bubbleMoveVertical:(CGFloat)unit up:(BOOL)up duration:(NSTimeInterval)duration{
    CGRect bubbleFrame = self.frame;
    if(up){
        bubbleFrame.origin.y -= unit;
    }else{
        bubbleFrame.origin.y += unit;
    }
    [UIView animateWithDuration:duration delay:totalDelay options:UIViewAnimationOptionCurveEaseIn                     animations:^{
        self.frame = bubbleFrame;
    }completion:^(BOOL finished) {
//        NSString* direction = up?@"up":@"down";
//        NSLog(@"Bubble moved %@ for %f", direction, unit);
    }];
}

- (void)bubbleMove:(CGPoint)vector{
    [self bubbleMoveHorizontal:vector.x left:YES duration:0.01];
    [self bubbleMoveVertical:vector.y up:YES duration:0.01];
}

- (void)bubbleMove:(CGPoint)vector duration:(NSTimeInterval)duration{
    [self bubbleMoveHorizontal:vector.x left:YES duration:duration];
    [self bubbleMoveVertical:vector.y up:YES duration:duration];
}

- (void)bubbleZoom:(CGFloat)times duration:(NSTimeInterval)duration{
    if(!bubbleZoomEnabled) return;
    [UIView animateWithDuration:duration delay:totalDelay options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(times, times);
    }completion:^(BOOL finished) {
//        NSString* direction = times>1?@"zoom in":@"zoom out";
//        NSLog(@"Bubble %@ %f times", direction, times);
    }];
}

- (void)bubbleShake{
    [UIView animateKeyframesWithDuration:0.5 delay:totalDelay options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeRotation(0.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeRotation(-0.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeRotation(0.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeRotation(-0.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeRotation(0);
        }];
        
    }completion:^(BOOL finished) {
    }];
}

- (void)bubbleFadeIn{
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:totalDelay options:0 animations:^{
        self.alpha = 1.0;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)bubbleFlip{
    [UIView animateWithDuration:0.4 delay:totalDelay options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.transform = CGAffineTransformMakeScale(1, -1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}

- (void)bubbleSpin{
    [UIView animateWithDuration:0.4 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)bubbleFloat{
    CGFloat randomX = arc4random()%20;
    CGFloat randomY = arc4random()%20;
    [self bubbleMove:CGPointMake(randomX, randomY) duration:0.6];
    [self addDelay:0.6];
    [self bubbleMove:CGPointMake(-randomX, -randomY) duration:0.6];
    [self clearDelay];
}


#pragma mark - Tap Gesture
- (void)initTapGesture{
    UITapGestureRecognizer *bubbleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bubbleTapped)];
    [self addGestureRecognizer:bubbleTapGestureRecognizer];
}

//call the delegation
- (void)bubbleTapped{
    if(!bubbleTapEnabled) return;
    //NSLog(@"Call delegation");
    [_bubbleDelegate bubbleTap:self];
}


#pragma mark - Drag
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!bubbleTapEnabled) return;
    [self.superview bringSubviewToFront:self];
    [self bubbleZoom:1.5 duration:0.2];
    traceBackFrame = self.frame;
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!bubbleTapEnabled) return;
    if(bubbleDragAlwaysTraceBack) self.frame = traceBackFrame;
    [self bubbleZoom:1.0 duration:0.2];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!bubbleTapEnabled) return;
    if(bubbleDragAlwaysTraceBack) self.frame = traceBackFrame;
    [self bubbleZoom:1.0 duration:0.2];
    if([_bubbleDelegate detectCollideWith:self]){
        [_bubbleDelegate afterCollide:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!bubbleTapEnabled || !bubbleDragEnabled) return;
    UITouch *anyTouch = [touches anyObject];
    //current finger coordination in the bubble
    CGPoint currentFingerPositionInBubble = [anyTouch locationInView:self];
//  NSLog(@"%f, %f", currentFingerPositionInBubble.x, currentFingerPositionInBubble.y);
    CGPoint leftUpMoveVector = CGPointMake(radius - currentFingerPositionInBubble.x, radius - currentFingerPositionInBubble.y);
    [self bubbleMove:leftUpMoveVector];
    if([_bubbleDelegate detectCollideWith:self]){
        [_bubbleDelegate onCollide:self];
    }
    
}


#pragma mark - bubble elements
//set imageview
- (void)setImage:(NSString *)imageName{
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 2*radius-6, 2*radius-6)];
    [imageView setImage:[UIImage imageNamed:imageName]];
    imageView.layer.cornerRadius = radius-3;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
}


#pragma mark - bubble refresh: 60fps
- (void)autoRefresh{
    [self bubbleFloat];
}




@end
