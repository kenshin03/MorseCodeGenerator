//
//  MCGViewController.m
//  MorseCodeGenerator
//
//  Created by Kenny Tang on 8/9/13.
//  Copyright (c) 2013 com.corgitoergosum.net. All rights reserved.
//

#import "MCGViewController.h"
#import "MCGMorseCodeConverter.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MCGViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *morseCodeOutputLabel;
@property (weak, nonatomic) IBOutlet UITextField *morseCodeInputTextField;

@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vibrationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *flashSwitch;

@property (nonatomic) BOOL enableSound;
@property (nonatomic) BOOL enableFlash;
@property (nonatomic) BOOL enableVibration;

@property (nonatomic) SystemSoundID ditSoundID;
@property (nonatomic) SystemSoundID dahSoundID;

@end

@implementation MCGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.enableSound = YES;
    self.enableFlash = NO;
    self.enableVibration = NO;
    self.morseCodeOutputLabel.hidden = NO;
    
    self.soundSwitch.on = self.enableSound;
    self.flashSwitch.on = self.enableFlash;
    self.vibrationSwitch.on = self.enableVibration;
    
    NSString * ditSoundResPath = [[NSBundle mainBundle] pathForResource:@"dit" ofType:@"wav"];
	NSURL * sucessURLRef = [NSURL fileURLWithPath:ditSoundResPath isDirectory:NO];
	AudioServicesCreateSystemSoundID ((__bridge CFURLRef)sucessURLRef, &_ditSoundID);
    
    NSString * dahSoundResPath = [[NSBundle mainBundle] pathForResource:@"dah" ofType:@"wav"];
	NSURL * dahSucessURLRef = [NSURL fileURLWithPath:dahSoundResPath isDirectory:NO];
	AudioServicesCreateSystemSoundID ((__bridge CFURLRef)dahSucessURLRef, &_dahSoundID);
    
    [self.morseCodeInputTextField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.morseCodeInputTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.morseCodeInputTextField resignFirstResponder];
    [self convertButtonTapped:textField];
    return YES;
}

#pragma mark - UIButton delegate methods

- (void)convertButtonTapped:(id)sender {
    
    self.morseCodeOutputLabel.hidden = NO;
    self.vibrationSwitch.enabled = NO;
    self.flashSwitch.enabled = NO;
    self.soundSwitch.enabled = NO;
    self.morseCodeInputTextField.enabled = NO;
    
    
    // parse text and map into morse code
    NSMutableArray * morseCodeStringArray = [@[] mutableCopy];
    
    __block float durationMs = 0.0f;
    
    MCGMorseCodeConverter * converter = [[MCGMorseCodeConverter alloc] init];
    NSArray * morseCodeArray = [converter convertStringToMorseCodes:self.morseCodeInputTextField.text];
    [morseCodeArray enumerateObjectsUsingBlock:^(NSNumber * morseCodeNumber, NSUInteger idx, BOOL *stop) {
        
        switch ([morseCodeNumber integerValue]) {
            case MCGMorseCodeDit:
                [morseCodeStringArray addObject:kMorseCodeDitString];
                durationMs += 150.0f;
                break;
            case MCGMorseCodeDah:
                [morseCodeStringArray addObject:kMorseCodeDahString];
                durationMs += 150.0f*3;
                break;
            case MCGMorseCodeSingleSpace:
                [morseCodeStringArray addObject:kMorseCodeDahSpaceString];
                durationMs += 150.0f;
                break;
            case MCGMorseCodeThreeSpaces:
                [morseCodeStringArray addObject:kMorseCodeDahThreeSpacesString];
                durationMs += 150.0f*3;
                break;
            default:
                break;
        }
    }];
    
    // update and animate the label
    NSString * morseCodeString = [morseCodeStringArray componentsJoinedByString:@""];
    self.morseCodeOutputLabel.text = morseCodeString;
    
    self.morseCodeOutputLabel.layer.anchorPoint = CGPointMake(0.5, .5);
    
    CABasicAnimation * opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0.0f);
    opacityAnimation.toValue = @(1.0f);
    opacityAnimation.fillMode = kCAFillModeBackwards;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.delegate = self;
    
    scaleAnimation.values = @[@(1.6f), @(1.0f)];
    [scaleAnimation setTimingFunctions:@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                          ]
     ];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup * animGroup = [[CAAnimationGroup alloc] init];
    animGroup.animations = @[opacityAnimation, scaleAnimation];
    animGroup.duration = 0.5f;
    [self.morseCodeOutputLabel.layer addAnimation:animGroup forKey:@"scaleIn"];
    
    // give some time for keyboard to dismiss
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if (self.enableSound){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playMorseCodeSound:morseCodeArray];
            });
        }
        
        if (self.enableVibration){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playMorseCodeVibration:morseCodeArray];
            });
        }
        if (self.enableFlash){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playMorseCodeFlashlight:morseCodeArray];
            });
        }
    });

    // restore UI
    delayInSeconds = durationMs/1000.0f;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.morseCodeInputTextField.enabled = YES;
        
        self.vibrationSwitch.enabled = YES;
        self.flashSwitch.enabled = YES;
        self.soundSwitch.enabled = YES;
        self.morseCodeInputTextField.enabled = YES;
    });
}


