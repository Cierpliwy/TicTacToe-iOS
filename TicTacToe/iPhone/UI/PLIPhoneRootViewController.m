//
// Created by antoni on 3/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLIPhoneRootViewController.h"
#import "PLGameListViewController.h"
#import "PLGamePlayViewController.h"
#import "PLGame.h"


@implementation PLIPhoneRootViewController {

}
@synthesize gameList = gameList;

-(id) initWithGameListController:(PLGameListViewController *)aGameList{
    self = [super initWithRootViewController:nil];
    if (self){
        gameList = aGameList;
        gameList.delegate = self;

        [self setupGameListNavigationItems];

        [self pushViewController:gameList animated:NO];
    }
    return self;
}

- (void)setupGameListNavigationItems {
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(addGameButtonPressed:)];
    gameList.navigationItem.rightBarButtonItem = rightBarButtonItem;
    gameList.navigationItem.title = @"Games";
}

- (void)addGameButtonPressed:(id)addGameButtonPressed {
    PLGamePlayViewController * playViewController = [[PLGamePlayViewController alloc] init];
    [self pushViewController:playViewController
                    animated:YES];
}

- (void)gameListController:(PLGameListViewController *)listController didSelectGame:(PLGame *)game {
    PLGamePlayViewController * playViewController = [[PLGamePlayViewController alloc] init];
    [self pushViewController:playViewController
                    animated:YES];
}

@end