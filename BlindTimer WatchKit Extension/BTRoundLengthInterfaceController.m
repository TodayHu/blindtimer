//
//  BTRoundLengthInterfaceController.m
//  BlindTimer
//
//  Created by Sebastien Arbogast on 23/11/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

#import "BTRoundLengthInterfaceController.h"
@interface BTRoundLengthInterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *roundLengthLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *roundLengthSlider;
@property (nonatomic, assign) NSUInteger roundLength;

@end

@implementation BTRoundLengthInterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        self.roundLength = 10;
    }
    return self;
}

- (void)willActivate {
    [self.roundLengthLabel setText:[NSString stringWithFormat:@"%lu", self.roundLength]];
    [self.roundLengthSlider setValue:self.roundLength];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.epseelon.blindtimer.BlindTimer.Documents"];
    [sharedDefaults setObject:@(self.roundLength) forKey:@"roundLength"];
    [sharedDefaults synchronize];
}

- (void)didDeactivate {
    
}

- (IBAction)roundLengthSliderChanged:(float)value {
    self.roundLength = (NSUInteger)value;
    [self.roundLengthLabel setText:[NSString stringWithFormat:@"%lu", self.roundLength]];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.epseelon.blindtimer.BlindTimer.Documents"];
    [sharedDefaults setObject:@(self.roundLength) forKey:@"roundLength"];
    [sharedDefaults synchronize];
}

- (IBAction)okButtonTapped {
    [self dismissController];
}
@end
