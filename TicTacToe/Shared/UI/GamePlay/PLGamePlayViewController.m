//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLGamePlayViewController.h"
#import "PLGamePlayView.h"
#import "PLGameChannel.h"


@interface PLGamePlayViewController ()

@property(nonatomic, strong, readonly) PLGamePlayView *gameplayView;

@end

@implementation PLGamePlayViewController {

}

@synthesize gameChannel = _gameChannel;

- (PLGamePlayView *)gameplayView {
    return (PLGamePlayView *) self.view;
}

- (void)loadView {
    self.view = [[PLGamePlayView alloc] initWithFrame:CGRectZero];
}

- (void)setGameChannel:(PLGameChannel *)gameChannel {
    if(_gameChannel != gameChannel){
        [self willChangeValueForKey:@"gameChannel"];

        _gameChannel =  gameChannel;

        [self didChangeValueForKey:@"gameChannel"];
    }
}

@end