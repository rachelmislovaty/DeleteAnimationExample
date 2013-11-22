//
//  ViewController.m
//  DeleteAnimationProj
//
//  Created by Rada Mislovaty on 11/22/13.
//  Copyright (c) 2013 Rachel Mislovaty. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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

- (IBAction)onDelete:(id)sender
{
    if(self.frogImage.hidden == NO) //the image is not "deleted"
    {
        //take a snapshot of your view:
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //create the image that will be animated towards the trashbin:
        CGRect imgFrame = CGRectMake(70, 130, 180, 180*self.view.bounds.size.height/self.view.bounds.size.width);
        self.imageForAnimation = [[UIImageView alloc] initWithFrame:imgFrame];
        self.imageForAnimation.image =  screenshot;
        [[UIApplication sharedApplication].keyWindow addSubview:self.imageForAnimation];
        
        //create the animation itself and apply it on the image that was prepared:
        CAAnimationGroup *group = [self prepareTrashAnimationWithDuration:0.8 forView:self.imageForAnimation];
        group.delegate = self;
        [self.imageForAnimation.layer addAnimation:group forKey:@"trashAnimation"];
        
        // hide the original image itseld, to make it look as if it being deleted
        // (if you really want to delete it, you can call "removeFromSuperview" here)
        self.frogImage.hidden = YES;
    }
}

-(CAAnimationGroup *)prepareTrashAnimationWithDuration:(float)dur forView:(UIView *)theView
//the animtation of "flight" towards the trashbin + scaling at the same time
{
    
    //the position animation path:
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 145, 180);
    CGPathAddLineToPoint(path, nil, 135, 162);
    CGPathAddLineToPoint(path, nil, 115, 147);
    CGPathAddLineToPoint(path, nil, 93, 157);
    CGPathAddLineToPoint(path, nil, 70, 182);
    CGPathAddLineToPoint(path, nil, 52, 220);
    CGPathAddLineToPoint(path, nil, 44, 279);
    CGPathAddLineToPoint(path, nil, 38, 350);
    CGPathAddLineToPoint(path, nil, 38, 452);
    CGPathAddLineToPoint(path, nil, 38, 516);
    CGPathAddLineToPoint(path, nil, 38, 576);
    
    CAKeyframeAnimation *leafAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    leafAnimation.path = path;
    leafAnimation.removedOnCompletion = NO;
    CGPathRelease(path);
    
    //the scaling animation:
    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    resizeAnimation.fromValue = [NSNumber numberWithDouble:1.0];
    resizeAnimation.toValue = [NSNumber numberWithDouble:0.01];
    resizeAnimation.fillMode = kCAFillModeForwards;
    resizeAnimation.removedOnCompletion = NO;
    
    //combining them together:
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects: leafAnimation, resizeAnimation, nil]];
    group.duration = dur;
    [group setValue:theView forKey:@"trashAnimation"];
    
    return group;
}

- (void)animationDidStop:(CAKeyframeAnimation *)anim finished:(BOOL)flag
{
    //remove the image that was animated
    [self.imageForAnimation removeFromSuperview];
    self.imageForAnimation = nil;
    
    //gently rock the trashbin icon from side to side, for the animation effect complition:
    [self playTrashBinAnimation];
}

- (void) playTrashBinAnimation
{
    //swinging the trashbin icon from side to side several times:
    
    [UIView animateWithDuration:0.1 animations:^{
        self.trashButton.transform = CGAffineTransformMakeRotation(M_1_PI/2.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.trashButton.transform = CGAffineTransformMakeRotation(-M_1_PI/2.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.trashButton.transform = CGAffineTransformMakeRotation(M_1_PI/2.0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.trashButton.transform = CGAffineTransformMakeRotation(0.0);
                } completion:^(BOOL finished)
                 {
                    //do here any additional steps that you need at the end of everithing...
                }];
            }];
        }];
    }];
}

- (IBAction)onRefresh:(id)sender
{
    //make the image visible again
    self.frogImage.hidden = NO;
}

@end
