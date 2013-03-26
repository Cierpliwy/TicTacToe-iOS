//
// Created by Antoni Kędracki, Polidea
//

#import <Foundation/Foundation.h>


@interface PLGameListCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel * hostNameLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

+(CGFloat) standardHeight;

@end