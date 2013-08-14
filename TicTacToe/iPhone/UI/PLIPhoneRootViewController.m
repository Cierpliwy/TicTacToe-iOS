//
// Created by Antoni Kędracki, Polidea
//

#import "PLIPhoneRootViewController.h"
#import "PLGamePlayViewController.h"
#import "PLGame.h"
#import "PLGameManager.h"
#import "PLGameChannel.h"


@interface PLIPhoneRootViewController () <UINavigationControllerDelegate>
@end

@implementation PLIPhoneRootViewController {
}
@synthesize gameList = gameList;

@synthesize manager = manager;

- (id)initWithGameManager:(PLGameManager *)aManager gameListController:(PLGameListViewController *)aGameList {
    self = [super init];
    if (self) {
        self.delegate = self;

        manager = aManager;

        gameList = aGameList;
        gameList.delegate = self;

        [self setupGameListNavigationItems];

        [self pushViewController:gameList animated:NO];
    }
    return self;
}

- (void)dealloc {

}

- (void)setupGameListNavigationItems {
    gameList.navigationItem.title = @"Games";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:@selector(addGameButtonPressed:)];
    gameList.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)addGameButtonPressed:(id)addGameButtonPressed {
    PLGamePlayViewController *playViewController = [[PLGamePlayViewController alloc] init];
    playViewController.gameChannel = [manager hostGame];

    playViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Leave"
                                                                                           style:UIBarButtonItemStyleBordered
                                                                                          target:self
                                                                                          action:@selector(leaveHostedGameButtonPressed:)];

    [self pushViewController:playViewController
                    animated:YES];
}

- (void)leaveHostedGameButtonPressed:(id)leaveHostedGameButtonPressed {
    if(![self.topViewController isKindOfClass:[PLGamePlayViewController class]]){
        return;
    }

    [manager teardownHostedGame];
    [self popViewControllerAnimated:YES];
}

- (void)gameListController:(PLGameListViewController *)listController didSelectGame:(PLGame *)game {
    PLGamePlayViewController *playViewController = [[PLGamePlayViewController alloc] init];
    playViewController.gameChannel = [manager joinGame:game];

    playViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Leave"
                                                                                           style:UIBarButtonItemStyleBordered
                                                                                          target:self
                                                                                          action:@selector(leaveJoinedGameButtonPressed:)];

    [self pushViewController:playViewController
                    animated:YES];
}

- (void)leaveJoinedGameButtonPressed:(id)leaveJoinedGameButtonPressed {
    if(![self.topViewController isKindOfClass:[PLGamePlayViewController class]]){
        return;
    }

    [self popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

@end