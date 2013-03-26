//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>
#import "PLGameListViewController.h"

@class PLGameListViewController;
@class PLGameManager;


@interface PLIPhoneRootViewController : UINavigationController <PLGameListViewControllerDelegate>

@property (nonatomic, strong, readonly) PLGameListViewController * gameList;
@property (nonatomic, strong, readonly) PLGameManager * manager;

- (id)initWithGameManager:(PLGameManager *)aManager gameListController:(PLGameListViewController *)aGameList;

@end