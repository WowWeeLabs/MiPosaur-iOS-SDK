//
//  ViewController.h
//  MiposaurSampleProject
//
//  Created by DavidFF Chan on 24/9/15.
//  Copyright © 2015 DavidFF Chan. All rights reserved.
//
//Volumes/SanDisk/wowwee/MiPosaur_REF/MiposaurSampleProject/WowWeeMiPosaurSDK.framework/Headers/MiposaurRobot.h
#import <UIKit/UIKit.h>


@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *miposaurStatusLabel;

@property (weak, nonatomic) IBOutlet UIButton *playSoundButton;
@property (weak, nonatomic) IBOutlet UIButton *changeRGBColourButton;
@property (weak, nonatomic) IBOutlet UIButton *sitButton;
@property (weak, nonatomic) IBOutlet UIButton *standButton;
@property (weak, nonatomic) IBOutlet UIButton *falloverButton;
@property (weak, nonatomic) IBOutlet UIButton *driveButton;



@end

