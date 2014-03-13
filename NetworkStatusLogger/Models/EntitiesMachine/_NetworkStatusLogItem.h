// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NetworkStatusLogItem.h instead.

#import <CoreData/CoreData.h>


extern const struct NetworkStatusLogItemAttributes {
	__unsafe_unretained NSString *connectivityStatus;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *synchronized;
} NetworkStatusLogItemAttributes;

extern const struct NetworkStatusLogItemRelationships {
} NetworkStatusLogItemRelationships;

extern const struct NetworkStatusLogItemFetchedProperties {
} NetworkStatusLogItemFetchedProperties;






@interface NetworkStatusLogItemID : NSManagedObjectID {}
@end

@interface _NetworkStatusLogItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NetworkStatusLogItemID*)objectID;





@property (nonatomic, strong) NSNumber* connectivityStatus;



@property int16_t connectivityStatusValue;
- (int16_t)connectivityStatusValue;
- (void)setConnectivityStatusValue:(int16_t)value_;

//- (BOOL)validateConnectivityStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* synchronized;



@property BOOL synchronizedValue;
- (BOOL)synchronizedValue;
- (void)setSynchronizedValue:(BOOL)value_;

//- (BOOL)validateSynchronized:(id*)value_ error:(NSError**)error_;






@end

@interface _NetworkStatusLogItem (CoreDataGeneratedAccessors)

@end

@interface _NetworkStatusLogItem (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveConnectivityStatus;
- (void)setPrimitiveConnectivityStatus:(NSNumber*)value;

- (int16_t)primitiveConnectivityStatusValue;
- (void)setPrimitiveConnectivityStatusValue:(int16_t)value_;




- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSNumber*)primitiveSynchronized;
- (void)setPrimitiveSynchronized:(NSNumber*)value;

- (BOOL)primitiveSynchronizedValue;
- (void)setPrimitiveSynchronizedValue:(BOOL)value_;




@end
