//
// Created by Antoni Kędracki, Polidea
//


#import "PLGame.h"

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
        _ownerId = ownerId;
        _challengerId = nil;
        _state = PLGameStatePending;
        _nextPlayer = PLGameFieldStateNone;
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
    if(_state != PLGameStateRunning || _nextPlayer == PLGameFieldStateNone){
        return;
    }

    if([self fieldState:field] != PLGameFieldStateNone){
        return;
    }

    [_fields replaceObjectAtIndex:field withObject:@(_nextPlayer)];
    _nextPlayer = _nextPlayer != PLGameFieldStateO ? PLGameFieldStateO : PLGameFieldStateX;

    //TODO: check win conditions
}

- (void)startWithChallengerId:(NSString *)challengerId {
    if(_state!=PLGameStatePending){
        return;
    }

    _challengerId = challengerId;
    _state = PLGameStateRunning;
    _nextPlayer = PLGameFieldStateO;
}

+ (int)numberOfFields {
    return PLGameFieldCount;
}

- (void)loadFromDict:(NSDictionary *)dict {
    _state = (PLGameState) [[dict objectForKey:@"state"] integerValue];
    _ownerId = [dict objectForKey:@"ownerId"];
    _challengerId = [dict objectForKey:@"challengerId"];
    _nextPlayer = (PLGameFieldState) [[dict objectForKey:@"nextPlayer"] integerValue];
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