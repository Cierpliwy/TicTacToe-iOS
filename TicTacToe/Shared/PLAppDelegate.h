//
//  PLAppDelegate.h
//  TicTacToe
//
//  Created by Antoni Kedracki on 03/08/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLGameManager;

@interface PLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) PLGameManager * gameManager;

@end