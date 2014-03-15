//
//  NSLNetworkStatusLogger.h
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/15/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

extern NSString *const NSLLogItemDidSaveNotification;
extern NSString *const NSLLogItemDidSaveNotificationLogItem;

@interface NSLNetworkStatusLogger : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedInstance;

- (void)startLogging;
- (void)stopLogging;

@end
