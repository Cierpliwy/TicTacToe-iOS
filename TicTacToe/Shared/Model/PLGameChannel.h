//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@class PLGameManager;
@class PLGame;
@class PLGameChannel;

@protocol PLGameChannelDelegate <NSObject>

- (void)gameChannelNotConnected:(PLGameChannel *)gameChannel;

@end

@interface PLGameChannel : NSObject <SRWebSocketDelegate>

@property(nonatomic, weak) id <PLGameChannelDelegate> delegate;
@property(nonatomic, assign, readonly) BOOL connected;
@property(nonatomic, strong, readonly) PLGame *game;

- (id)initWithGameManager:(PLGameManager *)manager;
- (id)initWithGameManager:(PLGameManager *)manager game:(PLGame *)game;

- (void)create;
- (void)join;

- (BOOL)move:(int)field;

@end