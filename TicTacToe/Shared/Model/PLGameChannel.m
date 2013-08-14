//
// Created by Antoni Kędracki, Polidea
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "PLGameChannel.h"
#import "PLGameManager.h"
#import "NSString+SHA1.h"
#import "PLGame.h"

@interface PLGameChannel () <MCSessionDelegate>
@end

@implementation PLGameChannel {
    __weak PLGameManager *_manager;
}

@synthesize game = _game;
@synthesize isOwner = _isOwner;

- (id)initWithGameManager:(PLGameManager *)manager game:(PLGame *)game {
    self = [super init];
    if (self) {
        _manager = manager;
        _game = game;

        _isOwner = [_manager.peerId.displayName isEqualToString:game.ownerId];

        _session = [[MCSession alloc] initWithPeer:_manager.peerId];
        _session.delegate = self;
    }

    return self;
}

- (void)dealloc {
    if(_session.connectedPeers.count > 0){
        [_session disconnect];
    }
}

- (BOOL)move:(NSUInteger)field {
    if(_session.connectedPeers.count == 0){
        return NO;
    }

    if([self isOwner]){
        if(_game.nextPlayer == PLGameFieldStateO){
            [self willChangeValueForKey:@"game"];
            [_game performMove:field];
            [self didChangeValueForKey:@"game"];

            [self broadcastGameState];
        }
    } else {
        id msg = @{@"move" : @(field)};
        id msgData = [NSJSONSerialization dataWithJSONObject:msg
                                                     options:0
                                                       error:NULL];

        [_session sendData:msgData
                   toPeers:_session.connectedPeers
                  withMode:MCSessionSendDataReliable
                error:NULL];
    }

    return YES;
}

//***************************************************************
#pragma mark -
#pragma mark session delegate
//***************************************************************

-(void) broadcastGameState{
    NSDictionary * stateDict = [_game storeToDict];
    NSData * stateData = [NSJSONSerialization dataWithJSONObject:stateDict options:0 error:NULL];

    [_session sendData:stateData
               toPeers:_session.connectedPeers
              withMode:MCSessionSendDataReliable
                 error:NULL];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"%s -> peer: %@ state: %d", sel_getName(_cmd), peerID, state);

    if(![self isOwner]){
        return;
    }

    if(state == MCSessionStateConnected){
        if(_game.state == PLGameStatePending){
            [self willChangeValueForKey:@"game"];
            [_game startWithChallengerId:peerID.displayName];
            [self didChangeValueForKey:@"game"];
        }
        [self broadcastGameState];
    }
}


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"%s -> data: %@ peer: %@", sel_getName(_cmd), [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8], peerID);

    if([self isOwner]){
        NSDictionary * moveDict = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:NULL];
        NSLog(@"move cmd received: %@", moveDict);

        if(_game.nextPlayer == PLGameFieldStateX){
            NSUInteger field = [[moveDict objectForKey:@"move"] unsignedIntegerValue];
            [self willChangeValueForKey:@"game"];
            [_game performMove:field];
            [self didChangeValueForKey:@"game"];

            [self broadcastGameState];
        }
    } else {
        NSDictionary * stateDict = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:NULL];
        [self willChangeValueForKey:@"game"];
        [_game loadFromDict:stateDict];
        [self didChangeValueForKey:@"game"];
    }
}

@end