- (void)playMorseCodeSound:(NSArray*)morseCodeArray {
    
        [morseCodeArray enumerateObjectsUsingBlock:^(NSNumber * morseCodeNumber, NSUInteger idx, BOOL *stop) {
            
            
            [NSThread sleepForTimeInterval:0.1];
            
            switch ([morseCodeNumber integerValue]) {
                case MCGMorseCodeDit:
                    [self playDitSound];
                    [NSThread sleepForTimeInterval:0.5f];
                    break;
                case MCGMorseCodeDah:
                    [self playDahSound];
                    [NSThread sleepForTimeInterval:1.5f];
                    break;
                case MCGMorseCodeSingleSpace:
                    //pause for 500ms
                    [NSThread sleepForTimeInterval:0.5f];
                    break;
                case MCGMorseCodeThreeSpaces:
                    //pause for 1500ms
                    [NSThread sleepForTimeInterval:1.5f];
                    break;
                default:
                    break;
            }
        }];
        
}



- (void)playMorseCodeFlashlight:(NSArray*)morseCodeArray {
    AVCaptureSession * session = [[AVCaptureSession alloc] init];
    [session beginConfiguration];
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){
        
        AVCaptureDeviceInput * flashInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (flashInput){
            [session addInput:flashInput];
        }
        [session commitConfiguration];
        
        [morseCodeArray enumerateObjectsUsingBlock:^(NSNumber * morseCodeNumber, NSUInteger idx, BOOL *stop) {
            
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff];
            [device unlockForConfiguration];
            [session stopRunning];
            [NSThread sleepForTimeInterval:0.1];
            
            switch ([morseCodeNumber integerValue]) {
                case MCGMorseCodeDit:
                    //vibrate for 500ms
                    
                    [device lockForConfiguration:nil];
                    [device setTorchMode:AVCaptureTorchModeOn];
                    [device unlockForConfiguration];
                    [session startRunning];
                    [NSThread sleepForTimeInterval:0.5];
                    break;
                case MCGMorseCodeDah:
                    //vibrate for 1500ms
                    [device lockForConfiguration:nil];
                    [device setTorchMode:AVCaptureTorchModeOn];
                    [device unlockForConfiguration];
                    [session startRunning];
                    [NSThread sleepForTimeInterval:1.5f];
                    break;
                case MCGMorseCodeSingleSpace:
                    //pause for 500ms
                    [device lockForConfiguration:nil];
                    [device setTorchMode:AVCaptureTorchModeOff];
                    [device unlockForConfiguration];
                    [session stopRunning];
                    [NSThread sleepForTimeInterval:0.5f];
                    break;
                case MCGMorseCodeThreeSpaces:
                    //pause for 1500ms
                    [device lockForConfiguration:nil];
                    [device setTorchMode:AVCaptureTorchModeOff];
                    [device unlockForConfiguration];
                    [NSThread sleepForTimeInterval:1.5f];
                    break;
                default:
                    break;
            }
        }];
        
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
        [session stopRunning];
        
        
    }
}

- (void)playMorseCodeVibration:(NSArray*)morseCodeArray {
    
    NSMutableDictionary* patternsDict = [@{} mutableCopy];
    NSMutableArray* patternsArray = [@[] mutableCopy];
    
    
    [morseCodeArray enumerateObjectsUsingBlock:^(NSNumber * morseCodeNumber, NSUInteger idx, BOOL *stop) {
        
        [patternsArray addObject:[NSNumber numberWithBool:NO]]; //short pause
        [patternsArray addObject:[NSNumber numberWithInt:100]];
        
        switch ([morseCodeNumber integerValue]) {
            case MCGMorseCodeDit:
                [patternsArray addObject:@(YES)]; //vibrate for 500ms
                [patternsArray addObject:@(500)];
                break;
            case MCGMorseCodeDah:
                //vibrate for 1500ms
                [patternsArray addObject:@(YES)];
                [patternsArray addObject:@(1500)];
                break;
            case MCGMorseCodeSingleSpace:
                [patternsArray addObject:@(NO)]; //pause for 500ms
                [patternsArray addObject:@(500)];
                break;
            case MCGMorseCodeThreeSpaces:
                //pause for 1500ms
                [patternsArray addObject:@(NO)];
                [patternsArray addObject:@(1500)];
                break;
            default:
                break;
        }
    }];
    
    [patternsDict setObject:patternsArray forKey:@"VibePattern"];
    [patternsDict setObject:[NSNumber numberWithInt:1.0] forKey:@"Intensity"];
    
    // suppress warnings
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wall"
    AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
    
    AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate,nil,patternsDict);
#pragma clang diagnostic pop
    
}


- (void)playDitSound {
    AudioServicesPlaySystemSound(self.ditSoundID);
}

- (void)playDahSound {
    AudioServicesPlaySystemSound(self.dahSoundID);
}

#pragma mark - UI controls

- (IBAction)soundSwitchToggled:(UISwitch *)sender {
    self.enableSound = sender.isOn;
}

- (IBAction)vibrationSwitchToggled:(UISwitch *)sender {
    self.enableVibration = sender.isOn;
}

- (IBAction)flashSwitchToggled:(UISwitch *)sender {
    self.enableFlash = sender.isOn;
    
}



@end
