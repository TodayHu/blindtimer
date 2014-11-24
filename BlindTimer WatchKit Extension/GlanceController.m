//
//  GlanceController.m
//  BlindTimer WatchKit Extension
//
//  Created by Sebastien Arbogast on 22/11/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

#import "GlanceController.h"


@interface GlanceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *minutesTimer;
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *secondsTimer;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *currentSmallBlindLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *currentBigBlindLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *nextSmallBlindLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *nextBigBlindLabel;

@end


@implementation GlanceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        
    }
    return self;
}

- (void)willActivate {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.epseelon.blindtimer.BlindTimer.Documents"];
    NSNumber *currentSmallBlindNumber = [sharedDefaults objectForKey:@"currentSmallBlind"];
    NSNumber *currentBigBlindNumber = [sharedDefaults objectForKey:@"currentBigBlind"];
    NSNumber *nextSmallBlindNumber = [sharedDefaults objectForKey:@"nextSmallBlind"];
    NSNumber *nextBigBlindNumber = [sharedDefaults objectForKey:@"nextBigBlind"];
    if(currentSmallBlindNumber){
        [self.currentSmallBlindLabel setText:[NSString stringWithFormat:@"%d", [currentSmallBlindNumber intValue]]];
    } else {
        [self.currentSmallBlindLabel setText:@""];
    }
    
    if(currentBigBlindNumber){
        [self.currentBigBlindLabel setText:[NSString stringWithFormat:@"%d", [currentBigBlindNumber intValue]]];
    } else {
        [self.currentBigBlindLabel setText:@""];
    }
    
    if(nextSmallBlindNumber){
        [self.nextSmallBlindLabel setText:[NSString stringWithFormat:@"%d", [nextSmallBlindNumber intValue]]];
    } else {
        [self.nextSmallBlindLabel setText:@""];
    }
    
    if(nextBigBlindNumber){
        [self.nextBigBlindLabel setText:[NSString stringWithFormat:@"%d", [nextBigBlindNumber intValue]]];
    } else {
        [self.nextBigBlindLabel setText:@""];
    }
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    NSLog(@"%@ did deactivate", self);
}

@end



