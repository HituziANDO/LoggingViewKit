//
//  LVKFMDatabaseQueue.m
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "LVKFMDatabase.h"
#import "LVKFMDatabaseQueue.h"

#if LVKFMDB_SQLITE_STANDALONE
#import <sqlite3/sqlite3.h>
#else
#import <sqlite3.h>
#endif

typedef NS_ENUM(NSInteger, LVKFMDBTransaction) {
    LVKFMDBTransactionExclusive,
    LVKFMDBTransactionDeferred,
    LVKFMDBTransactionImmediate,
};

/*
 *
 * Note: we call [self retain]; before using dispatch_sync, just incase
 * LVKFMDatabaseQueue is released on another thread and we're in the middle of doing
 * something in dispatch_sync
 *
 */

/*
 * A key used to associate the LVKFMDatabaseQueue object with the dispatch_queue_t it uses.
 * This in turn is used for deadlock detection by seeing if inDatabase: is called on
 * the queue's dispatch queue, which should not happen and causes a deadlock.
 */
static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;

@interface LVKFMDatabaseQueue () {
    dispatch_queue_t _queue;
    LVKFMDatabase *_db;
}
@end

@implementation LVKFMDatabaseQueue

+ (instancetype) databaseQueueWithPath:(NSString *)aPath {
    LVKFMDatabaseQueue *q = [[self alloc] initWithPath:aPath];

    LVKFMDBAutorelease(q);

    return q;
}

+ (instancetype) databaseQueueWithURL:(NSURL *)url {
    return [self databaseQueueWithPath:url.path];
}

+ (instancetype) databaseQueueWithPath:(NSString *)aPath flags:(int)openFlags {
    LVKFMDatabaseQueue *q = [[self alloc] initWithPath:aPath flags:openFlags];

    LVKFMDBAutorelease(q);

    return q;
}

+ (instancetype) databaseQueueWithURL:(NSURL *)url flags:(int)openFlags {
    return [self databaseQueueWithPath:url.path flags:openFlags];
}

+ (Class) databaseClass {
    return [LVKFMDatabase class];
}

- (instancetype) initWithURL:(NSURL *)url flags:(int)openFlags vfs:(NSString *)vfsName {
    return [self initWithPath:url.path flags:openFlags vfs:vfsName];
}

- (instancetype) initWithPath:(NSString *)aPath flags:(int)openFlags vfs:(NSString *)vfsName {
    self = [super init];

    if (self != nil) {

        _db = [[[self class] databaseClass] databaseWithPath:aPath];
        LVKFMDBRetain(_db);

#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:openFlags vfs:vfsName];
#else
        BOOL success = [_db open];
#endif
        if (!success) {
            NSLog(@"Could not create database queue for path %@", aPath);
            LVKFMDBRelease(self);
            return 0x00;
        }

        _path = LVKFMDBReturnRetained(aPath);

        _queue = dispatch_queue_create([[NSString stringWithFormat:@"lvkfmdb.%@", self] UTF8String], NULL);
        dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *) self, NULL);
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

- (instancetype) initWithURL:(NSURL *)url {
    return [self initWithPath:url.path];
}

- (instancetype) initWithPath:(NSString *)aPath {
    // default flags for sqlite3_open
    return [self initWithPath:aPath flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE vfs:nil];
}

- (instancetype) init {
    return [self initWithPath:nil];
}

