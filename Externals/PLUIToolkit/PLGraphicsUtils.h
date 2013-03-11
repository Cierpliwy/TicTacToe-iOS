/*
 Copyright (c) 2011, Antoni Kędracki, Polidea
 All rights reserved.
 
 mailto: akedracki@gmail.com
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Polidea nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY ANTONI KĘDRACKI, POLIDEA ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL ANTONI KĘDRACKI, POLIDEA BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */ 


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

CGRect CGRectMakeWithPointAndSize(CGPoint point, CGSize size);

CGRect CGRectBorderCut(CGRect src, CGFloat dLeft, CGFloat dTop, CGFloat dRight, CGFloat dBottom);
CGRect CGRectBorderCutFromSize(CGSize src, CGFloat dLeft, CGFloat dTop, CGFloat dRight, CGFloat dBottom);
CGRect CGRectMakeWithBorders(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom);

CGRect CGRectMakeForCropCenterWithAspectRatioFill(CGSize src, CGRect dst);
CGRect CGRectMakeForCropCenterWithAspectRatioFit(CGSize src, CGRect dst);

CGRect CGRectMakeWithCenterAndSize(CGPoint center, CGSize size);
CGRect CGRectMakeWithCenterAndSizeNegativeInsets(CGPoint center, CGSize size, UIEdgeInsets insets);
CGRect CGRectInsets(CGRect rect, UIEdgeInsets insets);

CGPoint CGPointForCGRectCenter(CGRect src);
CGRect CGRectForCGRectBound(CGRect src);

CGSize CGSizeScaledToFitIntoSize(CGSize orginale, CGSize constraint);

CGFloat CGPointVectorLeght(CGPoint v);
CGFloat CGPointVectorDotProduct(CGPoint a, CGPoint b);

UIColor * UIColorFromHex(NSUInteger color);
UIColor * UIColorFromHexWithAlfa(NSUInteger color);

UIImage * UIImageFromColor(UIColor * color);

//---------------------------------------------------------------------------------------------
// Categories
//---------------------------------------------------------------------------------------------

@interface UIView (UIViewMeasuringCategory)

- (void) setFrameWithPosition:(CGPoint)aPoint andSize:(CGSize)aSize;
+ (CGSize) sizeOfLabel:(UILabel*)aLabel constrainedToSize:(CGSize)aConstrainedSize;
+ (CGFloat) centerFactorForDimension:(CGFloat)aDim constrainedToDimension:(CGFloat)aConstrainedDim;

@end

@interface UIView (UIViewDrawiningCategory)
    + (void) drawLinearGradientInRect:(CGRect)rect gradientColors:(NSArray*)colorsList;
@end

@interface UIImage(UIImageRedrawCategory) 

-(UIImage *)redraw;
-(UIImage *)redrawScaleToFitInSize:(CGSize)fitSize;

@end

//---------------------------------------------------------------------------------------------
