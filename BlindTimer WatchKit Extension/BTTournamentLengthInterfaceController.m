//
//  BTTournamentLengthInterfaceController.m
//  BlindTimer
//
//  Created by Sebastien Arbogast on 23/11/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

#import "BTTournamentLengthInterfaceController.h"

@interface BTTournamentLengthInterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *tournamentLengthLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *tournamentLengthSlider;
@property (assign, nonatomic) NSUInteger tournamentLength;
@property (assign, nonatomic) NSUInteger minimumTournamentLength;
@property (assign, nonatomic) NSUInteger maximumTournamentLength;
@end

@implementation BTTournamentLengthInterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        self.minimumTournamentLength = 1;
        self.maximumTournamentLength = 6;
        self.tournamentLength = 2;
    }
    return self;
}

- (void)willActivate {
    [self.tournamentLengthLabel setText:[NSString stringWithFormat:@"%lu", self.tournamentLength]];
    [self.tournamentLengthSlider setValue:self.tournamentLength];
}

- (void)didDeactivate {
    
}

- (IBAction)numberOfPlayersSliderChanged:(float)value {
    self.tournamentLength = (NSUInteger)value;
    [self.tournamentLengthLabel setText:[NSString stringWithFormat:@"%lu", self.tournamentLength]];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.epseelon.blindtimer.BlindTimer.Documents"];
    [sharedDefaults setInteger:self.tournamentLength forKey:@"tournamentLength"];
    [sharedDefaults synchronize];
}

@end
