//
//  Store.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "StringConstants.h"
#import "StatisticMO.h"

//convenience macros
#define MainContext [Store mainContext]
#define BackgroundContext [Store backgroundContext]
#define APP_NAME [NSBundle mainBundle].infoDictionary[@"CFBundleName"]

/**
 * @class Store
 * @description This is the class used primarily for setting up and interfacing with the underlying CoreData APIs. The Store owns 2 NSManagedObjectContexts: backgroundContext and mainContext. The rules for when to use one over the other are as follows:
    1) FRC's MUST use the mainContext, since the FRC is closely tied with UIKit elements (UITableView and UICollectionView).
    2) When performing save operations, prioritize backgroundContext over mainContext. While either can be used, we favor the backgroundContext in these scenarios so as to keep the main thread as free as possible. 
    3) When performing fetch operations without a save (other than an FRC, see #1), either context may be used. Both contexts are kept in sync with one another.
 */
@interface Store : NSObject

/**
 Returns the context associated with the main_thread queue. This context is required for FRCs and may optionally be used elsewhere. See rules above.
 @return The mainContext;
 */
+(NSManagedObjectContext *) mainContext;

/**
 Returns the context associated with a private background queue. This context is usually used for save operations and fetches(other than an FRC). See rules above.
 @return The backgroudContext;
 */
+(NSManagedObjectContext *) backgroundContext;

/**
 Fetches an NSManagedObject from the provided context that matches the predicate and entityName supplied. If an object is not found, this method inserts a new instance.
 @param entityName The name of the entity we are fetching.
 @param predicate The predicate to use for fetching the object.
 @param context The NSManagedObjectContext to search in.
 @return An NSManagedObject fetched from the provided context, or a new NSManagedObject just inserted since an existing one could not be found
 */
+(NSManagedObject *) retrieveObjectWithEntityName: (NSString *) entityName withPredicate: (NSPredicate *) predicate usingContext: (NSManagedObjectContext *) context;

/**
 Fetches an NSManagedObject from the provided context that matches the predicate and entityName supplied. If an object is not found, this method can optionally insert a new one.
 @param entityName The name of the entity we are fetching.
 @param predicate The predicate to use for fetching the object.
 @param context The NSManagedObjectContext to search in.
 @param create A BOOL indicating if a new MO should be inserted if an existing one matching the predicate cannot be found in the context.
 @return An NSManagedObject fetched from the provided context, or new NSManagedObject just inserted into the context if 'create' is YES and an existing MO could not be found.
 */
+(NSManagedObject *) retrieveObjectWithEntityName: (NSString *) entityName withPredicate: (NSPredicate *) predicate usingContext: (NSManagedObjectContext *) context createIfNoneExists: (BOOL) create;


@end