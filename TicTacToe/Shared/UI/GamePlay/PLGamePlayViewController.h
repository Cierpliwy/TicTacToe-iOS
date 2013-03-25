//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import "PLGamePlayView.h"

@class PLGamePlayView;
@class PLGameChannel;


@interface PLGamePlayViewController : UIViewController <PLGamePlayViewDelegate>

@property (nonatomic, strong, readwrite) PLGameChannel * gameChannel;

@end