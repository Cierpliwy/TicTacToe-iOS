//
// Created by Antoni Kędracki, Polidea
//

#import "PLGamePlayView.h"
#import "PLGraphicsUtils.h"


@interface PLGamePlayView ()

@property(nonatomic, strong, readwrite) NSArray *fields;

@end

@implementation PLGamePlayView {
@private
    UIView *bgView;
}

@synthesize delegate = _delegate;
@synthesize fields = _fields;
@synthesize stateLabel = _stateLabel;

CGFloat const kGamePlayFieldPadding = 10;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:bgView];

        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLabel.font = [UIFont boldSystemFontOfSize:15];
        _stateLabel.textAlignment = UITextAlignmentCenter;
        _stateLabel.backgroundColor = [UIColor blackColor];
        _stateLabel.textColor = [UIColor whiteColor];
        [self addSubview:_stateLabel];

        self.fields = @[[self createButtonForField:0],
                [self createButtonForField:1],
                [self createButtonForField:2],
                [self createButtonForField:3],
                [self createButtonForField:4],
                [self createButtonForField:5],
                [self createButtonForField:6],
                [self createButtonForField:7],
                [self createButtonForField:8]];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _stateLabel.frame = CGRectMake(0, 0, self.bounds.size.width, _stateLabel.font.lineHeight * 1.6f);

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
        ((UIView *) [self.fields objectAtIndex:i]).frame = CGRectMake(fieldOrigin.x + (kGamePlayFieldPadding + dim) * ix,
                fieldOrigin.y + (kGamePlayFieldPadding + dim) * iy,
                dim,
                dim);
    }
}


- (UIButton *)createButtonForField:(NSUInteger)inx {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = inx;
    [button addTarget:self
               action:@selector(fieldWasPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:UIImageFromColor([UIColor whiteColor]) forState:UIControlStateNormal];
    [button setBackgroundImage:UIImageFromColor([UIColor redColor]) forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:40];
    [self addSubview:button];
    return button;
}

- (void)fieldWasPressed:(UIButton *)button {
    [self.delegate gameplayView:self didTapField:button.tag];
}

- (void)setStateText:(NSString *)text textColor:(UIColor *)textColor backgroungColor:(UIColor *)bgColor animated:(BOOL)animated {
    if([_stateLabel.textColor isEqual:textColor] && [_stateLabel.text isEqualToString:text] && [_stateLabel.backgroundColor isEqual:bgColor]){
        return;
    }

    void (^setupBlock)() = ^{
        _stateLabel.text = text;
        _stateLabel.textColor = textColor;
        _stateLabel.backgroundColor = bgColor;
    };

    if (!animated) {
        setupBlock();
    } else {
        CGFloat const animDuration = 0.2f;
        [UIView animateWithDuration:animDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _stateLabel.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             if (!finished) {
                                 return;
                             }
                             setupBlock();
                             [UIView animateWithDuration:animDuration
                                                   delay:0
                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  _stateLabel.alpha = 1;
                                              }
                                              completion:nil];
                         }];
    }
}

@end