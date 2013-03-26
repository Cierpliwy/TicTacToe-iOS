//
// Created by Antoni Kędracki, Polidea
//

#import "PLGameListViewController.h"
#import "PLGameListView.h"
#import "PLGameManager.h"
#import "PLGameListCell.h"
#import "PLGame.h"


@interface PLGameListViewController ()

@property(nonatomic, strong, readonly) PLGameListView *listView;

@end

@implementation PLGameListViewController {
    PLGameManager *manager;
}
@synthesize delegate = delegate;

- (id)initWithGameManager:(PLGameManager *)aManager {
    self = [super init];
    if (self) {
        manager = aManager;
        [manager addObserver:self
                  forKeyPath:@"waitingGames"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    }

    return self;
}

- (void)dealloc {
    [manager removeObserver:self
                 forKeyPath:@"waitingGames"];
    [manager removeObserver:self
                 forKeyPath:@"connected"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"waitingGames" isEqualToString:keyPath]) {
        NSLog(@"waitingGames: %@", change);
        NSKeyValueChange kind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
        NSIndexSet *indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
        [self handleBeaconsChange:kind atIndexes:indexes];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)handleBeaconsChange:(NSKeyValueChange)change atIndexes:(NSIndexSet *)indexes {
    if (![self isViewLoaded]) {
        return;
    }
    [self.listView.tableView beginUpdates];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:idx inSection:0]];
        if (change == NSKeyValueChangeInsertion) {
            [self.listView.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        } else if (change == NSKeyValueChangeRemoval) {
            [self.listView.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.listView.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    [self.listView.tableView endUpdates];
}

- (PLGameListView *)listView {
    return (PLGameListView *) self.view;
}

- (void)loadView {
    PLGameListView *view = [[PLGameListView alloc] initWithFrame:CGRectZero];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.listView.tableView.rowHeight = [PLGameListCell standardHeight];
    self.listView.tableView.delegate = self;
    self.listView.tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = manager.waitingGames.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"GameListCell";
    PLGameListCell *cell = (PLGameListCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[PLGameListCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    PLGame * game = [manager.waitingGames objectAtIndex:indexPath.row];

    cell.hostNameLabel.text = game.name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PLGame * game = [manager.waitingGames objectAtIndex:indexPath.row];
    if (delegate){
        [delegate gameListController:self didSelectGame:game];
    }
}

@end