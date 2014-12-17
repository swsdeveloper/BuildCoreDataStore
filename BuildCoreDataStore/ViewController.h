//
//  ViewController.h
//  BuildCoreDataStore
//
//  Created by Steven Shatz on 12/16/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface ViewController : UIViewController

@property(nonatomic) NSManagedObjectContext *context;

@property(nonatomic) NSManagedObjectModel *model;

- (void)initModelContext;

- (NSString *)archivePath;

- (void)loadInitialData;

@end

