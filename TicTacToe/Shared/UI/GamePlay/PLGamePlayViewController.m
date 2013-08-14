//
// Created by Antoni Kędracki, Polidea
//

#import "PLGamePlayViewController.h"
#import "PLGameChannel.h"
#import "PLGame.h"


@interface PLGamePlayViewController ()

@property(nonatomic, strong, readonly) PLGamePlayView *gameplayView;

- (void)setupViewFromGameState;
@end

@implementation PLGamePlayViewController {

}

@synthesize gameChannel = _gameChannel;

- (PLGamePlayView *)gameplayView {
    return (PLGamePlayView *) self.view;
}

- (void)dealloc {
    if (_gameChannel != nil) {
        [_gameChannel removeObserver:self
                          forKeyPath:@"game"];
    }
}


- (void)loadView {
    self.view = [[PLGamePlayView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gameplayView.delegate = self;
    [self setupViewFromGameStateAnimated:NO];
}

- (void)setupViewFromGameStateAnimated:(BOOL)animated {
    if(!self.isViewLoaded){
        return;
    }

    for(int i = 0; i < [PLGame numberOfFields]; ++i){
        PLGameFieldState state = [_gameChannel.game fieldState:i];
        if(state == PLGameFieldStateO){
            [[self.gameplayView.fields objectAtIndex:i] setTitle:@"O" forState:UIControlStateNormal];
        } else if(state == PLGameFieldStateX){
            [[self.gameplayView.fields objectAtIndex:i] setTitle:@"X" forState:UIControlStateNormal];
        } else {
            [[self.gameplayView.fields objectAtIndex:i] setTitle:@"" forState:UIControlStateNormal];
        }
    }
    PLGameState state = _gameChannel.game.state;
    if(state == PLGameStatePending){
        [self.gameplayView setStateText:@"Pending" textColor:[UIColor whiteColor] backgroungColor:[UIColor redColor] animated:animated];
    } else if(state == PLGameStateRunning){
        [self.gameplayView setStateText:@"In progress" textColor:[UIColor whiteColor] backgroungColor:[UIColor orangeColor] animated:animated];
    } else if(state == PLGameStateWinO){
        [self.gameplayView setStateText:@"O - Wins" textColor:[UIColor blackColor] backgroungColor:[UIColor greenColor] animated:animated];
    } else if(state == PLGameStateWinX){
        [self.gameplayView setStateText:@"X - Wins" textColor:[UIColor blackColor] backgroungColor:[UIColor greenColor] animated:animated];
    } else if(state == PLGameStateDraw){
        [self.gameplayView setStateText:@"Draw" textColor:[UIColor whiteColor] backgroungColor:[UIColor blackColor] animated:animated];
    }
}

- (void)setGameChannel:(PLGameChannel *)gameChannel {
    if (_gameChannel != gameChannel) {
        [self willChangeValueForKey:@"gameChannel"];

        if (_gameChannel != nil) {
            [_gameChannel removeObserver:self
                              forKeyPath:@"game"];
        }

        _gameChannel = gameChannel;

        if (_gameChannel != nil) {
            [_gameChannel addObserver:self
                           forKeyPath:@"game"
                              options:NSKeyValueObservingOptionNew
                              context:nil];
        }

        [self setupViewFromGameStateAnimated:NO];
        [self didChangeValueForKey:@"gameChannel"];
    }
}

- (void)gameplayView:(PLGamePlayView *)gameplayView didTapField:(NSUInteger)field {
    [_gameChannel move:field];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"game" isEqualToString:keyPath]) {
        NSLog(@"game = %@", _gameChannel.game);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupViewFromGameStateAnimated:YES];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end