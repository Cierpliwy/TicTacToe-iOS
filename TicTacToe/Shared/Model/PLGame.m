//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLGame.h"


@implementation PLGame {

}

@synthesize name = _name;
@synthesize gameId = _gameId;

- (void)loadFromDict:(NSDictionary *)dict {
    _gameId = [dict objectForKey:@"id"];
    _name = [dict objectForKey:@"name"];
}

@end