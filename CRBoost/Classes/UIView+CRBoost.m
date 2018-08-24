//
//  UIView+Position.m
//  CRBoost
//
//  Created by Eric Wu
//  Copyright (c) 2016 Cocoa. All rights reserved.
//

#import "UIView+CRBoost.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "CRMacros.h"
#import "CRMath.h"

static char kGradientLayerKey;

@interface UIView ()
//@property (nonatomic, strong) UIView *topBanner;
@property (nonatomic, strong) KeyboardStateTask keyboardWillShowTask;
@property (nonatomic, strong) KeyboardStateTask keyboardWillHideTask;
@end


@implementation UIView (CRBoost)
//- (void)dealloc
//{
//    [self cleanupKeyboardWillShowObserver];
//    [self cleanupKeyboardWillHideObserver];
//}

#pragma mark -
#pragma mark getter
- (CGFloat)x {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)y {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (CGFloat)rightMostX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)topY { //(x, y): (0, 0)
    return CGRectGetMinY(self.frame);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGPoint)bottomRightPoint {
    return CGPointMake(self.rightMostX, CGRectGetMaxY(self.frame));
}

- (CGPoint)bottomLeftPoint
{
    return CGPointMake(self.x, CGRectGetMaxY(self.frame));
}

- (CGPoint)topLeftPoint {
    return CGPointMake(self.x, self.topY);
}

- (CGPoint)topRightPoint {
    return CGPointMake(self.rightMostX, self.topY);
}

- (CGSize)size {
    return self.frame.size;
}

- (CGSize)boundSize {
    return self.bounds.size;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (UIView *)topLayerSubviewWithTag:(NSInteger)tag {
    for (UIView *view in self.subviews)
    {
        if (view.tag == tag) {
            return view;
        }
    }
    return nil;
}

- (id)ancestorViewOfKind:(Class)kind {
    UIView *superview = self.superview;
    while (superview && ![superview isKindOfClass:kind]) {
        superview = self.superview;
    }
    return superview;
}


- (id)childrenViewOfKind:(Class)kind
{
    for (UIView *view in self.subviews)
    {
        if (CRKindClass(view, kind))
        {
            return view;
        }
        else
        {
            UIView *subView = [view childrenViewOfKind:kind];
            if (subView)
            {
                return subView;
            }
        }
    }
    return nil;
}

#pragma mark -
#pragma mark setter
- (void)setX:(CGFloat)x {
    self.frame = (CGRect){x, self.y, self.size};
}

- (void)setY:(CGFloat)y {
    self.frame = (CGRect){self.x, y, self.size};
}

- (void)setWidth:(CGFloat)width {
    self.frame = (CGRect){self.origin, width, self.height};
}

- (void)setHeight:(CGFloat)height {
    self.frame = (CGRect){self.origin, self.width, height};
}

- (void)setRightMostX:(CGFloat)rightMostX {
    self.frame = (CGRect){rightMostX-self.width, self.y, self.size};
}

- (void)setTopY:(CGFloat)topY {
    self.frame = (CGRect){self.x, topY-self.height, self.size};
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = (CGRect){origin, self.size};
}

- (void)setBottomRightPoint:(CGPoint)bottomRightPoint {
    self.frame = (CGRect){bottomRightPoint.x - self.width, bottomRightPoint.y - self.height, self.size};
}

- (void)setBottomLeftPoint:(CGPoint)bottomLeftPoint
{
    self.frame = (CGRect){bottomLeftPoint.x, bottomLeftPoint.y - self.height, self.size};
}
- (void)setTopLeftPoint:(CGPoint)topLeftPoint {
    self.frame = (CGRect){topLeftPoint.x, topLeftPoint.y-self.height, self.size};
}

- (void)setTopRightPoint:(CGPoint)topRightPoint {
    self.frame = (CGRect){topRightPoint.x-self.width, topRightPoint.y-self.height, self.size};
}

- (void)setSize:(CGSize)size {
    self.frame = (CGRect){self.origin, size};
}

- (void)setBoundSize:(CGSize)boundSize {
    self.bounds = (CGRect){0, 0, boundSize};
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    CRIfReturn(cornerRadius<0);
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}



#pragma mark -
#pragma mark geometry
- (void)centerHorizontally {
    if(!self.superview) return;
    
    self.x = (self.superview.width - self.width) / 2;
}

- (void)centerVertically {
    if(!self.superview) return;
    
    self.y = (self.superview.height - self.height) / 2;
}

- (void)centerInSuperview {
    if(!self.superview) return;
    
    self.center = CRBoundCenter(self.superview.frame);
}



#pragma mark -
#pragma mark convenient
+ (instancetype)viewWithSize:(CGSize)size {
    return [self viewWithFrame:(CGRect){0, 0, size}];
}


+ (instancetype )viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

+ (UIView *)viewWithColor:(UIColor *)color size:(CGSize)size {
    UIView *view = [self viewWithSize:size];
    view.backgroundColor = color;
    
    return view;
}

+ (UIView *)viewByRoundingAndStrokingImage:(UIImage *)image {
    // make new layer to contain shadow and masked image
    CGRect rect = (CGRect){0, 0, image.size};
    CALayer* containerLayer = [CALayer layer];
    containerLayer.shadowColor = [UIColor blackColor].CGColor;
    containerLayer.shadowRadius = 2.5f;
    containerLayer.shadowOffset = CGSizeMake(0.f, 1.f);
    containerLayer.shadowOpacity = 0.8;
    
    // use the image to mask the image into a circle
    CALayer *contentLayer = [CALayer layer];
    contentLayer.contents = (id)image.CGImage;
    contentLayer.frame = rect;
    
    contentLayer.borderColor = [UIColor colorWithRed:0.825 green:0.82 blue:0.815 alpha:1.0].CGColor;
    contentLayer.borderWidth = 1.0;
    contentLayer.cornerRadius = 6.0;
    contentLayer.masksToBounds = YES;
    
    // add masked image layer into container layer so that it's shadowed
    [containerLayer addSublayer:contentLayer];
    
    // add container including masked image and shadow into view
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view.layer addSublayer:contentLayer];
    
    return view;
}





