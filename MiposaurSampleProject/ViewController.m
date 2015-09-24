//
//  ViewController.m
//  MiposaurSampleProject
//
//  Created by DavidFF Chan on 24/9/15.
//  Copyright © 2015 DavidFF Chan. All rights reserved.
//

#import "ViewController.h"

#import <WowWeeMiPosaurSDK/MiposaurRobot.h>
#import <WowWeeMiPosaurSDK/MiposaurRobotFinder.h>
#import <WowWeeMiPosaurSDK/MiposaurRobot.h>

@import WowWeeMiPosaurSDK;



@interface ViewController () <MiposaurRobotDelegate>
@property (nonatomic, weak) MiposaurRobot *miposaur;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addNotificationObservers];
    [MiposaurRobotFinder sharedInstance];
}

- (void)dealloc {
    [self removeNotificationObservers];
    self.miposaur = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    // We need to wait 1 second to make sure that bluetooth is ready
    //[self performSelector:@selector(scan) withObject:nil afterDelay:1];
    [self scan];
}

- (void)scan {
    [[MiposaurRobotFinder sharedInstance] scanForMiposaurs];
}

- (void)addNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mipFoundNotification:) name:MiposaurRobotFinderNotificationID object:nil];
}

- (void)removeNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MiposaurRobotFinderNotificationID object:nil];
}

#pragma mark - Button Actions
- (IBAction)playSoundPressed:(id)sender {
    NSLog(@"Playing MiPosaur Sound");
    
    // When playing a sound we need to first create a sound object, all available builtin sounds are avaialble as constants using kMipSoundFile
    MiposaurRobotSound *mipSound = [MiposaurRobotSound miposaurRobotSoundWithFile:kMiposaurSoundFile_DINO_ANGRY_1_A34];//kMipSoundFile_MIP_IN_LOVE
    
    [self.miposaur miposaurPlaySound:mipSound];
}

- (IBAction)changeChestRGBPressed:(id)sender {
    NSLog(@"Changing RGB colour");
    
    // Pass a UIColor here to define what colour you want the Chest RGB to turn
    [self.miposaur setMiposaurChestRGBLedWithColor:[UIColor yellowColor]];
   }

- (IBAction)falloverPressed:(id)sender {
    NSLog(@"MiPosaur is falling forward.... Tiiiiiimmmmmmbbeeeeer!");
    
    // Mip can fall forward or backward, in our example we are just simply making him fall forward
    [self.miposaur miposaurFalloverWithStyle:kMiposaurPositionOnFront]; //kMipPositionFaceDown
}

- (IBAction)sitPressed:(id)sender {
    NSLog(@"MiPosaur is falling forward.... Tiiiiiimmmmmmbbeeeeer!");
    
    // Mip can fall forward or backward, in our example we are just simply making him fall forward
    [self.miposaur miposaurFalloverWithStyle:kMiposaurPositionOnFontCantGetup]; //kMipPositionFaceDown
}

- (IBAction)standPressed:(id)sender {
    NSLog(@"MiPosaur is falling forward.... Tiiiiiimmmmmmbbeeeeer!");
    
    // Mip can fall forward or backward, in our example we are just simply making him fall forward
    [self.miposaur miposaurFalloverWithStyle:kMiposaurPositionUpright]; //kMipPositionFaceDown
}

- (IBAction)drivePressed:(id)sender {
    
}

#pragma mark - MiposaurRobotFinder Notification
- (void)mipFoundNotification:(NSNotification *)note {
    NSLog(@"- (void)mipFoundNotification:(NSNotification *)note");
    NSDictionary *noteDict = note.userInfo;
    if (!noteDict || !noteDict[@"code"]) {
        return;
    }
    MiposaurRobotFinderNote noteType = (MiposaurRobotFinderNote)[noteDict[@"code"] integerValue];
    
    if (noteType == MiposaurRobotFinderNote_MiposaurFound) {
        MiposaurRobot *miposaur = noteDict[@"data"];
        // Normally you might want to add this object to an array and use a UITableView to display all the found devices for the user to select. For now we just want to print this MiPosaur to the console
        NSLog(@"Found: %@", miposaur);
        self.miposaurStatusLabel.text = [NSString stringWithFormat:@"Found MiP: %@", miposaur.name];
        
        // We have one MiPosaur so stop scanning
        [[MiposaurRobotFinder sharedInstance] stopScanForMiposaurs];
        
        // Before connecting we want to setup which class is going to handle callbacks, for simplicity we are going to use this class for everything but normally you might use a different class
        miposaur.delegate = self;
        
        self.miposaurStatusLabel.text = [NSString stringWithFormat:@"Connecting: %@", miposaur.name];
        
        // Lets connect
        [miposaur connect];
    } else if (noteType == MiposaurRobotFinderNote_BluetoothError) {
        CBCentralManagerState errorCode = (CBCentralManagerState)[noteDict[@"data"] integerValue];
        if (errorCode == CBCentralManagerStateUnsupported) {
            NSLog(@"Bluetooth Unsupported on this device");
            self.miposaurStatusLabel.text = @"Bluetooth Unsupported on this device";
        } else if (errorCode == CBCentralManagerStatePoweredOff) {
            NSLog(@"Bluetooth is turned off");
            self.miposaurStatusLabel.text = @"Bluetooth Unsupported on this device";
        }
    } else if (noteType == MiposaurRobotFinderNote_BluetoothIsAvailable) {
        //[[MiposaurRobotFinder sharedInstance] scanForMips];
    }
}

#pragma mark - MiposaurRobot Callbacks
- (void) MiposaurDeviceReady:(MiposaurRobot *)miposaur {
    self.miposaur = miposaur;
    // Yay we are connected and ready to talk
    self.miposaurStatusLabel.text = [NSString stringWithFormat:@"Connected: %@", miposaur.name];
    self.playSoundButton.enabled = YES;
    self.changeRGBColourButton.enabled = YES;
    self.falloverButton.enabled = YES;
    self.driveButton.enabled = YES;
    self.sitButton.enabled = YES;
    self.standButton.enabled = YES;
}

- (void) MiposaurDeviceDisconnected:(MiposaurRobot *)mip error:(NSError *)error {
    self.miposaurStatusLabel.text = [NSString stringWithFormat:@"Disconnected from MiP"];
    self.playSoundButton.enabled = NO;
    self.changeRGBColourButton.enabled = NO;
    self.falloverButton.enabled = NO;
    self.driveButton.enabled = NO;
    self.sitButton.enabled = NO;
    self.standButton.enabled = NO;
    self.miposaur = nil;
    
    [[MiposaurRobotFinder sharedInstance] scanForMiposaurs];
}


@end
