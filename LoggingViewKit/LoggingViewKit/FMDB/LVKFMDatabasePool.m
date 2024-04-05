//
//  LVKFMDatabasePool.m
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#if LVKFMDB_SQLITE_STANDALONE
#import <sqlite3/sqlite3.h>
#else
#import <sqlite3.h>
#endif

#import "LVKFMDatabase.h"
#import "LVKFMDatabasePool.h"

typedef NS_ENUM(NSInteger, LVKFMDBTransaction) {
    LVKFMDBTransactionExclusive,
    LVKFMDBTransactionDeferred,
    LVKFMDBTransactionImmediate,
};

@interface LVKFMDatabasePool () {
    dispatch_queue_t _lockQueue;

    NSMutableArray *_databaseInPool;
    NSMutableArray *_databaseOutPool;
}

- (void) pushDatabaseBackInPool:(LVKFMDatabase *)db;
- (LVKFMDatabase *) db;

@end


@implementation LVKFMDatabasePool
@synthesize path = _path;
@synthesize delegate = _delegate;
@synthesize maximumNumberOfDatabasesToCreate = _maximumNumberOfDatabasesToCreate;
@synthesize openFlags = _openFlags;


+ (instancetype) databasePoolWithPath:(NSString *)aPath {
    return LVKFMDBReturnAutoreleased([[self alloc] initWithPath:aPath]);
}

+ (instancetype) databasePoolWithURL:(NSURL *)url {
    return LVKFMDBReturnAutoreleased([[self alloc] initWithPath:url.path]);
}

+ (instancetype) databasePoolWithPath:(NSString *)aPath flags:(int)openFlags {
    return LVKFMDBReturnAutoreleased([[self alloc] initWithPath:aPath flags:openFlags]);
}

+ (instancetype) databasePoolWithURL:(NSURL *)url flags:(int)openFlags {
    return LVKFMDBReturnAutoreleased([[self alloc] initWithPath:url.path flags:openFlags]);
}

- (instancetype) initWithURL:(NSURL *)url flags:(int)openFlags vfs:(NSString *)vfsName {
    return [self initWithPath:url.path flags:openFlags vfs:vfsName];
}

- (instancetype) initWithPath:(NSString *)aPath flags:(int)openFlags vfs:(NSString *)vfsName {

    self = [super init];

    if (self != nil) {
        _path = [aPath copy];
        _lockQueue = dispatch_queue_create([[NSString stringWithFormat:@"lvkfmdb.%@", self] UTF8String], NULL);
        _databaseInPool = LVKFMDBReturnRetained([NSMutableArray array]);
        _databaseOutPool = LVKFMDBReturnRetained([NSMutableArray array]);
        _openFlags = openFlags;
        _vfsName = [vfsName copy];
    }

    return self;
}

- (instancetype) initWithPath:(NSString *)aPath flags:(int)openFlags {
    return [self initWithPath:aPath flags:openFlags vfs:nil];
}

- (instancetype) initWithURL:(NSURL *)url flags:(int)openFlags {
    return [self initWithPath:url.path flags:openFlags vfs:nil];
}

- (instancetype) initWithPath:(NSString *)aPath {
    // default flags for sqlite3_open
    return [self initWithPath:aPath flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE];
}

- (instancetype) initWithURL:(NSURL *)url {
    return [self initWithPath:url.path];
}

- (instancetype) init {
    return [self initWithPath:nil];
}

+ (Class) databaseClass {
    return [LVKFMDatabase class];
}

