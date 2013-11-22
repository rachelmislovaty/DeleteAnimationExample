//
//  ViewController.h
//  DeleteAnimationProj
//
//  Created by Rachel Mislovaty on 11/22/13.
//  Copyright (c) 2013 Rada Mislovaty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *frogImage; //the main image that covers the whole view
@property (weak, nonatomic) IBOutlet UIButton *trashButton; //delete button
@property (weak, nonatomic) IBOutlet UIButton *refreshButton; //refresh button

@property (strong, nonatomic) UIImageView * imageForAnimation; //this image will be needed for the animation effect

- (IBAction)onDelete:(id)sender;
- (IBAction)onRefresh:(id)sender;

@end
