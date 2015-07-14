//
//  ViewController.m
//  Test
//
//  Created by KangNing on 7/8/15.
//  Copyright (c) 2015 iAK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<BubbleDelegate>
@property (weak, nonatomic) IBOutlet UILabel *chosenLabel;

@end

@implementation ViewController{
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    Bubble *bubble1;
    Bubble *bubble2;
    NSMutableArray *bubbleArray;//tag starts from 1 except 3
    Timeline *timeline;
    
    Bubble *collection;
    BOOL collectionOpened;
    UIScrollView *collectionTable;
    
    NSMutableArray *collectedBubbleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:Rgb2UIColor(arc4random()%255, arc4random()%255, arc4random()%255, 0.5)];
    [self initObjects];
    [self openAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initObjects{
    screenRect = [[UIScreen mainScreen]bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    bubble1 = [[Bubble alloc]initWithFrame:CGRectMake(-100, screenHeight/2.0 - 50, 100, 100)];
    bubble1.tag = 1;
    [bubble1 setBackgroundColor:Rgb2UIColor(arc4random()%255, arc4random()%255, arc4random()%255, 0.5)];
    bubble2 = [[Bubble alloc]initWithFrame:CGRectMake(screenWidth, screenHeight/2.0 - 50, 100, 100)];
    bubble2.tag = 2;
    [bubble2 setBackgroundColor:Rgb2UIColor(arc4random()%255,arc4random()%255,arc4random()%255,0.5)];
    
    [self.view addSubview:bubble1];
    [self.view addSubview:bubble2];
    
    //set up tap delegate
    bubble1.bubbleDelegate = self;
    bubble2.bubbleDelegate = self;
    
    //set up  image
    [bubble1 setImage:@"puppy.jpeg"];
    bubble1.title = @"Puppy";
    [bubble2 setImage:@"kitty.jpeg"];
    bubble2.title = @"Cat";
    
    //enable Drag on bubble1 and bubble2
    [bubble1 bubbleDragEnable];
    [bubble2 bubbleDragEnable];
    [bubble1 bubbleDefaultCollisionDisable];
    [bubble2 bubbleDefaultCollisionDisable];
    
    
    timeline = [[Timeline alloc]init];
    
    //The collection box
    collection = [[Bubble alloc]initWithFrame:CGRectMake(screenWidth/2.0 - 50, screenHeight - 100, 100, 100)];
    collection.tag = 3;
    [collection setBackgroundColor:Rgb2UIColor(arc4random()%255, arc4random()%255, arc4random()%255, 0.5)];
    [collection bubbleFloatDisable];
    [collection bubbleDefaultCollisionDisable];
    
    [self.view addSubview:collection];
    collection.bubbleDelegate = self;
    [collection setImage:@"collection.jpg"];
    collection.title = @"Inventory";
    collectionOpened = NO;
    
    collectedBubbleArray = [[NSMutableArray alloc]init];
    
    
    bubbleArray = [[NSMutableArray alloc]init];
    [bubbleArray addObject:bubble1];
    [bubbleArray addObject:bubble2];
    
    Bubble *bubbleEntry;
    CGFloat originX = 5;
    CGFloat originY = screenHeight/2.0 - 160;
    for(int i = 0; i < 4; i++){
        bubbleEntry = [[Bubble alloc]initWithFrame:CGRectMake(originX, originY, 100, 100)];
        bubbleEntry.tag = 4+i;
        [bubbleEntry bubbleDragEnable];
        [bubbleEntry setBackgroundColor:Rgb2UIColor(arc4random()%255, arc4random()%255, arc4random()%255, 0.5)];
        bubbleEntry.bubbleDelegate = self;
        [bubbleEntry bubbleDefaultCollisionDisable];
        [bubbleArray addObject:bubbleEntry];
        [self.view addSubview:bubbleEntry];
        originX += 100;
    }
    bubbleEntry = [bubbleArray objectAtIndex:2];
    [bubbleEntry setImage:@"lion.jpg"];
    bubbleEntry.title = @"lion";
    bubbleEntry = [bubbleArray objectAtIndex:3];
    [bubbleEntry setImage:@"monkey.jpg"];
    bubbleEntry.title = @"monkey";
    bubbleEntry = [bubbleArray objectAtIndex:4];
    [bubbleEntry setImage:@"fox.jpg"];
    bubbleEntry.title = @"fox";
    bubbleEntry = [bubbleArray objectAtIndex:5];
    [bubbleEntry setImage:@"pig.jpeg"];
    bubbleEntry.title = @"pig";
    
    
}

- (void)openAnimation{
    //preset timeline
    [timeline setNextDelay:0.0];
    [timeline setNextDelay:0.5];
    [timeline setNextDelay:0.2];
    //1st set of anime
    [self bubbleBumpAnime];
    //2nd set of anime
    [self bubbleBumpBackAnime];
    //clear delay
    [bubble1 clearDelay];
    [bubble2 clearDelay];
    //3rd set of anime
    [self bubbleFadeInAnime];
    for (Bubble *bubbleEntry in bubbleArray) {
        [bubbleEntry clearDelay];
    }
}


- (void)bubbleBumpAnime{
    NSTimeInterval nextDelay = [timeline nextDelay];
    [bubble1 addDelay:nextDelay];
    [bubble2 addDelay:nextDelay];
    for (Bubble *bubbleEntry in bubbleArray) {
        [bubbleEntry addDelay:nextDelay];
    }
    [bubble1 bubbleMoveHorizontal:(screenWidth/2 - [bubble1 radius]*2 - bubble1.frame.origin.x) left:NO duration:0.5];
    [bubble2 bubbleMoveHorizontal:(bubble2.frame.origin.x - screenWidth/2) left:YES duration:0.5];
}

- (void)bubbleBumpBackAnime{
    NSTimeInterval nextDelay = [timeline nextDelay];
    [bubble1 addDelay:nextDelay];
    [bubble2 addDelay:nextDelay];
    for (Bubble *bubbleEntry in bubbleArray) {
        [bubbleEntry addDelay:nextDelay];
    }
    [bubble1 bubbleMoveHorizontal:25 left:YES duration:0.2];
    [bubble2 bubbleMoveHorizontal:25 left:NO duration:0.2];
}

- (void)bubbleFadeInAnime{
    NSTimeInterval nextDelay = [timeline nextDelay];
    for (Bubble *bubbleEntry in bubbleArray) {
        [bubbleEntry addDelay:nextDelay];
    }
    for (Bubble *bubbleEntry in bubbleArray) {
        [bubbleEntry bubbleFadeIn];
        [bubbleEntry bubbleFlip];
        [bubbleEntry bubbleSpin];
    }
    
}

#pragma mark - realize bubble delegation

- (void)bubbleTap:(id)thisBubble{
    //NSLog(@"Bubble is tapped");
    Bubble *bubble = (Bubble *)thisBubble;
    //based on the tag, give different functionality
    switch (bubble.tag) {
        case 3:
            [_chosenLabel setText:bubble.title];
            [collection bubbleShake];
            [bubble bubbleTapDisable];
            [self displayCollection];
            break;
            
        default:
            [_chosenLabel setText:bubble.title];
            break;
    }
    
}

//self defined collision condition, often used to detect collision with collection bubble
- (BOOL)detectCollideWith:(id)thisBubble{
    Bubble *bubble = (Bubble *)thisBubble;
    return [Bubble detectDefaultCollideFrom:bubble to:collection];
}

//called on touchesMove
- (void)onCollide:(id)thisBubble{
    
    
}


//called on touchesEnd
- (void)afterCollide:(id)thisBubble{
    Bubble *bubble = (Bubble *)thisBubble;
    [bubble clearDelay];
    [bubble bubbleZoom:0.001 duration:0.4];
    
    
    [collection clearDelay];
    [collection bubbleZoom:2.0 duration:0.2];
    [collection addDelay:0.2];
    [collection bubbleZoom:1.0 duration:0.2];
    
    [bubble bubbleFloatDisable];
    [collectedBubbleArray addObject:bubble];
    
}

//called autoFresh inside any bubble
- (void)defaultCollide:(id)thisBubble{
    Bubble *bubble = (Bubble *)thisBubble;
    for (Bubble *anotherBubble in bubbleArray) {
        if([Bubble detectDefaultCollideFrom:bubble to:anotherBubble] && anotherBubble.tag != collection.tag){
            [bubble bubbleDefaultCollideWith:anotherBubble];
        }
    }
}




#pragma mark - display collection with customized UIView
- (void)displayCollection{
    if(!collectionOpened){
        collectionTable = [[UIScrollView alloc]initWithFrame:CGRectMake(0, collection.frame.origin.y - 50, screenWidth, 0)];
        [collectionTable setBackgroundColor:Rgb2UIColor(arc4random()%255, arc4random()%255, arc4random()%255, 1.0)];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            collectionTable.frame = CGRectMake(0, collection.frame.origin.y - 100, [collectedBubbleArray count]*100>screenWidth? [collectedBubbleArray count]*100:screenWidth, 100);
        } completion:^(BOOL finished) {
            CGFloat originX = 0.0;
            CGFloat originY = 0.0;
            CGFloat sizeWidth = 100.0;
            CGFloat sizeHeight = 100.0;
            for (Bubble *bubble in collectedBubbleArray) {
                [bubble bubbleZoom:1.0 duration:0.01];
                [bubble bubbleTraceBackDragEnable];
                bubble.frame = CGRectMake(screenWidth, originY, sizeWidth, sizeHeight);
                [collectionTable addSubview:bubble];
                [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                    bubble.frame = CGRectMake(originX, originY, sizeWidth, sizeHeight);
                } completion:^(BOOL finished) {
                }];
                originX += sizeWidth;
            }
            [collection bubbleTapEnable];
        }];
        
        
        
        [self.view addSubview:collectionTable];
    }else{
        for (Bubble *bubble in collectedBubbleArray) {
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                bubble.frame = CGRectMake(screenWidth, 0, 100, 100);
            } completion:^(BOOL finished) {
                [bubble removeFromSuperview];
            }];
        }
        [UIView animateWithDuration:0.5 delay:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            collectionTable.frame = CGRectMake(0, collection.frame.origin.y - 50, screenWidth, 0);
        } completion:^(BOOL finished) {
            [collectionTable removeFromSuperview];
            [collection bubbleTapEnable];
        }];
        collectionTable = nil;
    }
    collectionOpened = !collectionOpened;
}



@end
