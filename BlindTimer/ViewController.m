//
//  ViewController.m
//  BlindTimer
//
//  Created by Sebastien Arbogast on 22/11/2014.
//  Copyright (c) 2014 Epseelon sprl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSTimer *pollTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pollDefaults:) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.pollTimer invalidate];
    
    [super viewDidDisappear:animated];
}

- (void)pollDefaults:(NSTimer*)timer{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.epseelon.blindtimer.BlindTimer.Documents"];
    BOOL blindsJustChanged = [defaults boolForKey:@"blindsJustChanged"];
    if(blindsJustChanged){
        [defaults setBool:NO forKey:@"blindsJustChanged"];
        
        UILocalNotification *endLocalNotification = [[UILocalNotification alloc] init];
        endLocalNotification.fireDate = [NSDate date];
        endLocalNotification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"Blinds just changed", @"")];
        endLocalNotification.soundName = UILocalNotificationDefaultSoundName;
        endLocalNotification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:endLocalNotification];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Blinds just changed", @"") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
        [alert show];
    } 
}
@end
