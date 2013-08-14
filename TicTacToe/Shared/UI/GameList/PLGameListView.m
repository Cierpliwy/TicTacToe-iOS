//
// Created by Antoni Kędracki, Polidea
//

#import "PLGameListView.h"

@implementation PLGameListView {

}

@synthesize tableView = tableView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:tableView];

        self.backgroundColor = [UIColor whiteColor];
    }

    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    tableView.frame = self.bounds;
}

@end