#import "NetworkStatusLogItem.h"

@interface NetworkStatusLogItem ()

@end

@implementation NetworkStatusLogItem

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
