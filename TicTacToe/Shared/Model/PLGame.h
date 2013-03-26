//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>

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

@property(nonatomic, strong, readonly) NSString *gameId;
@property(nonatomic, strong, readonly) NSString *name;
@property(nonatomic, assign, readonly) PLGameState state;

- (PLGameFieldState)fieldState:(int)field;

- (void)loadFromDict:(NSDictionary *)dict;

+ (int)numberOfFields;

@end