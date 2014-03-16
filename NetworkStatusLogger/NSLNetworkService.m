//
//  NSLNetworkService.m
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/15/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

#import "NSLNetworkService.h"
#import "NetworkStatusLogItem.h"
#import "AFNetworking.h"

@implementation NSLNetworkService

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

- (void)synchronizeDbInContext:(NSManagedObjectContext *)managedObjectContext
         withCompletionHandler:(void (^)(BOOL success))completion;
{
    if (!self.serverUrl && completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(NO);
        });
        
        return;
    }
    
    if (!self.serverUrl) {
        return;
    }
    
    // Cancell all not finished operations if we have some.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    
    // Find all not synchronized log items.
    NSArray *logItems = [managedObjectContext fetchObjectsForEntityName:NetworkStatusLogItem.entityName withPredicate:[NSPredicate predicateWithFormat:@"synchronized == NO"]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:YES];
    logItems = [logItems sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    // Start synchronyzation.
    NSMutableArray *mutableOperations = [NSMutableArray array];
    for (NetworkStatusLogItem *logItem in logItems) {
        AFHTTPRequestOperation *operation = [self getRequestOperationForLogItem:logItem withContext:managedObjectContext];
        
        [mutableOperations addObject:operation];
    }
    
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:nil completionBlock:^(NSArray *operations) {
        if (completion) {
            completion(YES);
        }
    }];
    
    [manager.operationQueue addOperations:operations waitUntilFinished:NO];
}

#pragma mark - Private

- (AFHTTPRequestOperation *)getRequestOperationForLogItem:(NetworkStatusLogItem *)logItem
                                              withContext:(NSManagedObjectContext *)managedObjectContext
{
    NSDictionary *parameters = @{@"type":logItem.connectivityStatus, @"unique_id":@1};
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:self.serverUrl parameters:parameters error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Synchronized log item with status %@ dated %@", logItem.connectivityStatus, logItem.createdDate);
        NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        temporaryContext.parentContext = managedObjectContext;
        
        NetworkStatusLogItem *localLogItem = (NetworkStatusLogItem *)[temporaryContext objectWithID:logItem.objectID];
        localLogItem.synchronized = @YES;
        [temporaryContext saveSynchronously:YES toPersistentStoreWithCompletion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return operation;
}

@end
