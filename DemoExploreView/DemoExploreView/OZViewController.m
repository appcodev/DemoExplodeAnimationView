//
//  OZViewController.m
//  DemoExploreView
//
//  Created by Chalermchon Samana on 10/9/13.
//  Copyright (c) 2013 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "OZViewController.h"

@interface OZViewController (){
    
    IBOutlet UIImageView *iImage;
    IBOutlet UISegmentedControl *segmc;
}

@end

@implementation OZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)explodeView:(UIView*)eView style:(int)style{
    [segmc setEnabled:NO];
    
    CGSize size = eView.frame.size;
    NSMutableArray *snapshots = [NSMutableArray new];
    
    CGFloat xFactor = 20.0f;
    CGFloat yFactor = xFactor * size.height/size.width;
    
    UIView *snapshotView = [eView snapshotViewAfterScreenUpdates:YES];
    
    for (float x=0; x<size.width; x+=size.width/xFactor) {
        for (float y=0; y<size.height; y+=size.height/yFactor) {
            CGRect snapshotRegion = CGRectMake(x, y, size.width/xFactor, size.height/yFactor);
            UIView *ss = [snapshotView resizableSnapshotViewFromRect:snapshotRegion
                                           afterScreenUpdates:NO
                                                withCapInsets:UIEdgeInsetsZero];
            ss.frame = snapshotRegion;
            
            [self.view addSubview:ss];
            [snapshots addObject:ss];
        }
    }
    
    //animation
    [UIView animateWithDuration:2
                     animations:^{
                         iImage.alpha = 0;
                         
                         for (UIView *view in snapshots) {
                             
                             if (style==1) {
                                 CGFloat xOffset = [self randomFloatBetween:-100 and:100];
                                 CGFloat yOffset = [self randomFloatBetween:-100 and:100];
                                  
                                 view.frame = CGRectOffset(view.frame, xOffset, yOffset);
                                 view.alpha = 0.0;
                                 view.transform = CGAffineTransformScale(CGAffineTransformMakeRotation([self randomFloatBetween:-10.0 and:10.0]),0.0,0.0);
                             }else{
                                 view.alpha = 0.0;
                                 view.transform = CGAffineTransformMakeScale(-1, 1);
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         for (UIView *view in snapshots) {
                             [view removeFromSuperview];
                         }
                         
                         iImage.alpha = 1;
                         
                         [segmc setEnabled:YES];
                     }];
    
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}
- (IBAction)startExplode:(UISegmentedControl*)sender {
    
    [self explodeView:iImage style:sender.selectedSegmentIndex];
    
}

@end
