//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>
#import "PLGamePlayView.h"

@class PLGamePlayView;
@class PLGameChannel;


@interface PLGamePlayViewController : UIViewController <PLGamePlayViewDelegate>

@property (nonatomic, strong, readwrite) PLGameChannel * gameChannel;

@end