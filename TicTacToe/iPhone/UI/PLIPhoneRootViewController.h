//
// Created by antoni on 3/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import "PLGameListViewController.h"

@class PLGameListViewController;


@interface PLIPhoneRootViewController : UINavigationController <PLGameListViewControllerDelegate>

@property (nonatomic, strong, readonly) PLGameListViewController * gameList;

- (id)initWithGameListController:(PLGameListViewController *)aGameList;

@end