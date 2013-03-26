//
// Created by Antoni Kędracki, Polidea
//

#import <UIKit/UIKit.h>

@class PLGameManager;

@interface PLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) PLGameManager * gameManager;

@end