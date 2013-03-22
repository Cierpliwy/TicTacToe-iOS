//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLGameManager.h"
#import "PLGame.h"
#import "PLGameChannel.h"

@interface PLGameManager ()

@property(nonatomic, assign, readwrite) BOOL connected;

@end

@implementation PLGameManager {
    NSMutableArray * _waitingGames;
    SRWebSocket *_ws;
    BOOL _justConnected;
}

@synthesize waitingGames = _waitingGames;
@synthesize connected = _connected;
@synthesize host = _host;

- (id)init {
    self = [super init];
    if (self) {
        _waitingGames = [NSMutableArray new];
        _connected = NO;
        _host = nil;
    }

    return self;
}

- (void)dealloc {
    if(_ws != nil){
        [_ws closeWithCode:1001 reason:nil];
    }
}

- (void)connect:(NSString *)host {
    if (_ws == nil) {
        _justConnected = YES;
        _host = host;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"ws://%@/game/list/", host]];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        _ws = [[SRWebSocket alloc] initWithURLRequest:urlRequest];
        _ws.delegate = self;
        [_ws open];
    }
}

- (void)reconnect {
    [self connect:_host];
}

//***************************************************************
#pragma mark -
#pragma mark waiting games accessor
//***************************************************************

- (NSArray *)waitingGames {
    return _waitingGames;
}

- (NSUInteger)countOfWaitingGames {
    return _waitingGames.count;
}

- (PLGame *)objectInWaitingGamesAtIndex:(NSUInteger)index {
    return [_waitingGames objectAtIndex:index];
}

- (void)insertObject:(PLGame *)game inWaitingGamesAtIndex:(NSUInteger)index {
    [_waitingGames insertObject:game atIndex:index];
}

- (void)removeObjectFromWaitingGamesAtIndex:(NSUInteger)index {
    [_waitingGames removeObjectAtIndex:index];
}


- (void)removeWaitingGamesAtIndexes:(NSIndexSet *)set {
    [_waitingGames removeObjectsAtIndexes:set];
}

- (PLGame *)gameWithId:(NSString*)gameId {
    @synchronized (_waitingGames) {
        for (int i = 0; i < _waitingGames.count; ++i) {
            PLGame *game = [_waitingGames objectAtIndex:i];
            if ([game.gameId isEqualToString:gameId]) {
                return game;
            }
        }
        return nil;
    }
}

- (PLGameChannel*)createGameChannel{
    PLGameChannel * channel = [[PLGameChannel alloc] initWithGameManager:self];
    return channel;
}

- (PLGameChannel *)joinGameChannel:(PLGame *)game{
    PLGameChannel * channel = [[PLGameChannel alloc] initWithGameManager:self game:game];
    return channel;
}

//***************************************************************
#pragma mark -
#pragma mark websocket delegate
//***************************************************************

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"%s", sel_getName(_cmd));
    self.connected = YES;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"%s", sel_getName(_cmd));
    self.connected = NO;
    [_ws close];
    _ws = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"%s", sel_getName(_cmd));
    self.connected = NO;
    _ws = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"%s: %@", sel_getName(_cmd), message);

    if (_justConnected) {
        [self removeWaitingGamesAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _waitingGames.count)]];
        _justConnected = NO;
    }

    NSData *msgData = nil;
    if ([message isKindOfClass:[NSString class]]) {
        msgData = [message dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([message isKindOfClass:[NSData class]]) {
        msgData = message;
    } else {
        NSLog(@"message suppoused to be a string or data containing json");
        return;
    }

    NSError *error = nil;
    id decodedMsg = [NSJSONSerialization JSONObjectWithData:msgData options:0 error:&error];
    if (error != nil) {
        NSLog(@"failed to read message");
        return;
    }
    NSArray *newArray = [decodedMsg objectForKey:@"new"];
    for (NSDictionary *obj in newArray) {
        PLGame *game = [PLGame new];
        [game loadFromDict:obj];
        @synchronized (_waitingGames) {
            [self insertObject:game inWaitingGamesAtIndex:[self countOfWaitingGames]];
        }
    }
    NSArray *updateArray = [decodedMsg objectForKey:@"update"];
    for (NSDictionary *obj in updateArray) {

    }
    NSArray *removedArray = [decodedMsg objectForKey:@"removed"];
    for (NSDictionary *obj in removedArray) {
        NSString * gameId = [obj objectForKey:@"id"];

        @synchronized (_waitingGames) {
            for (int i = 0; i < _waitingGames.count;) {
                PLGame *game = [_waitingGames objectAtIndex:i];
                if ([game.gameId isEqualToString:gameId]) {
                    [self removeObjectFromWaitingGamesAtIndex:i];
                } else {
                    ++i;
                }
            }
        }
    }
}

@end