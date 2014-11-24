//
//  BTNumberOfPlayersInterfaceController.m
//  BlindTimer
//
//  Created by Sebastien Arbogast on 23/11/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

#import "BTNumberOfPlayersInterfaceController.h"

@interface BTNumberOfPlayersInterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *numberOfPlayersLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *numberOfPlayersSlider;
@property (assign, nonatomic) NSUInteger numberOfPlayers;
@property (assign, nonatomic) NSUInteger minimumNumberOfPlayers;
@property (assign, nonatomic) NSUInteger maximumNumberOfPlayers;
@end

@implementation BTNumberOfPlayersInterfaceController

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        self.minimumNumberOfPlayers = 2;
        self.maximumNumberOfPlayers = 10;
        self.numberOfPlayers = 5;
    }
    return self;
}

- (void)willActivate {
    [self.numberOfPlayersLabel setText:[NSString stringWithFormat:@"%lu", self.numberOfPlayers]];
    [self.numberOfPlayersSlider setValue:self.numberOfPlayers];
}

- (void)didDeactivate {
    
}

- (IBAction)numberOfPlayersSliderChanged:(float)value {
    self.numberOfPlayers = (NSUInteger)value;
    [self.numberOfPlayersLabel setText:[NSString stringWithFormat:@"%lu", self.numberOfPlayers]];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.epseelon.blindtimer.BlindTimer.Documents"];
    [sharedDefaults setInteger:self.numberOfPlayers forKey:@"numberOfPlayers"];
    [sharedDefaults synchronize];
}

@end