- (void) dealloc {

    _delegate = 0x00;
    LVKFMDBRelease(_path);
    LVKFMDBRelease(_databaseInPool);
    LVKFMDBRelease(_databaseOutPool);
    LVKFMDBRelease(_vfsName);

    if (_lockQueue) {
        LVKFMDBDispatchQueueRelease(_lockQueue);
        _lockQueue = 0x00;
    }
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


- (void) executeLocked:(void (^)(void))aBlock {
    dispatch_sync(_lockQueue, aBlock);
}

- (void) pushDatabaseBackInPool:(LVKFMDatabase *)db {

    if (!db) { // db can be null if we set an upper bound on the # of databases to create.
        return;
    }

    [self executeLocked:^() {

         if ([self->_databaseInPool containsObject:db]) {
             [[NSException exceptionWithName:@"Database already in pool" reason:@"The LVKFMDatabase being put back into the pool is already present in the pool" userInfo:nil] raise];
         }

         [self->_databaseInPool addObject:db];
         [self->_databaseOutPool removeObject:db];

     }];
}

- (LVKFMDatabase *) db {

    __block LVKFMDatabase *db;


    [self executeLocked:^() {
         db = [self->_databaseInPool lastObject];

         BOOL shouldNotifyDelegate = NO;

         if (db) {
             [self->_databaseOutPool addObject:db];
             [self->_databaseInPool removeLastObject];
         }
         else {

             if (self->_maximumNumberOfDatabasesToCreate) {
                 NSUInteger currentCount = [self->_databaseOutPool count] + [self->_databaseInPool count];

                 if (currentCount >= self->_maximumNumberOfDatabasesToCreate) {
                     NSLog(@"Maximum number of databases (%ld) has already been reached!", (long) currentCount);
                     return;
                 }
             }

             db = [[[self class] databaseClass] databaseWithPath:self->_path];
             shouldNotifyDelegate = YES;
         }

         // This ensures that the db is opened before returning
#if SQLITE_VERSION_NUMBER >= 3005000
         BOOL success = [db openWithFlags:self->_openFlags vfs:self->_vfsName];
#else
         BOOL success = [db open];
#endif
         if (success) {
             if ([self->_delegate respondsToSelector:@selector(databasePool:shouldAddDatabaseToPool:)] && ![self->_delegate databasePool:self shouldAddDatabaseToPool:db]) {
                 [db close];
                 db = 0x00;
             }
             else {
                 // It should not get added in the pool twice if lastObject was found
                 if (![self->_databaseOutPool containsObject:db]) {
                     [self->_databaseOutPool addObject:db];

                     if (shouldNotifyDelegate && [self->_delegate respondsToSelector:@selector(databasePool:didAddDatabase:)]) {
                         [self->_delegate databasePool:self didAddDatabase:db];
                     }
                 }
             }
         }
         else {
             NSLog(@"Could not open up the database at path %@", self->_path);
             db = 0x00;
         }
     }];

    return db;
}

- (NSUInteger) countOfCheckedInDatabases {

    __block NSUInteger count;

    [self executeLocked:^() {
         count = [self->_databaseInPool count];
     }];

    return count;
}

- (NSUInteger) countOfCheckedOutDatabases {

    __block NSUInteger count;

    [self executeLocked:^() {
         count = [self->_databaseOutPool count];
     }];

    return count;
}

- (NSUInteger) countOfOpenDatabases {
    __block NSUInteger count;

    [self executeLocked:^() {
         count = [self->_databaseOutPool count] + [self->_databaseInPool count];
     }];

    return count;
}

- (void) releaseAllDatabases {
    [self executeLocked:^() {
         [self->_databaseOutPool removeAllObjects];
         [self->_databaseInPool removeAllObjects];
     }];
}

- (void) inDatabase:(__attribute__((noescape)) void (^)(LVKFMDatabase *db))block {

    LVKFMDatabase *db = [self db];

    block(db);

    [self pushDatabaseBackInPool:db];
}

- (void) beginTransaction:(LVKFMDBTransaction)transaction withBlock:(void (^)(LVKFMDatabase *db, BOOL *rollback))block {

    BOOL shouldRollback = NO;

    LVKFMDatabase *db = [self db];

    switch (transaction) {
        case LVKFMDBTransactionExclusive:
            [db beginTransaction];
            break;
        case LVKFMDBTransactionDeferred:
            [db beginDeferredTransaction];
            break;
        case LVKFMDBTransactionImmediate:
            [db beginImmediateTransaction];
            break;
    }


    block(db, &shouldRollback);

    if (shouldRollback) {
        [db rollback];
    }
    else {
        [db commit];
    }

    [self pushDatabaseBackInPool:db];
}

- (void) inTransaction:(__attribute__((noescape)) void (^)(LVKFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:LVKFMDBTransactionExclusive withBlock:block];
}

- (void) inDeferredTransaction:(__attribute__((noescape)) void (^)(LVKFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:LVKFMDBTransactionDeferred withBlock:block];
}

- (void) inExclusiveTransaction:(__attribute__((noescape)) void (^)(LVKFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:LVKFMDBTransactionExclusive withBlock:block];
}

- (void) inImmediateTransaction:(__attribute__((noescape)) void (^)(LVKFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:LVKFMDBTransactionImmediate withBlock:block];
}

- (NSError *) inSavePoint:(__attribute__((noescape)) void (^)(LVKFMDatabase *db, BOOL *rollback))block {
#if SQLITE_VERSION_NUMBER >= 3007000
    static unsigned long savePointIdx = 0;

    NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];

    BOOL shouldRollback = NO;

    LVKFMDatabase *db = [self db];

    NSError *err = 0x00;

    if (![db startSavePointWithName:name error:&err]) {
        [self pushDatabaseBackInPool:db];
        return err;
    }

    block(db, &shouldRollback);

    if (shouldRollback) {
        // We need to rollback and release this savepoint to remove it
        [db rollbackToSavePointWithName:name error:&err];
    }
    [db releaseSavePointWithName:name error:&err];

    [self pushDatabaseBackInPool:db];

    return err;
#else
    NSString *errorMessage = NSLocalizedStringFromTable(@"Save point functions require SQLite 3.7", @"LVKFMDB", nil);
    if (self.logsErrors) {
        NSLog(@"%@", errorMessage);
    }
    return [NSError errorWithDomain:@"FMDatabase" code:0 userInfo:@{ NSLocalizedDescriptionKey : errorMessage }];
#endif
}

@end
