//
// Created by antoni on 3/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLIPhoneRootViewController.h"
#import "PLGamePlayViewController.h"
#import "PLGame.h"
#import "PLGameManager.h"
#import "PLGameChannel.h"


@implementation PLIPhoneRootViewController {
}
@synthesize gameList = gameList;

@synthesize manager = manager;

- (id)initWithGameManager:(PLGameManager *)aManager gameListController:(PLGameListViewController *)aGameList {
    self = [super init];
    if (self) {
        manager = aManager;
        [manager addObserver:self
                  forKeyPath:@"connected"
                     options:NSKeyValueObservingOptionNew
                     context:nil];

        gameList = aGameList;
        gameList.delegate = self;


        [self setupGameListNavigationItems];

        [self pushViewController:gameList animated:NO];
    }
    return self;
}

- (void)dealloc {
    [manager removeObserver:self
                 forKeyPath:@"connected"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([@"connected" isEqualToString:keyPath]){
        gameList.navigationItem.leftBarButtonItem.enabled = !manager.connected;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setupGameListNavigationItems {
    gameList.navigationItem.title = @"Games";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:@selector(addGameButtonPressed:)];
    gameList.navigationItem.rightBarButtonItem = rightBarButtonItem;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reconnect"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(reconnectButtonPressed:)];
    gameList.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)reconnectButtonPressed:(UIBarButtonItem *)button {
    [manager reconnect];
}

- (void)addGameButtonPressed:(id)addGameButtonPressed {
    PLGamePlayViewController *playViewController = [[PLGamePlayViewController alloc] init];
    playViewController.gameChannel = [manager createGameChannel];
    [playViewController.gameChannel create];
    [self pushViewController:playViewController
                    animated:YES];
}

- (void)gameListController:(PLGameListViewController *)listController didSelectGame:(PLGame *)game {
    PLGamePlayViewController *playViewController = [[PLGamePlayViewController alloc] init];
    playViewController.gameChannel = [manager joinGameChannel:game];
    [playViewController.gameChannel join];
    [self pushViewController:playViewController
                    animated:YES];
}

@end