#pragma mark -
#pragma mark keyboard
static char keyboardWillShowTaskKey;
- (void)setupTaskOnKeybardWillShow:(KeyboardStateTask)task {
    [self cleanupKeyboardWillShowObserver];
    objc_setAssociatedObject(self, &keyboardWillShowTaskKey, task, OBJC_ASSOCIATION_COPY);
    
    CRRegisterNotification(@selector(keyboardWillShow:), UIKeyboardWillShowNotification);
}

- (KeyboardStateTask)keyboardWillShowTask {
    return objc_getAssociatedObject(self, &keyboardWillShowTaskKey);
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect rectUser = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect rectKeyboard = [self convertRect:rectUser fromView:nil];
    self.keyboardWillShowTask(rectKeyboard);
    
//    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] ;
}

static char keyboardWillHideTaskKey;
- (void)setupTaskOnKeybardWillHide:(KeyboardStateTask)task {
    [self cleanupKeyboardWillHideObserver];
    objc_setAssociatedObject(self, &keyboardWillHideTaskKey, task, OBJC_ASSOCIATION_COPY);
    
    CRRegisterNotification(@selector(keyboardWillHide:), UIKeyboardWillHideNotification);
}

- (KeyboardStateTask)keyboardWillHideTask {
    return objc_getAssociatedObject(self, &keyboardWillHideTaskKey);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect rectUser = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect rectKeyboard = [self convertRect:rectUser fromView:nil];
    self.keyboardWillHideTask(rectKeyboard);
}


- (void)cleanupKeyboardWillShowObserver {
    if (self.keyboardWillShowTask) {
        objc_setAssociatedObject(self, &keyboardWillShowTaskKey, nil, OBJC_ASSOCIATION_ASSIGN);
        CRUnregisterNotification2(self, UIKeyboardWillShowNotification);
    }
}

- (void)cleanupKeyboardWillHideObserver {
    if (self.keyboardWillHideTask) {
        objc_setAssociatedObject(self, &keyboardWillHideTaskKey, nil, OBJC_ASSOCIATION_ASSIGN);
        CRUnregisterNotification2(self, UIKeyboardWillHideNotification);
    }
}


#pragma mark -
#pragma mark top banner


#pragma mark -
#pragma mark animation
- (void)pulsateOnce {
    CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    scaleUp.duration = 0.125;
    scaleUp.repeatCount = 1;
    scaleUp.autoreverses = YES;
    scaleUp.removedOnCompletion = YES;
    
    scaleUp.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformScale(self.transform, 1.2, 1.2)];
//                       valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    
    [self.layer addAnimation:scaleUp forKey:@"pulsate"];
}



#pragma mark -
#pragma mark transition
- (void)transitToSubview:(UIView *)view option:(UIViewAnimationOptions)option duration:(CGFloat)duration {
    [UIView transitionWithView:self
                      duration:duration
                       options:option
                    animations:^{[self addSubview:view];}
                    completion:nil];
}

#pragma mark -
#pragma mark gradient
- (void)setGradientBackground:(UIColor *)startColor toColor:(UIColor *)toColor
{
    if (self.gradientLayer)
    {
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
    }
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)toColor.CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1.0, 0);
    self.gradientLayer.locations = @[@0, @1.0];
    self.gradientLayer.frame = CGRectMake(0, 0, self.width, self.height);
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (CAGradientLayer *)gradientLayer
{
    return objc_getAssociatedObject(self, &kGradientLayerKey);
}
- (void)setGradientLayer:(CAGradientLayer *)gradientLayer
{
    objc_setAssociatedObject(self, &kGradientLayerKey, gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -
#pragma mark gesture
- (UITapGestureRecognizer *)addTapRecognizer:(id)target action:(SEL)action {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:recognizer];
        }
    }
    
    if(!self.userInteractionEnabled) self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
    return tapRecognizer;
}

- (UIPanGestureRecognizer *)addPanRecognizer:(id)target action:(SEL)action {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self removeGestureRecognizer:recognizer];
        }
    }
    
    if(!self.userInteractionEnabled) self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panRecognizer];
    
    return panRecognizer;
}




- (void)whenTouches:(NSUInteger)numTouches tapped:(NSUInteger)numTaps handler:(CRCompletionTask)task {
}
- (void)whenTapped:(CRCompletionTask)task {
    //Adds a recognizer for one finger tapping once.
}
- (void)whenDoubleTapped:(CRCompletionTask)task {
}
- (void)eachSubview:(void(^)(UIView *view))task {
}
- (void)onTouchDown:(CRCompletionTask)task {
}
- (void)onTouchMove:(CRCompletionTask)task {
}
- (void)onTouchUp:(CRCompletionTask)task {
}

@end
