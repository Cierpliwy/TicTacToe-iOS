//
// Created by Antoni Kędracki, Polidea
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "PLGameManager.h"
#import "PLGame.h"

@interface PLGameManager () <MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>
@end

@implementation PLGameManager {
    NSMutableArray *_waitingGames;

    NSMutableDictionary * _peerRepository;

    MCNearbyServiceBrowser *_browser;

    MCNearbyServiceAdvertiser *_advertiser;
    PLGameChannel *_hostedGame;
}

@synthesize peerId = _peerId;

+ (NSString *)serviceType {
    return @"polidea-tictac";
}

- (id)init {
    self = [super init];
    if (self) {
        _waitingGames = [NSMutableArray new];

        _peerRepository = [NSMutableDictionary new];

        _peerId = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
        [_peerRepository setObject:_peerId forKey:_peerId.displayName];

        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerId serviceType:[[self class] serviceType]];
        _browser.delegate = self;
        [_browser startBrowsingForPeers];

        _hostedGame = nil;
    }

    return self;
}

- (void)dealloc {
    [_browser stopBrowsingForPeers];
    if(_advertiser){
        [_advertiser stopAdvertisingPeer];
    }
}

//***************************************************************
#pragma mark -
#pragma mark waiting games accessor
//***************************************************************

- (NSArray *)waitingGames {
    return _waitingGames;
}

- (NSUInteger)countOfWaitingGames {
    return _waitingGames.count;
}

- (PLGame *)objectInWaitingGamesAtIndex:(NSUInteger)index {
    return [_waitingGames objectAtIndex:index];
}

- (void)insertObject:(PLGame *)game inWaitingGamesAtIndex:(NSUInteger)index {
    [_waitingGames insertObject:game atIndex:index];
}

- (void)removeObjectFromWaitingGamesAtIndex:(NSUInteger)index {
    [_waitingGames removeObjectAtIndex:index];
}

- (void)removeWaitingGamesAtIndexes:(NSIndexSet *)set {
    [_waitingGames removeObjectsAtIndexes:set];
}

//***************************************************************
#pragma mark -
#pragma mark game management
//***************************************************************

- (MCPeerID *)peerForUserId:(NSString *)userId {
    return [_peerRepository objectForKey:userId];
}

- (PLGameChannel *)hostGame {
    if (_hostedGame == nil) {
        PLGame *game = [[PLGame alloc] initWithOwnerId:self.peerId.displayName];
        _hostedGame = [[PLGameChannel alloc] initWithGameManager:self
                                                            game:game];

        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerId
                                                        discoveryInfo:nil
                                                          serviceType:[[self class] serviceType]];
        _advertiser.delegate = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_advertiser startAdvertisingPeer];
        });
    }

    return _hostedGame;
}

- (void)teardownHostedGame {
    if (_hostedGame == nil) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_advertiser stopAdvertisingPeer];
        [_hostedGame.session disconnect];
    });

    _advertiser = nil;
    _hostedGame = nil;
}

- (PLGameChannel *)joinGame:(PLGame *)game {
    if([game.ownerId isEqualToString:self.peerId.displayName]){
        @throw [NSException exceptionWithName:@"InvalidStateException" reason:@"can't join a self-hosted game" userInfo:nil];
    }

    PLGameChannel * gameChannel = [[PLGameChannel alloc] initWithGameManager:self
                                                                        game:game];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_browser invitePeer:[self peerForUserId:game.ownerId]
                   toSession:gameChannel.session
                 withContext:nil
                timeout:10];
    });

    return gameChannel;
}

//***************************************************************
#pragma mark -
#pragma mark multi-peer delegate
//***************************************************************

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSLog(@"%s -> peer: %@ infoDict: %@", sel_getName(_cmd), peerID, info);

    [_peerRepository setObject:peerID forKey:peerID.displayName];

    for (NSUInteger i = 0; i < [self countOfWaitingGames]; ++i) {
        PLGame *tmp = [self objectInWaitingGamesAtIndex:i];
        if ([tmp.ownerId isEqualToString:peerID.displayName]) {
            [self removeObjectFromWaitingGamesAtIndex:i];
            break;
        }
    }

    PLGame *game = [[PLGame alloc] initWithOwnerId:peerID.displayName];
    [self insertObject:game inWaitingGamesAtIndex:[self countOfWaitingGames]];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"%s -> peer: %@", sel_getName(_cmd), peerID);

    for (NSUInteger i = 0; i < [self countOfWaitingGames]; ++i) {
        PLGame *tmp = [self objectInWaitingGamesAtIndex:i];
        if ([tmp.ownerId isEqualToString:peerID.displayName]) {
            [self removeObjectFromWaitingGamesAtIndex:i];
            break;
        }
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    NSLog(@"%s", sel_getName(_cmd));

    NSLog(@"Failed to start listining for remote peers: %@", error);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler {
    NSLog(@"%s -> peer: %@", sel_getName(_cmd), peerID);

    if(_hostedGame == nil){
        invitationHandler(NO, nil);
    } else {
        invitationHandler(YES, _hostedGame.session);
    }
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    NSLog(@"%s", sel_getName(_cmd));

    NSLog(@"Failed to start advertising: %@", error);
}

@end