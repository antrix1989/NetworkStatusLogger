//
//  NSLRootViewController.m
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/13/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

#import "NSLRootViewController.h"
#import "NSLNetworkService.h"
#import "NSLNetworkStatusLogger.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface NSLRootViewController ()

@property (weak, nonatomic) IBOutlet UILabel *connectivityStatusLabel;
@property (weak, nonatomic) IBOutlet UITextField *serverAddressTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation NSLRootViewController

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetworkConnectivityChangeNotification:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLogItemDidSaveNotification:)
                                                 name:NSLLogItemDidSaveNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [NSLNetworkStatusLogger sharedInstance].managedObjectContext = self.managedObjectContext;
    [[NSLNetworkStatusLogger sharedInstance] startLogging];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - IBAction

- (IBAction)onConnectButtonTapped:(id)sender
{
    [NSLNetworkService sharedInstance].serverUrl = self.serverAddressTextField.text;
    
    [self.activityIndicator startAnimating];
    [[NSLNetworkService sharedInstance] synchronizeDbInContext:self.managedObjectContext withCompletionHandler:^(BOOL success) {
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - NSNotification

- (void)onNetworkConnectivityChangeNotification:(NSNotification *)notification
{
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            self.connectivityStatusLabel.text = NSLocalizedString(@"WiFi", nil);
            break;

        case AFNetworkReachabilityStatusReachableViaWWAN:
            self.connectivityStatusLabel.text = NSLocalizedString(@"3G", nil);
            break;

        default:
            self.connectivityStatusLabel.text = NSLocalizedString(@"NoConnection", nil);
            break;
    }
}

- (void)onLogItemDidSaveNotification:(NSNotification *)notification
{
    [self.activityIndicator startAnimating];
    [[NSLNetworkService sharedInstance] synchronizeDbInContext:self.managedObjectContext withCompletionHandler:^(BOOL success) {
        [self.activityIndicator stopAnimating];
    }];
}

@end
