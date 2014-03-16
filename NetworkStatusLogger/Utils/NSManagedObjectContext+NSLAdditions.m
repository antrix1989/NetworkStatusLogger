//
//  NSManagedObjectContext+NSLAdditions.m
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/15/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

#import "NSManagedObjectContext+NSLAdditions.h"

@implementation NSManagedObjectContext (NSLAdditions)

#pragma mark - Public

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)stringOrPredicate, ...
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:newEntityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    if (stringOrPredicate) {
        NSPredicate *predicate;
        if ([stringOrPredicate isKindOfClass:[NSString class]]) {
            va_list variadicArguments;
            va_start(variadicArguments, stringOrPredicate);
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate
                                               arguments:variadicArguments];
            va_end(variadicArguments);
        } else {
            NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
                      @"Second parameter passed to %s is of unexpected class %@",
                      sel_getName(_cmd), NSStringFromClass([stringOrPredicate class]));
            predicate = (NSPredicate *)stringOrPredicate;
        }
        
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    
    return results;
}

- (void)saveSynchronously:(BOOL)synchronously toPersistentStoreWithCompletion:(NSLSaveCompletionHandler)completion
{
    if (![self hasChanges]) {
        NSLog(@"No changes in context.");
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, nil);
            });
        }
        
        return;
    }
    
    id saveBlock = ^{
        NSError *error = nil;
        BOOL saved = NO;
        
        @try {
            saved = [self save:&error];
        } @catch(NSException *exception) {
            NSLog(@"Unable to perform save: %@", (id)[exception userInfo] ? : (id)[exception reason]);
        } @finally {
            if (!saved) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"Error: %@", error);
                        completion(saved, error);
                    });
                }
                return;
            }
            
            if ([self parentContext]) {
                [[self parentContext] saveSynchronously:synchronously toPersistentStoreWithCompletion:completion];
            } else {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(saved, error);
                    });
                }
            }
        }
    };
    
    if (synchronously) {
        [self performBlockAndWait:saveBlock];
    } else {
        [self performBlock:saveBlock];
    }
}

@end
