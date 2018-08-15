//
//  NSObject+UIKit_CRBoost.m
//  BMKP Driver Mobile
//
//  Created by Eric Wu on 16/4/19.
//  Copyright © 2016年 Jigs. All rights reserved.
//

#import "UIKit+CRBoost.h"

@implementation UIBarButtonItem (CRBoost)
+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.size = CGSizeMake(30, 30);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barItem;
}
@end

@implementation UIButton (CRBoost)
- (void)verticalImageAndTitle:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width)
    {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0);
}

@end

@implementation UITableViewCell (CRBoost)

- (void)setaccessoryView:(UIView *)view insets:(UIEdgeInsets)insets
{
    UIView *accessoryWrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.size.width + insets.left + insets.right, view.size.height + insets.top + insets.bottom)];
    [accessoryWrapperView addSubview:view];
    view.frame = CGRectMake(insets.left, insets.top, view.size.width, view.size.height);
    self.accessoryView = accessoryWrapperView;
}

@end

@implementation UIWebView (CRBoost)

- (BOOL)hasVideo
{
    __block BOOL hasVideoTag = NO;
    NSString *hasVideoTestString = @"document.documentElement.getElementsByTagName(\"video\").length";
    if (![[NSThread currentThread] isMainThread])
    {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *result = [self stringByEvaluatingJavaScriptFromString:hasVideoTestString];
            hasVideoTag = [result integerValue] >= 1 ? YES : NO;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        NSString *result = [self stringByEvaluatingJavaScriptFromString:hasVideoTestString];
        hasVideoTag = [result integerValue] >= 1 ? YES : NO;
    }
    return hasVideoTag;
}
- (NSString *)readVideoTitle
{
    __block NSString *title = nil;
    if (![[NSThread currentThread] isMainThread])
    {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
            title = [self stringByEvaluatingJavaScriptFromString:@"document.title"];
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        title = [self stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    return title;
}

- (double)readVideoDuration
{
    __block double duration = 0;
    if ([self hasVideo])
    {
        NSString *requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].duration.toFixed(1)";
        if (![[NSThread currentThread] isMainThread])
        {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);

            dispatch_async(dispatch_get_main_queue(), ^{

                NSString *result = [self stringByEvaluatingJavaScriptFromString:requestDurationString];
                duration = [result doubleValue];

                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else
        {
            NSString *result = [self stringByEvaluatingJavaScriptFromString:requestDurationString];
            duration = [result doubleValue];
        }
    }
    return duration;
}

- (double)readVideoCurrentTime
{
    __block double currentTime = 0;

    if ([self hasVideo])
    {
        NSString *requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].currentTime.toFixed(1)";
        if (![[NSThread currentThread] isMainThread])
        {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);

            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *result = [self stringByEvaluatingJavaScriptFromString:requestDurationString];
                currentTime = [result doubleValue];
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else
        {
            NSString *result = [self stringByEvaluatingJavaScriptFromString:requestDurationString];
            currentTime = [result doubleValue];
        }
    }
    return currentTime;
}

- (void)play
{
    if ([self hasVideo])
    {
        NSString *playString = @"document.documentElement.getElementsByTagName(\"video\")[0].play()";
        if (![[NSThread currentThread] isMainThread])
        {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);

            dispatch_async(dispatch_get_main_queue(), ^{
                [self stringByEvaluatingJavaScriptFromString:playString];

                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else
        {
            [self stringByEvaluatingJavaScriptFromString:playString];
        }
    }
}

- (void)pause
{
    if ([self hasVideo])
    {
        NSString *pauseString = @"document.documentElement.getElementsByTagName(\"video\")[0].pause()";
        if (![[NSThread currentThread] isMainThread])
        {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);

            dispatch_async(dispatch_get_main_queue(), ^{
                [self stringByEvaluatingJavaScriptFromString:pauseString];

                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else
        {
            [self stringByEvaluatingJavaScriptFromString:pauseString];
        }
    }
}

- (void)resume
{
    if ([self hasVideo])
    {
        NSString *resumeString = @"document.documentElement.getElementsByTagName(\"video\")[0].play()";
        if (![[NSThread currentThread] isMainThread])
        {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);

            dispatch_async(dispatch_get_main_queue(), ^{
                [self stringByEvaluatingJavaScriptFromString:resumeString];

                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else
        {
            [self stringByEvaluatingJavaScriptFromString:resumeString];
        }
    }
}

- (void)stop
{
    if ([self hasVideo])
    {
        NSString *stopString = @"document.documentElement.getElementsByTagName(\"video\")[0].pause()";
        if (![[NSThread currentThread] isMainThread])
        {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stringByEvaluatingJavaScriptFromString:stopString];

                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else
        {
            [self stringByEvaluatingJavaScriptFromString:stopString];
        }
    }
}
@end