- (void) dealloc {
    LVKFMDBRelease(_db);
    LVKFMDBRelease(_path);
    LVKFMDBRelease(_vfsName);

    if (_queue) {
        LVKFMDBDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) close {
    LVKFMDBRetain(self);
    dispatch_sync(_queue, ^() {
        [self->_db close];
        LVKFMDBRelease(_db);
        self->_db = 0x00;
    });
    LVKFMDBRelease(self);
}

- (void) interrupt {
    [[self database] interrupt];
}

- (LVKFMDatabase *) database {
    if (![_db isOpen]) {
        if (!_db) {
            _db = LVKFMDBReturnRetained([[[self class] databaseClass] databaseWithPath:_path]);
        }

#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:_openFlags vfs:_vfsName];
#else
        BOOL success = [_db open];
#endif
        if (!success) {
            NSLog(@"LVKFMDatabaseQueue could not reopen database for path %@", _path);
            LVKFMDBRelease(_db);
            _db = 0x00;
            return 0x00;
        }
    }

    return _db;
}

- (void) inDatabase:(__attribute__((noescape)) void (^)(LVKFMDatabase *db))block {
#ifndef NDEBUG
    /* Get the currently executing queue (which should probably be nil, but in theory could be another DB queue
     * and then check it against self to make sure we're not about to deadlock. */
    LVKFMDatabaseQueue *currentSyncQueue = (__bridge id) dispatch_get_specific(kDispatchQueueSpecificKey);
    assert(currentSyncQueue != self && "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock");
#endif

    LVKFMDBRetain(self);

    dispatch_sync(_queue, ^() {

        LVKFMDatabase *db = [self database];

        block(db);

        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [LVKFMDatabaseQueue inDatabase:]");

#if defined(DEBUG) && DEBUG
            NSSet *openSetCopy = LVKFMDBReturnAutoreleased([[db valueForKey:@"_openResultSets"] copy]);
            for (NSValue *rsInWrappedInATastyValueMeal in openSetCopy) {
                LVKFMResultSet *rs = (LVKFMResultSet *) [rsInWrappedInATastyValueMeal pointerValue];
                NSLog(@"query: '%@'", [rs query]);
            }
#endif
        }
    });

    LVKFMDBRelease(self);
}

- (void) beginTransaction:(LVKFMDBTransaction)transaction withBlock:(void (^)(LVKFMDatabase *db, BOOL *rollback))block {
    LVKFMDBRetain(self);
    dispatch_sync(_queue, ^() {

        BOOL shouldRollback = NO;

        switch (transaction) {
            case LVKFMDBTransactionExclusive:
                [[self database] beginTransaction];
                break;
            case LVKFMDBTransactionDeferred:
                [[self database] beginDeferredTransaction];
                break;
            case LVKFMDBTransactionImmediate:
                [[self database] beginImmediateTransaction];
                break;
        }

        block([self database], &shouldRollback);

        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    });

    LVKFMDBRelease(self);
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

- (void) inImmediateTransaction:(__attribute__((noescape)) void (^)(LVKFMDatabase * _Nonnull, BOOL * _Nonnull))block {
    [self beginTransaction:LVKFMDBTransactionImmediate withBlock:block];
}

- (NSError *) inSavePoint:(__attribute__((noescape)) void (^)(LVKFMDatabase *db, BOOL *rollback))block {
#if SQLITE_VERSION_NUMBER >= 3007000
    static unsigned long savePointIdx = 0;
    __block NSError *err = 0x00;
    LVKFMDBRetain(self);
    dispatch_sync(_queue, ^() {

        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];

        BOOL shouldRollback = NO;

        if ([[self database] startSavePointWithName:name error:&err]) {

            block([self database], &shouldRollback);

            if (shouldRollback) {
                // We need to rollback and release this savepoint to remove it
                [[self database] rollbackToSavePointWithName:name error:&err];
            }
            [[self database] releaseSavePointWithName:name error:&err];

        }
    });
    LVKFMDBRelease(self);
    return err;
#else
    NSString *errorMessage = NSLocalizedStringFromTable(@"Save point functions require SQLite 3.7", @"LVKFMDB", nil);
    if (_db.logsErrors) {
        NSLog(@"%@", errorMessage);
    }
    return [NSError errorWithDomain:@"FMDatabase" code:0 userInfo:@{ NSLocalizedDescriptionKey : errorMessage }];
#endif
}

- (BOOL) checkpoint:(LVKFMDBCheckpointMode)mode error:(NSError *__autoreleasing *)error
{
    return [self checkpoint:mode name:nil logFrameCount:NULL checkpointCount:NULL error:error];
}

- (BOOL) checkpoint:(LVKFMDBCheckpointMode)mode name:(NSString *)name error:(NSError *__autoreleasing *)error
{
    return [self checkpoint:mode name:name logFrameCount:NULL checkpointCount:NULL error:error];
}

- (BOOL) checkpoint:(LVKFMDBCheckpointMode)mode name:(NSString *)name logFrameCount:(int * _Nullable)logFrameCount checkpointCount:(int * _Nullable)checkpointCount error:(NSError *__autoreleasing _Nullable * _Nullable)error
{
    __block BOOL result;

    LVKFMDBRetain(self);
    dispatch_sync(_queue, ^() {
        result = [self.database checkpoint:mode name:name logFrameCount:logFrameCount checkpointCount:checkpointCount error:error];
    });
    LVKFMDBRelease(self);

    return result;
}

@end
