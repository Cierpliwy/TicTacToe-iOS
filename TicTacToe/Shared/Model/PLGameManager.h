//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "PLGameChannel.h"

@class PLGame;
@class PLGameChannel;

@interface PLGameManager : NSObject <SRWebSocketDelegate, PLGameChannelDelegate>

@property(nonatomic, strong, readonly) NSArray *waitingGames;
@property(nonatomic, assign, readonly) BOOL connected;
@property(nonatomic, strong, readonly) NSString *host;

- (void)connect:(NSString *)host;
- (void)reconnect;

- (PLGame *)gameWithId:(NSString *)gameId;

- (PLGameChannel *)createGameChannel;
- (PLGameChannel *)joinGameChannel:(PLGame *)game;
@end