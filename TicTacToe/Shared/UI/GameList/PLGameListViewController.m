//
// Created by antoni on 3/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLGameListViewController.h"
#import "PLGameListView.h"
#import "PLGame.h"
#import "PLIPhoneRootViewController.h"


@interface PLGameListViewController ()

@property(nonatomic, strong, readonly) PLGameListView *listView;

@end

@implementation PLGameListViewController {

}
@synthesize delegate = delegate;


- (id)init {
    self = [super init];
    if (self) {

    }

    return self;
}


- (PLGameListView *)listView {
    return (PLGameListView *)self.view;
}

- (void)loadView {
    PLGameListView * view = [[PLGameListView alloc] initWithFrame:CGRectZero];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.listView.tableView.delegate = self;
    self.listView.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end