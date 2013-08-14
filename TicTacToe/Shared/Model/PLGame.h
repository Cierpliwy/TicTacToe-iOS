//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>

@class MCPeerID;

typedef enum {
    PLGameStatePending = 0,
    PLGameStateRunning = 1,
    PLGameStateWinO = 2,
    PLGameStateWinX = 3,
    PLGameStateDraw = 4

} PLGameState;

typedef enum {
    PLGameFieldStateNone = 0,
    PLGameFieldStateO = 1,
    PLGameFieldStateX = 2
} PLGameFieldState;

@interface PLGame : NSObject

-(id)initWithOwnerId:(NSString *)ownerId;

@property (nonatomic, strong, readonly) NSString * ownerId;
@property (nonatomic, strong, readonly) NSString * challengerId;

@property(nonatomic, assign, readonly) PLGameState state;

@property (nonatomic, assign, readonly) PLGameFieldState nextPlayer;
-(void)performMove:(NSUInteger)field;

-(void)startWithChallengerId:(NSString *)challengerId;

- (PLGameFieldState)fieldState:(NSUInteger)field;
+ (int)numberOfFields;

- (void)loadFromDict:(NSDictionary *)dict;
- (NSDictionary*)storeToDict;

@end