//
// Created by Antoni Kędracki, Polidea
//

#import "PLAppDelegate.h"
#import "Typhoon.h"
#import "PLAssembly.h"
#import "PLIPhoneRootViewController.h"
#import "PLGeneralUtils.h"
#import "PLGameManager.h"

@implementation PLAppDelegate

@synthesize gameManager = gameManager;

//TODO: replace with your server address
NSString * const SERVER_ADDR = @"10.0.3.154:8887";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //setup Typhoon Dependency Injection
    TyphoonComponentFactory* factory;
    factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[PLAssembly assembly]];
    [factory makeDefault];

    gameManager = [factory componentForType:[PLGameManager class]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    if (!isDevicePad()){
        self.window.rootViewController = [[TyphoonComponentFactory defaultFactory] componentForType:[PLIPhoneRootViewController class]];
    } else {
        @throw [NSException exceptionWithName:@"NotYetImplemented" reason:nil userInfo:nil];
    }

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end
