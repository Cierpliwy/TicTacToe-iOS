//
// Created by antoni on 3/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLIPhoneRootViewController.h"
#import "PLGameListViewController.h"


@implementation PLIPhoneRootViewController {

}
@synthesize gameList = gameList;


-(id) initWithGameListController:(PLGameListViewController *)aGameList{
    self = [super initWithRootViewController:nil];
    if (self){
        gameList = aGameList;
        gameList.delegate = self;

        [self pushViewController:gameList animated:NO];
    }
    return self;
}

@end