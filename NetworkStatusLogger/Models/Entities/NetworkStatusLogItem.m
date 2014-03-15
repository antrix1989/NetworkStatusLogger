#import "NetworkStatusLogItem.h"

@interface NetworkStatusLogItem ()

@end

@implementation NetworkStatusLogItem

#pragma mark - Public

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.class.entityName inManagedObjectContext:context];
    
    self = [self initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
    
    return self;
}

- (void)saveInManagedObjectContext:(NSManagedObjectContext *)context
{
    [context insertObject:self];
    
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = context;
    
    [temporaryContext performBlock:^{
        // push to parent
        NSError *error;
        if (![temporaryContext save:&error]) {
            NSLog(@"Error: %@", error);
        }
        
        // save parent to disk asynchronously
        [context performBlock:^{
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Error: %@", error);
            }
        }];
    }];
}

@end

@implementation NSNumber (NSNumberEnum)

+ (NSNumber *)numberWithConnectivityStatus:(NSLConnectivityStatus)connectivityStatus
{
    return [NSNumber numberWithInt:(int)connectivityStatus];
}

- (NSLConnectivityStatus)connectivityStatusValue
{
    int intValue = [self intValue];
    NSAssert(intValue >= 0 && intValue <= 2, @"Unsupported entity type.");
    return (NSLConnectivityStatus)intValue;
}

@end
