//
//  CacheObject+CoreDataProperties.h
//  DiscountAsciiWerehouse
//
//  Created by Matheus Ruschel on 8/15/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CacheObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CacheObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSString *keyValue;

@end

NS_ASSUME_NONNULL_END
