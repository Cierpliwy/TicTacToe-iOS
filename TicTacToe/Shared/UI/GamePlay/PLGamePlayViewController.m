//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
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
    [self setupViewFromGameState];
}

- (void)setupViewFromGameState {
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
        self.gameplayView.stateLabel.text = @"Pending";
        self.gameplayView.stateLabel.backgroundColor = [UIColor redColor];
        self.gameplayView.stateLabel.textColor = [UIColor whiteColor];
    } else if(state == PLGameStateRunning){
        self.gameplayView.stateLabel.text = @"In progress";
        self.gameplayView.stateLabel.backgroundColor = [UIColor orangeColor];
        self.gameplayView.stateLabel.textColor = [UIColor whiteColor];
    } else if(state == PLGameStateWinO){
        self.gameplayView.stateLabel.text = @"O - Wins";
        self.gameplayView.stateLabel.backgroundColor = [UIColor greenColor];
        self.gameplayView.stateLabel.textColor = [UIColor blackColor];
    } else if(state == PLGameStateWinX){
        self.gameplayView.stateLabel.text = @"X - Wins";
        self.gameplayView.stateLabel.backgroundColor = [UIColor greenColor];
        self.gameplayView.stateLabel.textColor = [UIColor blackColor];
    } else if(state == PLGameStateDraw){
        self.gameplayView.stateLabel.text = @"Draw";
        self.gameplayView.stateLabel.backgroundColor = [UIColor blackColor];
        self.gameplayView.stateLabel.textColor = [UIColor whiteColor];
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

        [self setupViewFromGameState];
        [self didChangeValueForKey:@"gameChannel"];
    }
}

- (void)gameplayView:(PLGamePlayView *)gameplayView didTapField:(NSUInteger)field {
    [_gameChannel move:field];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"game" isEqualToString:keyPath]) {
        NSLog(@"change = %@", change);
        [self setupViewFromGameState];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end