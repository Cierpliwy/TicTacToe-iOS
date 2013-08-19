//
// Created by Antoni Kędracki, Polidea
//

#import "PLGame.h"

@interface PLGame ()
@property(nonatomic, assign, readwrite) PLGameState state;
@property (nonatomic, strong, readwrite) NSString * ownerId;
@property (nonatomic, strong, readwrite) NSString * challengerId;
@property (nonatomic, assign, readwrite) PLGameFieldState nextPlayer;
@end

@implementation PLGame {

@private
    NSMutableArray *_fields;
}

@synthesize ownerId = _ownerId;
@synthesize challengerId = _challengerId;

@synthesize state = _state;

@synthesize nextPlayer = _nextPlayer;

int const PLGameFieldCount = 9;

- (id)initWithOwnerId:(NSString *)ownerId {
    self = [super init];
    if (self) {
        self.ownerId = ownerId;
        self.challengerId = nil;
        self.state = PLGameStatePending;
        self.nextPlayer = PLGameFieldStateNone;
        _fields = [NSMutableArray arrayWithCapacity:PLGameFieldCount];
        for (int i = 0; i < PLGameFieldCount; ++i) {
            [_fields addObject:@(PLGameFieldStateNone)];
        }
    }

    return self;
}

- (PLGameFieldState)fieldState:(NSUInteger)field {
    if (field < 0 || field >= PLGameFieldCount) {
        @throw [NSException exceptionWithName:@"IndexOutOfBounds"
                                       reason:@"field index out of valid range"
                                     userInfo:nil];
    }
    return (PLGameFieldState) [[_fields objectAtIndex:field] integerValue];
}

- (void)performMove:(NSUInteger)field {
    if (_state != PLGameStateRunning || _nextPlayer == PLGameFieldStateNone) {
        return;
    }

    if ([self fieldState:field] != PLGameFieldStateNone) {
        return;
    }

    [_fields replaceObjectAtIndex:field withObject:@(_nextPlayer)];
    self.nextPlayer = _nextPlayer != PLGameFieldStateO ? PLGameFieldStateO : PLGameFieldStateX;

    void (^check)(NSUInteger, NSUInteger, NSUInteger) = ^(NSUInteger a, NSUInteger b, NSUInteger c) {
        PLGameFieldState reference = (PLGameFieldState) [_fields[a] integerValue];
        BOOL same = reference == [_fields[b] integerValue] && reference == [_fields[c] integerValue];
        if(same && reference != PLGameFieldStateNone){
            self.state = reference == PLGameFieldStateO ? PLGameStateWinO : PLGameStateWinX;
        }
    };

    check(0, 1, 2); check(3, 4, 5); check(6, 7, 8);
    check(0, 3, 6); check(1, 4, 7); check(2, 5, 8);
    check(0, 4, 8); check(2, 4, 6);

    if(_state == PLGameStateRunning){
        NSUInteger occupiedFields = 0;
        for(NSNumber * tmp in _fields){
            if([tmp integerValue] != PLGameFieldStateNone){
                ++occupiedFields;
            }
        }

        if(occupiedFields == 9){
            self.state = PLGameStateDraw;
        }
    }
}

- (void)startWithChallengerId:(NSString *)challengerId {
    if (_state != PLGameStatePending) {
        return;
    }

    self.challengerId = challengerId;
    self.nextPlayer = PLGameFieldStateO;
    self.state = PLGameStateRunning;
}

+ (int)numberOfFields {
    return PLGameFieldCount;
}

- (void)loadFromDict:(NSDictionary *)dict {
    //reversed parsing order, so that KVO notifications have more sense
    id fields = [dict objectForKey:@"fields"];
    if (fields != nil) {
        if ([fields count] != [_fields count]) {
            @throw [NSException exceptionWithName:@"IllegalStateException"
                                           reason:@"the message has invalid number of field values"
                                         userInfo:nil];
        }
        [_fields removeAllObjects];
        [_fields addObjectsFromArray:fields];
    }
    self.ownerId = [dict objectForKey:@"ownerId"];
    self.challengerId = [dict objectForKey:@"challengerId"];
    self.nextPlayer = (PLGameFieldState) [[dict objectForKey:@"nextPlayer"] integerValue];
    self.state = (PLGameState) [[dict objectForKey:@"state"] integerValue];
}

- (NSDictionary *)storeToDict {
    return @{
            @"state" : @(_state),
            @"ownerId" : _ownerId,
            @"challengerId" : _challengerId,
            @"nextPlayer" : @(_nextPlayer),
            @"fields" : _fields
    };
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"state: %d owner: %@ challengerId: %@ fields: %@", _state, _ownerId, _challengerId, _fields];
    [description appendString:@">"];
    return description;
}

@end