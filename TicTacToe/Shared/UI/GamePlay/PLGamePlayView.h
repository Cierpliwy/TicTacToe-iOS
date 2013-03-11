//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>

@class PLGamePlayView;

@protocol PLGamePlayViewDelegate <NSObject>

-(void) gameplayView:(PLGamePlayView*)gameplayView didTapField:(NSUInteger)field;

@end

@interface PLGamePlayView : UIView

@property (nonatomic, weak, readwrite) id<PLGamePlayViewDelegate> delegate;



@end