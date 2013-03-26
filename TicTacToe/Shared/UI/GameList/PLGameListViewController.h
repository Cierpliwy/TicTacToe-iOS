//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>

@class PLGameListView;
@class PLGame;
@class PLGameListViewController;
@class PLGameManager;

@protocol PLGameListViewControllerDelegate <NSObject>

-(void) gameListController:(PLGameListViewController*)listController didSelectGame:(PLGame*)game;

@end

@interface PLGameListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak, readwrite) id<PLGameListViewControllerDelegate> delegate;

- (id)initWithGameManager:(PLGameManager *)manager;

- (void)reconnectButtonPressed;
- (void)connectionStatusDidChange:(BOOL)state;

@end