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


#import "PLGraphicsUtils.h"

//---------------------------------------------------------------------------------------------

CGRect CGRectMakeWithPointAndSize(CGPoint point, CGSize size){
    return CGRectMake(point.x, point.y, size.width, size.height);
}

CGRect CGRectBorderCut(CGRect src, CGFloat dLeft, CGFloat dTop, CGFloat dRight, CGFloat dBottom){
    return CGRectMake(src.origin.x + dLeft, src.origin.y + dTop, src.size.width - dLeft - dRight, src.size.height - dTop - dBottom);
}

CGRect CGRectBorderCutFromSize(CGSize src, CGFloat dLeft, CGFloat dTop, CGFloat dRight, CGFloat dBottom){
        return CGRectMake(dLeft, dTop, src.width - dLeft - dRight, src.height - dTop - dBottom);
}

CGRect CGRectMakeWithBorders(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom){
    return CGRectMake(left, top, right - left, bottom - top);
}

CGRect CGRectMakeForCropCenterWithAspectRatioFill(CGSize src, CGRect dst){
    CGFloat hScale = src.width / dst.size.width;
    CGFloat vScale = src.height / dst.size.height;
    CGSize expanded = hScale < vScale ? CGSizeMake(src.width / hScale, src.height / hScale) : CGSizeMake(src.width / vScale, src.height / vScale);
    
    return CGRectMake(dst.origin.x + dst.size.width/2 - expanded.width/2, dst.origin.y + dst.size.height/2 - expanded.height/2, expanded.width, expanded.height);
}

CGRect CGRectMakeForCropCenterWithAspectRatioFit(CGSize src, CGRect dst){
    CGFloat hScale = src.width / dst.size.width;
    CGFloat vScale = src.height / dst.size.height;
    CGSize expanded = hScale > vScale ? CGSizeMake(src.width / hScale, src.height / hScale) : CGSizeMake(src.width / vScale, src.height / vScale);
    
    return CGRectMake(dst.origin.x + dst.size.width/2 - expanded.width/2, dst.origin.y + dst.size.height/2 - expanded.height/2, expanded.width, expanded.height);
}

CGRect CGRectMakeWithCenterAndSize(CGPoint center, CGSize size){
    return CGRectMake(center.x - size.width/2.0f, center.y - size.height/2.0f, size.width, size.height);
}

CGRect CGRectMakeWithCenterAndSizeNegativeInsets(CGPoint center, CGSize size, UIEdgeInsets insets) {
    CGFloat iW = insets.left + insets.right;
    CGFloat iH = insets.top + insets.bottom;
    return CGRectMake(center.x - size.width/2.0f - insets.left, center.y - size.height/2.0f - insets.top, size.width + iW, size.height + iH);
}

CGRect CGRectInsets(CGRect rect, UIEdgeInsets insets){
    CGFloat iW = insets.left + insets.right;
    CGFloat iH = insets.top + insets.bottom;
    return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top, rect.size.width - iW, rect.size.height - iH);
}

CGSize CGSizeScaledToFitIntoSize(CGSize orginal, CGSize constraint){
    CGFloat hScale = orginal.width / constraint.width;
    CGFloat vScale = orginal.height / constraint.height;
    return hScale > vScale ? CGSizeMake(orginal.width / hScale, orginal.height / hScale) : CGSizeMake(orginal.width / vScale, orginal.height / vScale); 
}

CGPoint CGPointForCGRectCenter(CGRect src){
    return CGPointMake(CGRectGetMidX(src), CGRectGetMidY(src));
}

CGRect CGRectForCGRectBound(CGRect src){
    return CGRectMake(0, 0, src.size.width, src.size.height);
}

CGFloat CGPointVectorLeght(CGPoint v){
    return sqrtf(v.x * v.x + v.y * v.y);
}

CGFloat CGPointVectorDotProduct(CGPoint a, CGPoint b){
    return a.x*b.x + a.y*b.y;
}

