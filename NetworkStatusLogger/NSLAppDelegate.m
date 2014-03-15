//
//  NSLAppDelegate.m
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/13/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

#import "NSLAppDelegate.h"
#import "NSLRootViewController.h"

static NSString *kDBName = @"NetworkStatusLogger";

@interface NSLAppDelegate ()

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *writerManagedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation NSLAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize writerManagedObjectContext = _writerManagedObjectContext;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLRootViewController *rootViewController = (NSLRootViewController *)self.window.rootViewController;
    rootViewController.managedObjectContext = self.managedObjectContext;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.parentContext = [self writerManagedObjectContext];
    
    return _managedObjectContext;
}

- (NSManagedObjectContext *)writerManagedObjectContext
{
    if (_writerManagedObjectContext) {
        return _writerManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _writerManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_writerManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _writerManagedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDBName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kDBName]];
    
    NSDictionary *options = @{
                              NSInferMappingModelAutomaticallyOption : @(YES),
                              NSMigratePersistentStoresAutomaticallyOption: @(YES),
                              NSSQLitePragmasOption: @{@"journal_mode": @"delete"}
                              };
    
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kDBName]];
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
