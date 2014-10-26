//
//  Store.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "Store.h"
static Store *_staticStore;

@interface Store ()
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroundContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end
@implementation Store

+(Store *) staticStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticStore = [[Store alloc] init];
    });
    
    return _staticStore;
}

+(NSManagedObjectContext *)mainContext
{
    return self.staticStore.mainContext;
}

+(NSManagedObjectContext *)backgroundContext
{
    return self.staticStore.backgroundContext;
}

#pragma mark Fetching
+(NSManagedObject *)retrieveObjectWithEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate usingContext:(NSManagedObjectContext *)context
{
    return [self retrieveObjectWithEntityName:entityName withPredicate:predicate usingContext:context createIfNoneExists:YES];
}
+(NSManagedObject *)retrieveObjectWithEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate usingContext:(NSManagedObjectContext *)context createIfNoneExists:(BOOL)create
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    NSError * fetchError = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&fetchError];
    id object = nil;
    if(!fetchError)
    {
        if(results.count > 1)
            NSLog(@"%s: Warning: > 1 MOs were found for request. First one will be returned. Request: %@", __PRETTY_FUNCTION__, fetchRequest);
        
        object = [results firstObject];
        if(!object && create)
        {
            object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        }
    }
    else
        NSLog(@"%s: An error occurred while performing fetch request: %@", __PRETTY_FUNCTION__, fetchError);
    
    return object;
}
#pragma mark Lifecycle and lazy loading
-(NSManagedObjectContext *)mainContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    });
    return _mainContext;
}
-(NSManagedObjectContext *)backgroundContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    });
    return _backgroundContext;
}

-(id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privateQueueContextDidSave:)name:NSManagedObjectContextDidSaveNotification object:[self backgroundContext]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainQueueContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:[self mainContext]];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)privateQueueContextDidSave:(NSNotification *)notification
{
    @synchronized(self) {
        [self.mainContext performBlock:^{
            [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)mainQueueContextDidSave:(NSNotification *)notification
{
    @synchronized(self) {
        [self.backgroundContext performBlock:^{
            [self.backgroundContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}


#pragma mark - CoreData stack setup

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator)
    {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error = nil;
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:&error])
        {
            NSLog(@"Error adding persistent store. %@", error);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:APP_NAME withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSURL *)persistentStoreURL
{
    NSURL *appDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [appDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", APP_NAME]];
}

- (NSDictionary *)persistentStoreOptions
{
    return @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES, NSSQLitePragmasOption: @{@"synchronous": @"OFF"}};
}
@end