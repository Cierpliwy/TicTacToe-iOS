//
// Created by antoni on 3/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>

@class PLGameListView;
@class PLGame;
@class PLGameListViewController;

@protocol PLGameListViewControllerDelegate <NSObject>

-(void) gameListController:(PLGameListViewController*)listController didSelectGame:(PLGame*)game;

@end

@interface PLGameListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak, readwrite) id<PLGameListViewControllerDelegate> delegate;

@end