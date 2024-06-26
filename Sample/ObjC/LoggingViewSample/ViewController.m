//
//  ViewController.m
//  LoggingViewSample
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright © 2018年 Hituzi Ando. All rights reserved.
//

#import <LoggingViewKit/LoggingViewKit-Swift.h>
#import <LoggingViewKit/LoggingViewKit.h>

#import "ViewController.h"

@interface ViewController () <LGVLoggingViewServiceDelegate>

@property (weak, nonatomic) IBOutlet LGVLabel *stepperLabel;
@property (weak, nonatomic) IBOutlet LGVView *sampleView;
@property (nonatomic) LGVButton *testButton;
@property (nonatomic) UIButton *getLogButton;

@end

@implementation ViewController

- (void) loadView {
    [super loadView];

    self.testButton = [[LGVButton alloc] initWithFrame:CGRectMake(0, 0, 100.f, 40.f)];
    self.testButton.loggingName = @"TestButton";
    self.testButton.logging = YES;
    self.testButton.touchableExtension = UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f);
    self.testButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.7f];
    [self.testButton setTitle:@"Test" forState:UIControlStateNormal];
    [self.testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.testButton addTarget:self
                        action:@selector(testButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.sampleView addSubview:self.testButton];

    self.getLogButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44.f, 100.f, 40.f)];
    self.getLogButton.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:.7f];
    [self.getLogButton setTitle:@"Get Log" forState:UIControlStateNormal];
    [self.getLogButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.getLogButton addTarget:self
                          action:@selector(getLogButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.sampleView addSubview:self.getLogButton];
}

- (void) viewDidLoad {
    [super viewDidLoad];

    [LGVLoggingViewService sharedService].delegate = self;

    // Deletes all logs.
//    [[LGVLoggingViewService sharedService] deleteAllLogs];

    // Records viewDidLoad as the custom event.
    LGVLoggingAttribute *attr = [LGVLoggingAttribute attributeWithName:@"ViewController"];
    [[LGVLoggingViewService sharedService] customEvent:@"viewDidLoad" attribute:attr];

#ifdef DEBUG
    // Dumps the hierarchy of the root view.
    [LGVViewHierarchy dump:self.view];
#endif
}

#pragma mark - IBAction

- (IBAction) stepperChanged:(id)sender {
    LGVStepper *stepper = (LGVStepper *) sender;

    self.stepperLabel.text = [NSString stringWithFormat:@"%.1lf", stepper.value];
}

- (void) testButtonPressed:(LGVButton *)sender {
    NSLog(@"%@ Pressed", sender.loggingName);

    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    LGVFileDestination *destination = [LGVFileDestination destinationWithFile:@"debug.log"
                                                                  inDirectory:docDir
                                                                        error:NULL];
    [LVKLogViewController showFromViewController:self withSourceFile:destination];
}

- (void) getLogButtonPressed:(id)sender {
    // Records a click event.
    LGVLoggingAttribute *attr = [LGVLoggingAttribute attributeWithView:sender
                                                                  name:@"GetLogButton"
                                                        loggingEnabled:YES];

    attr.info = @{ @"more-info": @"test" };
    [[LGVLoggingViewService sharedService] click:attr];

    NSLog(@"All Logs: %@", [[LGVLoggingViewService sharedService] allLogs]);
    NSLog(@"Custom Event Logs: %@", [[LGVLoggingViewService sharedService] logsByEventType:@"viewDidLoad"]);
}

#pragma mark - LGVLoggingViewServiceDelegate

- (void) loggingViewService:(LGVLoggingViewService *)service
                willSaveLog:(LGVLog *)log
                  attribute:(LGVLoggingAttribute *)attribute {

}

- (void) loggingViewService:(LGVLoggingViewService *)service
                 didSaveLog:(LGVLog *)log
                  attribute:(LGVLoggingAttribute *)attribute
                      error:(LGVError *)error {

}

@end
