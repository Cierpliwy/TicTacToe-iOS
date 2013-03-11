//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLGamePlayViewController.h"
#import "PLGamePlayView.h"


@interface PLGamePlayViewController ()
@property(nonatomic, strong, readonly) PLGamePlayView *gameplayView;

@end

@implementation PLGamePlayViewController {

}

- (PLGamePlayView *)gameplayView {
    return (PLGamePlayView *) self.view;
}

- (void)loadView {
    self.view = [[PLGamePlayView alloc] initWithFrame:CGRectZero];
}

@end