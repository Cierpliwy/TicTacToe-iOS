//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>

@class PLGame;

@interface PLGameManager : NSObject

@property (nonatomic, strong, readonly) NSArray * waitingGames;

-(PLGame*) createGame;

@end