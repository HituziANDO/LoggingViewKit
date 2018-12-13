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

@property (weak, nonatomic) IBOutlet UIButton *sampleButton;

@property (nonatomic) UIButton *testButton;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];

    self.testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100.f, 40.f)];
    self.testButton.lgv_name = @"TestButton";
    self.testButton.lgv_logging = YES;
    [self.testButton setTitle:@"Test" forState:UIControlStateNormal];
    [self.testButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.testButton addTarget:self
                        action:@selector(testButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.lgv_logging = YES;

    [LGVLoggingViewService sharedService].delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.testButton.center = self.view.center;
}

- (void)testButtonPressed:(UIButton *)sender {
    NSLog(@"%@ Pressed", sender.lgv_name);
}

#pragma mark - LGVLoggingViewServiceDelegate

- (void)saveLogOfView:(UIView *)view withEvent:(nullable UIEvent *)event info:(NSDictionary *)info {
    NSLog(@"%@ %@", view.lgv_name, info);
}

@end
