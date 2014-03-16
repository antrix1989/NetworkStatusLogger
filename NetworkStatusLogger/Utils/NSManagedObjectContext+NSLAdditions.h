//
//  NSManagedObjectContext+NSLAdditions.h
//  NetworkStatusLogger
//
//  Created by Sergey Demchenko on 3/15/14.
//  Copyright (c) 2014 Sergey Demchenko. All rights reserved.
//

typedef void (^NSLSaveCompletionHandler)(BOOL success, NSError *error);

@interface NSManagedObjectContext (NSLAdditions)

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)stringOrPredicate, ...;

- (void)saveSynchronously:(BOOL)synchronously toPersistentStoreWithCompletion:(NSLSaveCompletionHandler)completion;

@end
