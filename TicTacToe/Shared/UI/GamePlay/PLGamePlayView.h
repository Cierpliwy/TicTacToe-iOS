//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>

@class PLGamePlayView;

@protocol PLGamePlayViewDelegate <NSObject>

- (void)gameplayView:(PLGamePlayView *)gameplayView didTapField:(NSUInteger)field;

@end

@interface PLGamePlayView : UIView

@property(nonatomic, weak, readwrite) id <PLGamePlayViewDelegate> delegate;

@property(nonatomic, strong, readonly) UILabel *stateLabel;
@property(nonatomic, strong, readonly) NSArray *fields;

-(void) setStateText:(NSString*)text textColor:(UIColor *)textColor backgroungColor:(UIColor *)bgColor animated:(BOOL)animated;

@end