UIColor * UIColorFromHex(NSUInteger color){
    return [UIColor colorWithRed:(((color >> 16)&0xFF)/255.0f) green:(((color >> 8)&0xFF)/255.0f) blue:((color&0xFF)/255.0f) alpha:1.0f];
}

UIColor * UIColorFromHexWithAlfa(NSUInteger color){
    return [UIColor colorWithRed:(((color >> 16)&0xFF)/255.0f) green:(((color >> 8)&0xFF)/255.0f) blue:((color&0xFF)/255.0f) alpha:(((color >> 24)&0xFF)/255.0f)];
}

UIImage * UIImageFromColor(UIColor * color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//---------------------------------------------------------------------------------------------
// Categories
//---------------------------------------------------------------------------------------------

@implementation UIView (UIViewMeasuringCategory)

+ (CGSize) sizeOfLabel:(UILabel*)aLabel constrainedToSize:(CGSize)aConstrainedSize
{
    CGSize labelSize = CGSizeZero;
    if (aLabel.text) {
        labelSize = [aLabel.text sizeWithFont:aLabel.font constrainedToSize:aConstrainedSize lineBreakMode:aLabel.lineBreakMode];
    }
    return labelSize;
}

+ (CGFloat) centerFactorForDimension:(CGFloat)aDim constrainedToDimension:(CGFloat)aConstrainedDim
{
    return floor((aConstrainedDim - aDim)/2);
}

- (void) setFrameWithPosition:(CGPoint)aPoint andSize:(CGSize)aSize
{
    self.frame = CGRectMake(aPoint.x, aPoint.y, aSize.width, aSize.height);
}


@end

//---------------------------------------------------------------------------------------------

@implementation UIView (UIViewDrawiningCategory)


+ (void) startPoint:(CGPoint*)aStartPtr endPoint:(CGPoint*)aEndPtr inRect:(CGRect)rect forAngle:(CGFloat)aAngle withOffset:(CGFloat)offset
{
    *aStartPtr= rect.origin;
    *aEndPtr= CGPointMake((*aStartPtr).x, CGRectGetMaxY(rect));
}

+ (void) drawLinearGradientInRect:(CGRect)rect gradientColors:(NSArray*)colorsList
{
    NSInteger numOfColors=1;
    numOfColors = [colorsList count];
    if (!numOfColors && numOfColors == 1) {
        // NSLog(@"Too few colors for gradient!");
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSInteger numOfComponents = 4;
    NSInteger comp=numOfColors*numOfComponents;
    CGFloat components[comp];
    CGFloat locations[numOfColors];
    CGFloat locationDelta = 1.0f/(numOfColors-1);
    
    for (NSInteger i=0; i<numOfColors; i++) {
        locations[i] = i*locationDelta;
        UIColor *aColor = [colorsList objectAtIndex:i];
        const CGFloat* colorComponents = CGColorGetComponents(aColor.CGColor);
        for (NSInteger j=0; j<numOfComponents; j++) {
            components[i*numOfComponents+j] = colorComponents[j];
        }
    }
    
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, numOfColors);
    
    CGPoint startPoint, endPoint;
    [self startPoint:&startPoint endPoint:&endPoint inRect:rect forAngle:M_PI withOffset:0.0f];
    CGContextDrawLinearGradient(context, myGradient, startPoint, endPoint, 0);
    
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
}

@end

//---------------------------------------------------------------------------------------------

@implementation UIImage(UIImageRedrawCategory)

-(UIImage *)redraw{
    return [self redrawScaleToFitInSize:self.size];
}

-(UIImage *)redrawScaleToFitInSize:(CGSize)fitSize{
    CGSize scaledSize = CGSizeScaledToFitIntoSize(self.size, fitSize);
    
    UIGraphicsBeginImageContext(scaledSize);		
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);								
    
    [self drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    
    UIGraphicsPopContext();								
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end

