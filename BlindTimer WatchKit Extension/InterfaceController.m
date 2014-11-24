//
//  InterfaceController.m
//  BlindTimer WatchKit Extension
//
//  Created by Sebastien Arbogast on 22/11/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *minutesTimer;
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *secondsTimer;

@property (nonatomic, assign) NSUInteger roundLength;
@property (nonatomic, assign) NSUInteger elapsedSeconds;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *scheduledEndDate;
@property (assign, nonatomic) BOOL currentlyRunning;
@property (strong, nonatomic) NSTimer *oneMinuteBeforeEndTimer;
@property (strong, nonatomic) NSTimer *endTimer;

@property (strong, nonatomic) NSArray *smallBlinds;
@property (strong, nonatomic) NSArray *bigBlinds;
@property (assign, nonatomic) NSUInteger currentStage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *currentSmallBlindLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *currentBigBlindLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *nextSmallBlindLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *nextBigBlindLabel;

- (IBAction)startButtonTapped;
- (IBAction)stopButtonTapped;

@end


@implementation InterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        self.roundLength = 70;
        self.currentlyRunning = NO;
        self.elapsedSeconds = 0;
        
        self.currentStage = 0;
        
        [self addMenuItemWithItemIcon:WKMenuItemIconInfo title:NSLocalizedString(@"Settings", @"") action:@selector(settingsButtonTapped)];
        [self addMenuItemWithItemIcon:WKMenuItemIconPlay title:NSLocalizedString(@"Start", @"") action:@selector(startButtonTapped)];
        [self addMenuItemWithImageNamed:@"Stop" title:NSLocalizedString(@"Stop", @"") action:@selector(stopButtonTapped)];
        
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.epseelon.blindtimer.BlindTimer.Documents"];
        [sharedDefaults setObject:nil forKey:@"roundLength"];
        [sharedDefaults synchronize];
    }
    return self;
}

- (void)willActivate {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.epseelon.blindtimer.BlindTimer.Documents"];
    NSNumber *roundLengthNumber = [sharedDefaults objectForKey:@"roundLength"];
    if(roundLengthNumber){
        self.roundLength = [roundLengthNumber unsignedIntegerValue];
        self.smallBlinds = @[@5,@10,@20,@50,@100,@200,@400,@800];
        self.bigBlinds = @[@10,@20,@40,@100,@200,@400,@800,@1600];
    }
    
    NSDate *now = [NSDate date];
    self.scheduledEndDate = [now dateByAddingTimeInterval:(self.roundLength + 1)];
    [self.minutesTimer setDate:self.scheduledEndDate];
    [self.secondsTimer setDate:self.scheduledEndDate];
    [self.minutesTimer start];
    [self.secondsTimer start];
    [self.minutesTimer stop];
    [self.secondsTimer stop];
    
    if(self.roundLength <= 60){
        [self.secondsTimer setHidden:NO];
        [self.minutesTimer setHidden:YES];
    } else {
        [self.secondsTimer setHidden:YES];
        [self.minutesTimer setHidden:NO];
    }
    
    [self updateBlindLabels];
    
    if(self.smallBlinds.count == 0){
        [self presentControllerWithName:@"roundLength" context:nil];
    }
}

- (void)updateBlindLabels {
    int currentSmallBlind = [self.smallBlinds[self.currentStage] intValue];
    int currentBigBlind = [self.bigBlinds[self.currentStage] intValue];
    
    int nextSmallBlind = self.currentStage < self.smallBlinds.count - 1 ? [self.smallBlinds[self.currentStage + 1] intValue] : -1;
    int nextBigBlind = self.currentStage < self.bigBlinds.count - 1 ? [self.bigBlinds[self.currentStage + 1] intValue] : -1;
    [self.currentSmallBlindLabel setText:[NSString stringWithFormat:@"%d", currentSmallBlind]];
    [self.currentBigBlindLabel setText:[NSString stringWithFormat:@"%d", currentBigBlind]];
    if(nextSmallBlind > 0){
        [self.nextSmallBlindLabel setText:[NSString stringWithFormat:@"%d", nextSmallBlind]];
        [self.nextBigBlindLabel setText:[NSString stringWithFormat:@"%d", nextBigBlind]];
    }
}

- (void)didDeactivate {

}

- (IBAction)settingsButtonTapped {
    [self stopButtonTapped];
    [self presentControllerWithName:@"roundLength" context:nil];
}

