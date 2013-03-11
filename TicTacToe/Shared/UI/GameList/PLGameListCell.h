//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>


@interface PLGameListCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel * hostNameLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

+(CGFloat) standardHeight;

@end