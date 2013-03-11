//
// Created by antoni on 3/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "Typhoon.h"
#import "PLAssembly.h"
#import "PLIPhoneRootViewController.h"
#import "PLGameListViewController.h"

@implementation PLAssembly {

}

- (id)iPhoneRootViewController {
    return [TyphoonDefinition withClass:[PLIPhoneRootViewController class] initialization:^(TyphoonInitializer * initializer){
        initializer.selector = @selector(initWithGameListController:);
        [initializer injectWithDefinition:[self gameListViewController]];
    }];
}

- (id)gameListViewController {
    return [TyphoonDefinition withClass:[PLGameListViewController class] initialization:^(TyphoonInitializer * initializer){
        initializer.selector = @selector(init);
    }];
}

@end