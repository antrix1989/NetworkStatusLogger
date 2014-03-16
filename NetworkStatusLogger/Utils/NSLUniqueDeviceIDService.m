//
//  NSLUniqueDeviceIDService.m
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/16/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

#import "NSLUniqueDeviceIDService.h"
#import "SSKeychain.h"

NSString *const kServiceIdentifier = @"NSLUniqueDeviceIDService";
NSString *const kUserAccountIdentifier = @"user";

@implementation NSLUniqueDeviceIDService

#pragma mark - Public

+ (NSString *)uniqueDeviceID
{
    NSString *retrieveuuid = [SSKeychain passwordForService:kServiceIdentifier account:kUserAccountIdentifier];
    
    if (!retrieveuuid) {
        NSString *uuid  = [self createNewUUID];
        [SSKeychain setPassword:uuid forService:kServiceIdentifier account:kUserAccountIdentifier];
        retrieveuuid = uuid;
    }
    
    return retrieveuuid;
}

#pragma mark - Private

+ (NSString *)createNewUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end
