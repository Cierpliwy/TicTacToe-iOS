//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>

@class PLGameManager;
@class PLGame;
@class MCSession;

@interface PLGameChannel : NSObject

@property(nonatomic, strong, readonly) PLGame *game;

@property(nonatomic, strong, readonly) MCSession *session;

@property (nonatomic, assign, readonly) BOOL isOwner;

- (id)initWithGameManager:(PLGameManager *)manager game:(PLGame *)game;

- (BOOL)move:(NSUInteger)field;

@end