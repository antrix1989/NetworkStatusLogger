//
//  NSLNetworkStatusLogger.m
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/15/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

#import "NSLNetworkStatusLogger.h"
#import "NetworkStatusLogItem.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

NSString *const NSLLogItemDidSaveNotification = @"NSLLogItemDidSaveNotification";
NSString *const NSLLogItemDidSaveNotificationLogItem = @"NSLLogItemDidSaveNotificationLogItem";

@implementation NSLNetworkStatusLogger

#pragma mark - NSObject

- (void)dealloc
{
    [self stopLogging];
}

#pragma mark - Public

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)startLogging
{
    if (!self.managedObjectContext) {
        NSLog(@"Managed object context is nil!");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetworkConnectivityChangeNotification:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
}

- (void)stopLogging
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)onNetworkConnectivityChangeNotification:(NSNotification *)notification
{
    NSLog(@"%@", AFStringFromNetworkReachabilityStatus([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus));
    
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = self.managedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NetworkStatusLogItem.entityName inManagedObjectContext:temporaryContext];
    NetworkStatusLogItem *logItem = [[NetworkStatusLogItem alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:temporaryContext];
    
    logItem.createdDate = [NSDate date];
    
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            logItem.connectivityStatus = [NSNumber numberWithConnectivityStatus:NSLConnectivityStatusWiFi];
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            logItem.connectivityStatus = [NSNumber numberWithConnectivityStatus:NSLConnectivityStatusWWAN];
            break;
            
        default:
            logItem.connectivityStatus = [NSNumber numberWithConnectivityStatus:NSLConnectivityStatusNoConnection];
            break;
    }

    [temporaryContext saveSynchronously:NO toPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:NSLLogItemDidSaveNotification object:nil userInfo:@{NSLLogItemDidSaveNotificationLogItem:logItem}];
        }
    }];
}

@end
