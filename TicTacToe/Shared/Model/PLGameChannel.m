//
// Created by Antoni Kędracki, Polidea
//

#import "PLGameChannel.h"
#import "PLGameManager.h"
#import "NSString+SHA1.h"
#import "PLGame.h"

@interface PLGameChannel ()

@property(nonatomic, assign, readwrite) BOOL connected;

@end

@implementation PLGameChannel {
    __weak PLGameManager *_manager;
    SRWebSocket *_ws;
    NSString *_gameId;
}

@synthesize connected = _connected;
@synthesize game = _game;

- (id)initWithGameManager:(PLGameManager *)manager {
    self = [super init];
    if (self) {
        _manager = manager;
        _ws = nil;
        _connected = NO;
        _gameId = nil;

        [_manager addObserver:self
                   forKeyPath:@"waitingGames"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    }

    return self;
}

- (id)initWithGameManager:(PLGameManager *)manager game:(PLGame *)game {
    self = [self initWithGameManager:manager];
    if(self){
        _game = game;
        _gameId = game.gameId;
    }
    return self;
}

- (void)dealloc {
    [_manager removeObserver:self
                  forKeyPath:@"waitingGames"];
    if(_ws != nil){
        _ws.delegate = nil;
        [_ws closeWithCode:1001 reason:nil];
    }
}

- (void)create {
    if (_ws == nil) {
        if (_gameId == nil) {
            NSString *key = [[UIDevice currentDevice].name stringByAppendingString:[[NSDate date] description]];
            _gameId = [key sha1Hash];
        }

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"ws://%@/game/%@/", _manager.host, _gameId]];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [urlRequest setValue:@"create" forHTTPHeaderField:@"x-polidea-action"];
        _ws = [[SRWebSocket alloc] initWithURLRequest:urlRequest];
        _ws.delegate = self;
        [_ws open];
    }
}

- (void)join {
    if (_ws == nil) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"ws://%@/game/%@/", _manager.host, _gameId]];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [urlRequest setValue:@"join" forHTTPHeaderField:@"x-polidea-action"];
        _ws = [[SRWebSocket alloc] initWithURLRequest:urlRequest];
        _ws.delegate = self;
        [_ws open];
    }
}

- (BOOL)move:(int)field{
    if(_ws == nil){
        return false;
    }

    id msg = @{@"move" : @(field)};
    id msgData = [NSJSONSerialization dataWithJSONObject:msg
                                                 options:0
                                                   error:NULL];
    [_ws send:[[NSString alloc] initWithData:msgData
                                    encoding:NSUTF8StringEncoding]];
    return true;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"waitingGames"]){
        NSLog(@"waitingGames: %@", change);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//***************************************************************
#pragma mark -
#pragma mark websocket delegate
//***************************************************************

- (id)decodeJSONMessage:(id)message {
    NSData *msgData = nil;
    if ([message isKindOfClass:[NSString class]]) {
        msgData = [message dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([message isKindOfClass:[NSData class]]) {
        msgData = message;
    } else {
        @throw [NSException exceptionWithName:@"IllegalStateException"
                                       reason:@"message suppoused to be a string or data containing json"
                                     userInfo:nil];
    }

    NSError *error = nil;
    id decodedMsg = [NSJSONSerialization JSONObjectWithData:msgData options:0 error:&error];
    if (error != nil) {
        @throw [NSException exceptionWithName:@"IllegalStateException"
                                       reason:@"failed to read message"
                                     userInfo:nil];
    }
    return decodedMsg;
}

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

    id decodedMsg = [self decodeJSONMessage:message];

    [self willChangeValueForKey:@"game"];
    if(_game == nil){
        PLGame * newGame = [[PLGame alloc] init];
        [newGame loadFromDict:decodedMsg];
        _game = newGame;
    } else {
        [_game loadFromDict:decodedMsg];
    }
    [self didChangeValueForKey:@"game"];
}

@end