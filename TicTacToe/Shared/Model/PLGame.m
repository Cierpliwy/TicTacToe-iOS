//
// Created by Antoni Kędracki, Polidea
//

#import "PLGame.h"

@implementation PLGame {

@private
    NSMutableArray *_fields;
}

@synthesize name = _name;
@synthesize gameId = _gameId;
@synthesize state = _state;

int const PLGameFieldCount = 9;

- (id)init {
    self = [super init];
    if (self) {
        _state = PLGameStatePending;
        _fields = [NSMutableArray arrayWithCapacity:PLGameFieldCount];
        for (int i = 0; i < PLGameFieldCount; ++i) {
            [_fields addObject:@(PLGameFieldStateNone)];
        }
    }

    return self;
}

- (PLGameFieldState)fieldState:(int)field {
    if (field < 0 || field >= PLGameFieldCount) {
        @throw [NSException exceptionWithName:@"IndexOutOfBounds"
                                       reason:@"field index out of valid range"
                                     userInfo:nil];
    }
    return [[_fields objectAtIndex:field] integerValue];
}

- (void)loadFromDict:(NSDictionary *)dict {
    _gameId = [dict objectForKey:@"id"];
    _name = [dict objectForKey:@"name"];
    _state = [[dict objectForKey:@"state"] integerValue];
    id fields = [dict objectForKey:@"fields"];
    if(fields != nil){
        if([fields count] != [_fields count]){
            @throw [NSException exceptionWithName:@"IllegalStateException"
                                           reason:@"the message has invalid number of field values"
                                         userInfo:nil];
        }
        [_fields removeAllObjects];
        [_fields addObjectsFromArray:fields];
    }
}

+ (int)numberOfFields {
    return PLGameFieldCount;
}

@end