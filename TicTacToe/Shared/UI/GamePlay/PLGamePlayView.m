//
// Created by antoni on 3/11/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PLGamePlayView.h"
#import "PLGraphicsUtils.h"


@implementation PLGamePlayView {
@private
    NSArray *fields;
    UIView *bgView;
}
@synthesize delegate = delegate;

CGFloat const kGamePlayFieldPadding = 10;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:bgView];

        fields = @[[self buttonForField:0],
                [self buttonForField:1],
                [self buttonForField:2],
                [self buttonForField:3],
                [self buttonForField:4],
                [self buttonForField:5],
                [self buttonForField:6],
                [self buttonForField:7],
                [self buttonForField:8]];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat dim = (fmin(self.bounds.size.width, self.bounds.size.height) - kGamePlayFieldPadding * 4) / 3;
    CGPoint fieldOrigin = CGPointMake(
            (self.bounds.size.width - (dim * 3 + kGamePlayFieldPadding * 4)) / 2.0f + kGamePlayFieldPadding,
            (self.bounds.size.height - (dim * 3 + kGamePlayFieldPadding * 4)) / 2.0f + kGamePlayFieldPadding);

    CGFloat gameDim = dim * 3 + kGamePlayFieldPadding * 2;
    bgView.frame = CGRectMake(fieldOrigin.x,
            fieldOrigin.y,
            gameDim,
            gameDim);
    for (int i = 0; i <= 8; ++i) {
        int const ix = i % 3;
        int const iy = i / 3;
        ((UIView *) [fields objectAtIndex:i]).frame = CGRectMake(fieldOrigin.x + (kGamePlayFieldPadding + dim) * ix,
                fieldOrigin.y + (kGamePlayFieldPadding + dim) * iy,
                dim,
                dim);
    }
}


- (UIButton *)buttonForField:(NSUInteger)inx {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = inx;
    [button addTarget:self
               action:@selector(fieldWasPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:UIImageFromColor([UIColor whiteColor]) forState:UIControlStateNormal];
    [button setBackgroundImage:UIImageFromColor([UIColor redColor]) forState:UIControlStateHighlighted];
    [self addSubview:button];
    return button;
}

- (void)fieldWasPressed:(UIButton *)button {
    [self.delegate gameplayView:self didTapField:button.tag];
}

@end