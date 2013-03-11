//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLGameManager.h"
#import "PLGame.h"


@implementation PLGameManager {
    NSMutableArray * waitingGames;
}

@synthesize waitingGames;

//***************************************************************
#pragma mark -
#pragma mark waiting games accessor
//***************************************************************

- (NSArray *)waitingGames {
    return waitingGames;
}

-(NSUInteger) countOfWaitingGames{
    return waitingGames.count;
}

-(PLGame *) objectInWaitingGamesAtIndex:(NSUInteger)index {
    return [waitingGames objectAtIndex:index];
}

-(void) insetObject:(PLGame *)game inWaitingGamesAtIndex:(NSUInteger)index{
    [waitingGames insertObject:game atIndex:index];
}

-(void) removeObjectFromWaitingGamesAtIndex:(NSUInteger)index{
    [waitingGames removeObjectAtIndex:index];
}

@end