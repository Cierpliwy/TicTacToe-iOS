//
// Created by Antoni Kędracki, Polidea
//

#import "PLGamePlayViewController.h"
#import "PLGameChannel.h"
#import "PLGame.h"


@interface PLGamePlayViewController ()

@property(nonatomic, strong, readonly) PLGamePlayView *gameplayView;

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

        [_gameChannel removeObserver:self
                          forKeyPath:@"isDisconnected"];
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
    if (!self.isViewLoaded) {
        return;
    }

    for (int i = 0; i < [PLGame numberOfFields]; ++i) {
        PLGameFieldState state = [_gameChannel.game fieldState:i];
        if (state == PLGameFieldStateO) {
            [[self.gameplayView.fields objectAtIndex:i] setTitle:@"O" forState:UIControlStateNormal];
        } else if (state == PLGameFieldStateX) {
            [[self.gameplayView.fields objectAtIndex:i] setTitle:@"X" forState:UIControlStateNormal];
        } else {
            [[self.gameplayView.fields objectAtIndex:i] setTitle:@"" forState:UIControlStateNormal];
        }
    }
    BOOL isDisconnected = _gameChannel.isDisconnected;

    void (^setStatusText)(NSString *, UIColor *, UIColor *) = ^(NSString *text, UIColor *forColor, UIColor *backColor) {
        [self.gameplayView setStateText:text
                              textColor:forColor
                        backgroungColor:backColor
                               animated:animated];
    };

    PLGameState state = _gameChannel.game.state;
    if (state == PLGameStatePending) {
        setStatusText(@"Pending", [UIColor whiteColor], [UIColor redColor]);
    } else if (state == PLGameStateRunning) {
        if (_gameChannel.game.nextPlayer == PLGameFieldStateO) {
            setStatusText(_gameChannel.isOwner ? @"O(You) - Moves" : @"O - Moves", [UIColor whiteColor], [UIColor orangeColor]);
        } else {
            setStatusText(!_gameChannel.isOwner ? @"X(You) - Moves" : @"X - Moves", [UIColor whiteColor], [UIColor orangeColor]);
        }
    } else if (state == PLGameStateWinO) {
        setStatusText(_gameChannel.isOwner ? @"O(You) - Wins" : @"O - Wins", [UIColor blackColor], [UIColor greenColor]);
    } else if (state == PLGameStateWinX) {
        setStatusText(!_gameChannel.isOwner ? @"X(You) - Wins" : @"X - Wins", [UIColor blackColor], [UIColor greenColor]);
    } else if (state == PLGameStateDraw) {
        setStatusText(@"Draw", [UIColor whiteColor], [UIColor blackColor]);
    }

    void (^setOpponentName)(NSString *, NSString *) = ^(NSString *playerSign, NSString *name) {
        if (name == nil || name.length == 0) {
            self.gameplayView.opponentNameLaber.text = @"Waiting for opponent";
        } else {
            self.gameplayView.opponentNameLaber.text = !isDisconnected ? [NSString stringWithFormat:@"Opponent: %@ - %@", playerSign, name] : [NSString stringWithFormat:@"Opponent: %@ - %@ (disconnected)", playerSign, name];
        }
    };

    if (_gameChannel.isOwner) {
        setOpponentName(@"X", _gameChannel.game.challengerId);
    } else {
        setOpponentName(@"O", _gameChannel.game.ownerId);
    }
}

- (void)setGameChannel:(PLGameChannel *)gameChannel {
    if (_gameChannel != gameChannel) {
        [self willChangeValueForKey:@"gameChannel"];

        if (_gameChannel != nil) {
            [_gameChannel removeObserver:self
                              forKeyPath:@"game"];
            [_gameChannel removeObserver:self
                              forKeyPath:@"isDisconnected"];
        }

        _gameChannel = gameChannel;

        if (_gameChannel != nil) {
            [_gameChannel addObserver:self
                           forKeyPath:@"game"
                              options:NSKeyValueObservingOptionNew
                              context:nil];
            [_gameChannel addObserver:self
                           forKeyPath:@"isDisconnected"
                              options:NSKeyValueObservingOptionNew
                              context:nil];
        }

        [self setupViewFromGameStateAnimated:NO];
        [self didChangeValueForKey:@"gameChannel"];
    }
}

- (void)gameplayView:(PLGamePlayView *)gameplayView didTapField:(NSUInteger)field {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_gameChannel move:field];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"game" isEqualToString:keyPath]) {
        NSLog(@"game = %@", _gameChannel.game);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupViewFromGameStateAnimated:YES];
        });
    } else if ([@"isDisconnected" isEqualToString:keyPath]) {
        NSLog(@"isDisconnected = %d", _gameChannel.isDisconnected);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupViewFromGameStateAnimated:YES];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end