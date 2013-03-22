//
// Created by antoni on 3/22/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@class PLGameManager;
@class PLGame;

@interface PLGameChannel : NSObject <SRWebSocketDelegate>

@property(nonatomic, assign, readonly) BOOL connected;
@property(nonatomic, strong, readonly) PLGame *game;

- (id)initWithGameManager:(PLGameManager *)manager;
- (id)initWithGameManager:(PLGameManager *)manager game:(PLGame *)game;

- (void)create;
- (void)join;

@end