- (IBAction)startButtonTapped {
    NSDate *now = [NSDate date];
    
    if(self.currentlyRunning){
        self.elapsedSeconds = [now timeIntervalSinceDate:self.startDate];
        [self.minutesTimer stop];
        [self.secondsTimer stop];
        
        [self.oneMinuteBeforeEndTimer invalidate];
        [self.endTimer invalidate];
        
        self.currentlyRunning = NO;
        
        [self clearAllMenuItems];
        [self addMenuItemWithItemIcon:WKMenuItemIconInfo title:NSLocalizedString(@"Settings", @"") action:@selector(settingsButtonTapped)];
        [self addMenuItemWithItemIcon:WKMenuItemIconPlay title:NSLocalizedString(@"Start", @"") action:@selector(startButtonTapped)];
        [self addMenuItemWithImageNamed:@"Stop" title:NSLocalizedString(@"Stop", @"") action:@selector(stopButtonTapped)];
    } else {
        NSUInteger remainingSeconds = self.roundLength - self.elapsedSeconds;
        self.startDate = now;
        self.scheduledEndDate = [now dateByAddingTimeInterval:remainingSeconds];
        
        [self.minutesTimer setDate:self.scheduledEndDate];
        [self.secondsTimer setDate:self.scheduledEndDate];
        [self.minutesTimer start];
        [self.secondsTimer start];
        
        if(remainingSeconds <= 60){
            [self.secondsTimer setHidden:NO];
            [self.minutesTimer setHidden:YES];
        } else {
            [self.secondsTimer setHidden:YES];
            [self.minutesTimer setHidden:NO];
        }
        
        if(self.roundLength - self.elapsedSeconds > 60){
            self.oneMinuteBeforeEndTimer = [NSTimer scheduledTimerWithTimeInterval:(remainingSeconds - 60) target:self selector:@selector(oneMinuteBeforeEnd:) userInfo:nil repeats:NO];
        }
        if(self.roundLength - self.elapsedSeconds > 0){
            self.endTimer = [NSTimer scheduledTimerWithTimeInterval:remainingSeconds target:self selector:@selector(end:) userInfo:nil repeats:NO];
        }
        
        self.currentlyRunning = YES;
        
        [self clearAllMenuItems];
        [self addMenuItemWithItemIcon:WKMenuItemIconInfo title:NSLocalizedString(@"Settings", @"") action:@selector(settingsButtonTapped)];
        [self addMenuItemWithItemIcon:WKMenuItemIconPause title:NSLocalizedString(@"Pause", @"") action:@selector(startButtonTapped)];
        [self addMenuItemWithImageNamed:@"Stop" title:NSLocalizedString(@"Stop", @"") action:@selector(stopButtonTapped)];
    }
}

- (void)oneMinuteBeforeEnd:(NSTimer*)timer {
    [self.minutesTimer setHidden:YES];
    [self.secondsTimer setHidden:NO];
    
    //TODO send local notification
}

- (void)end:(NSTimer*)timer {
    [self.secondsTimer stop];
    [self.minutesTimer stop];
    self.elapsedSeconds = 0;
    
    if(self.currentStage < self.smallBlinds.count){
        self.currentStage++;
        [self updateBlindLabels];
    }
    
    NSDate *now = [NSDate date];
    
    self.startDate = now;
    NSUInteger remainingSeconds = self.roundLength;
    self.scheduledEndDate = [now dateByAddingTimeInterval:remainingSeconds];
    
    [self notifyBlindChange];
    
    [self.minutesTimer setDate:self.scheduledEndDate];
    [self.secondsTimer setDate:self.scheduledEndDate];
    [self.minutesTimer start];
    [self.secondsTimer start];
    
    [self.oneMinuteBeforeEndTimer invalidate];
    [self.endTimer invalidate];
    if(self.roundLength - self.elapsedSeconds > 60){
        self.oneMinuteBeforeEndTimer = [NSTimer scheduledTimerWithTimeInterval:(remainingSeconds - 60) target:self selector:@selector(oneMinuteBeforeEnd:) userInfo:nil repeats:NO];
    }
    if(self.roundLength - self.elapsedSeconds > 0){
        self.endTimer = [NSTimer scheduledTimerWithTimeInterval:remainingSeconds target:self selector:@selector(end:) userInfo:nil repeats:NO];
    }
    
    if(remainingSeconds <= 60){
        [self.secondsTimer setHidden:NO];
        [self.minutesTimer setHidden:YES];
    } else {
        [self.secondsTimer setHidden:YES];
        [self.minutesTimer setHidden:NO];
    }
}

- (void)notifyBlindChange {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.epseelon.blindtimer.BlindTimer.Documents"];
    [sharedDefaults setBool:YES forKey:@"blindsJustChanged"];
    [sharedDefaults synchronize];
}

- (IBAction)stopButtonTapped {
    self.elapsedSeconds = 0;
    NSDate *now = [NSDate date];
    self.scheduledEndDate = [now dateByAddingTimeInterval:(self.roundLength + 1)];
    [self.minutesTimer setDate:self.scheduledEndDate];
    [self.secondsTimer setDate:self.scheduledEndDate];
    [self.minutesTimer start];
    [self.secondsTimer start];
    [self.minutesTimer stop];
    [self.secondsTimer stop];
    
    if(self.roundLength <= 60){
        [self.secondsTimer setHidden:NO];
        [self.minutesTimer setHidden:YES];
    } else {
        [self.secondsTimer setHidden:YES];
        [self.minutesTimer setHidden:NO];
    }
    
    [self.oneMinuteBeforeEndTimer invalidate];
    [self.endTimer invalidate];
    
    self.currentlyRunning = NO;
    
    self.currentStage = 0;
    [self updateBlindLabels];
    
    [self clearAllMenuItems];
    [self addMenuItemWithItemIcon:WKMenuItemIconInfo title:NSLocalizedString(@"Settings", @"") action:@selector(settingsButtonTapped)];
    [self addMenuItemWithItemIcon:WKMenuItemIconPlay title:NSLocalizedString(@"Start", @"") action:@selector(startButtonTapped)];
    [self addMenuItemWithImageNamed:@"Stop" title:NSLocalizedString(@"Stop", @"") action:@selector(stopButtonTapped)];
}

@end



