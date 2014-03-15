//
//  NSLNetworkService.h
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/15/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

@class NetworkStatusLogItem;

@interface NSLNetworkService : NSObject

@property (strong, nonatomic) NSString *serverUrl;

+ (instancetype)sharedInstance;

- (void)synchronizeDbInContext:(NSManagedObjectContext *)managedObjectContext
         withCompletionHandler:(void (^)(BOOL success))completion;

@end
