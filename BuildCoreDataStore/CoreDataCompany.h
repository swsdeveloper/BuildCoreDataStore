//
//  CoreDataCompany.h
//  BuildCoreDataStore
//
//  Created by Steven Shatz on 12/16/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataCompany : NSManagedObject

@property (nonatomic, retain) NSString *co_name;
@property (nonatomic, retain) NSString *co_logo;
@property (nonatomic, retain) NSString *co_stocksymbol;
@property (nonatomic, assign) BOOL co_deleted;
@property (nonatomic, retain) NSNumber *co_sortid;

@end
