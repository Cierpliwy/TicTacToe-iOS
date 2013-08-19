//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>
#import "PLGameChannel.h"

@class PLGame;
@class PLGameChannel;
@class MCPeerID;

@interface PLGameManager : NSObject

+ (NSString *)serviceType;

@property(nonatomic, strong, readonly) NSArray *waitingGames;

@property(nonatomic, strong, readonly) MCPeerID *peerId;
-(MCPeerID *)peerForUserId:(NSString *)userId;

-(PLGameChannel *) hostGame;

-(PLGameChannel *) joinGame:(PLGame *)game;

@end