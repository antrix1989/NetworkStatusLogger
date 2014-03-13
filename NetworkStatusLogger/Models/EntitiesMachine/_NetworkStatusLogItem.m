// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NetworkStatusLogItem.m instead.

#import "_NetworkStatusLogItem.h"

const struct NetworkStatusLogItemAttributes NetworkStatusLogItemAttributes = {
	.connectivityStatus = @"connectivityStatus",
	.createdDate = @"createdDate",
	.synchronized = @"synchronized",
};

const struct NetworkStatusLogItemRelationships NetworkStatusLogItemRelationships = {
};

const struct NetworkStatusLogItemFetchedProperties NetworkStatusLogItemFetchedProperties = {
};

@implementation NetworkStatusLogItemID
@end

@implementation _NetworkStatusLogItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"NetworkStatusLogItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"NetworkStatusLogItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"NetworkStatusLogItem" inManagedObjectContext:moc_];
}

- (NetworkStatusLogItemID*)objectID {
	return (NetworkStatusLogItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"connectivityStatusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"connectivityStatus"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"synchronizedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"synchronized"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic connectivityStatus;



- (int16_t)connectivityStatusValue {
	NSNumber *result = [self connectivityStatus];
	return [result shortValue];
}

- (void)setConnectivityStatusValue:(int16_t)value_ {
	[self setConnectivityStatus:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveConnectivityStatusValue {
	NSNumber *result = [self primitiveConnectivityStatus];
	return [result shortValue];
}

- (void)setPrimitiveConnectivityStatusValue:(int16_t)value_ {
	[self setPrimitiveConnectivityStatus:[NSNumber numberWithShort:value_]];
}





@dynamic createdDate;






@dynamic synchronized;



- (BOOL)synchronizedValue {
	NSNumber *result = [self synchronized];
	return [result boolValue];
}

- (void)setSynchronizedValue:(BOOL)value_ {
	[self setSynchronized:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSynchronizedValue {
	NSNumber *result = [self primitiveSynchronized];
	return [result boolValue];
}

- (void)setPrimitiveSynchronizedValue:(BOOL)value_ {
	[self setPrimitiveSynchronized:[NSNumber numberWithBool:value_]];
}










@end
