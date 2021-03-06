//
//  FISViewController.m
//  theFinalCountdown
//
//  Created by Joe Burgess on 7/9/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import "DKCircleButton.h"

@interface FISViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (strong, nonatomic) NSTimer *countdownTimer;
@property (nonatomic) NSInteger startingSeconds;
@property (weak, nonatomic) IBOutlet DKCircleButton *startButton;
@property (weak, nonatomic) IBOutlet DKCircleButton *pauseButton;

//@property (strong, nonatomic) DKCircleButton *startButton;
//@property (strong, nonatomic) DKCircleButton *pauseButton;

@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.timeText.adjustsFontSizeToFitWidth = YES;
    
    self.startButton.animateTap = NO; //ill allow the animation for the pause button
   	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pauseTapped:(id)sender {
    [self stopTimer];
    
    if ( [((UIButton *)sender).titleLabel.text isEqualToString:@"Pause"] ) {
        [sender setTitle:@"Resume" forState:UIControlStateNormal];
        [self stopTimer];
        
    }else {
        self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
}
- (IBAction)startTapped:(id)sender {
    self.datePicker.hidden = YES;
    
    if ([((UIButton *)sender).titleLabel.text isEqualToString:@"Start"]) {
        [sender setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.startButton setBorderColor:[UIColor redColor]];
        [self.startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self.startButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        ((UIButton *)sender).tintColor = [UIColor redColor];
        self.pauseButton.enabled = YES;
        self.timeText.hidden = NO;
        
        
        self.startingSeconds = [self.datePicker countDownDuration];
        // target:gonna call a method to invalidate sleep timer
        self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        
    } else {
        [self stopTimer];
        self.startingSeconds = 0;
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        //((UIButton *)sender).tintColor = [UIColor greenColor];  // :)
        [self.startButton setBorderColor:[UIColor greenColor]];
        [self.startButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [self.startButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        self.pauseButton.enabled = NO;
        self.timeText.hidden = YES;
        self.datePicker.hidden = NO;
    }
}

-(void)updateTimer:(NSTimer *)timer {
    
    if (self.startingSeconds <= 0) {
        [self stopTimer];
    }
    else {
        self.timeText.text = [self timeFormatted:self.startingSeconds];
        NSLog(@"Timer is %@", [self timeFormatted:self.startingSeconds]);
        self.startingSeconds--;
    }
}

-(void)stopTimer {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

- (NSString *)timeFormatted:(NSUInteger)totalSeconds
{
    
    NSUInteger seconds = totalSeconds % 60;
    NSUInteger minutes = (totalSeconds / 60) % 60;
    NSUInteger hours = totalSeconds / 3600;
    
    return hours == 0 ? [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)minutes, (unsigned long)seconds] : [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (size.width > size.height) { //we should be in landscape mode!
        self.timeText.hidden = NO;
    }
}

@end
