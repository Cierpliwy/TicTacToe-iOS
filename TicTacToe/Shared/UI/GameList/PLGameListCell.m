//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLGameListCell.h"
#import "PLGraphicsUtils.h"


@implementation PLGameListCell {

}
@synthesize hostNameLabel;

CGFloat const kGameListCellPadding = 10;
CGFloat const kGameListHostNameFontSize = 14;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:UIImageFromColor(UIColorFromHex(0xeeffee))];

        hostNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        hostNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        hostNameLabel.backgroundColor = [UIColor clearColor];
        hostNameLabel.font = [UIFont systemFontOfSize:kGameListHostNameFontSize];
        hostNameLabel.numberOfLines = 1;
        hostNameLabel.textAlignment = UITextAlignmentLeft;
        hostNameLabel.textColor = [UIColor blackColor];
        [self addSubview:hostNameLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    hostNameLabel.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(kGameListCellPadding, kGameListCellPadding, kGameListCellPadding, kGameListCellPadding));
}

+ (CGFloat)standardHeight {
    return kGameListCellPadding * 2 + [UIFont systemFontOfSize:kGameListHostNameFontSize].lineHeight;
}
@end