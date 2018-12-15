//
//  ViewController.m
//  LoggingViewSample
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright © 2018年 Hituzi Ando. All rights reserved.
//

#import <LoggingViewKit/LoggingViewKit.h>

#import "ViewController.h"

@interface ViewController () <LGVLoggingViewServiceDelegate>

@property (weak, nonatomic) IBOutlet LGVLabel *stepperLabel;
@property (weak, nonatomic) IBOutlet LGVView *sampleView;
@property (nonatomic) LGVButton *testButton;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];

    self.testButton = [[LGVButton alloc] initWithFrame:CGRectMake(0, 0, 100.f, 40.f)];
    self.testButton.loggingName = @"TestButton";
    self.testButton.logging = YES;
    self.testButton.touchableExtension = UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f);
    [self.testButton setTitle:@"Test" forState:UIControlStateNormal];
    [self.testButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.testButton addTarget:self
                        action:@selector(testButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.sampleView addSubview:self.testButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Enables the touched log of the label.
    self.stepperLabel.userInteractionEnabled = YES;

    [LGVLoggingViewService sharedService].delegate = self;
}

#pragma mark - IBAction

- (IBAction)stepperChanged:(id)sender {
    LGVStepper *stepper = (LGVStepper *) sender;
    self.stepperLabel.text = [NSString stringWithFormat:@"%.1lf", stepper.value];
}

- (void)testButtonPressed:(LGVButton *)sender {
    NSLog(@"%@ Pressed", sender.loggingName);
}

#pragma mark - LGVLoggingViewServiceDelegate

- (void)loggingViewService:(LGVLoggingViewService *)service
             saveLogOfView:(id <LGVLogging>)view
                 withEvent:(nullable UIEvent *)event
                      info:(NSDictionary *)info {

    NSLog(@"%@ %@ %@", view.loggingName, info, event);
}

@end
