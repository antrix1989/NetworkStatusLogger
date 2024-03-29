#import "_NetworkStatusLogItem.h"

@interface NetworkStatusLogItem : _NetworkStatusLogItem {}

@end

typedef NS_ENUM(NSInteger, NSLConnectivityStatus)
{
    NSLConnectivityStatusNoConnection = 0,
    NSLConnectivityStatusWWAN = 1,
    NSLConnectivityStatusWiFi = 2,
};

@interface NSNumber (NSLConnectivityStatus)

+ (NSNumber *)numberWithConnectivityStatus:(NSLConnectivityStatus)connectivityStatus;
- (NSLConnectivityStatus)connectivityStatusValue;

@end