//
//  NSLRootViewController.m
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/13/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

#import "NSLRootViewController.h"
#import "NetworkStatusLogItem.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface NSLRootViewController ()

@property (weak, nonatomic) IBOutlet UILabel *connectivityStatusLabel;

@end

@implementation NSLRootViewController

#pragma mark - NSObject

- (id)init
{
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"%@", AFStringFromNetworkReachabilityStatus(status));
            
            NetworkStatusLogItem *logItem = [[NetworkStatusLogItem alloc] initInManagedObjectContext:self.managedObjectContext];
            logItem.createdDate = [NSDate date];
            
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    self.connectivityStatusLabel.text = NSLocalizedString(@"WiFi", nil);
                    logItem.connectivityStatus = [NSNumber numberWithConnectivityStatus:NSLConnectivityStatusWiFi];
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    self.connectivityStatusLabel.text = NSLocalizedString(@"3G", nil);
                    logItem.connectivityStatus = [NSNumber numberWithConnectivityStatus:NSLConnectivityStatusWWAN];
                    break;
                    
                default:
                    self.connectivityStatusLabel.text = NSLocalizedString(@"NoConnection", nil);
                    logItem.connectivityStatus = [NSNumber numberWithConnectivityStatus:NSLConnectivityStatusNoConnection];
                    break;
            }
            
            [logItem saveInManagedObjectContext:self.managedObjectContext];
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    
    return self;
}

#pragma mark - IBAction

- (IBAction)onConnectButtonTapped:(id)sender
{
}

@end
