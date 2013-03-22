//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@class PLGame;
@class PLGameChannel;

@interface PLGameManager : NSObject <SRWebSocketDelegate>

@property (nonatomic, strong, readonly) NSArray * waitingGames;
@property (nonatomic, assign, readonly) BOOL connected;
@property (nonatomic, strong, readonly) NSString * host;

- (void)connect:(NSString*)host;
- (void)reconnect;

- (PLGame *)gameWithId:(long)gameId;
- (PLGameChannel*)createGameChannel;

- (PLGameChannel *)joinGameChannel:(PLGame *)game;
@end