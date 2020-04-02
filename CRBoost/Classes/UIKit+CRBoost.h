//
//  NSObject+UIKit_CRBoost.h
//  BMKP Driver Mobile
//
//  Created by Eric Wu
//  Copyright © 2016年 Cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+CRBoost.h"
@import WebKit;

@interface UIBarButtonItem (CRBoost)
+ (instancetype)barButtonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

@end

@interface UIButton (CRBoost)

- (void)verticalImageAndTitle:(CGFloat)spacing;

@end

@interface UITableViewCell (CRBoost)

- (void)setaccessoryView:(UIView *)view insets:(UIEdgeInsets)insets;

@end

@interface WKWebView (CRBoost)
//https://stackoverflow.com/questions/26778955/wkwebview-evaluate-javascript-return-value
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;

- (BOOL)hasVideo;
- (NSString *)readVideoTitle;
- (double)readVideoDuration;
- (double)readVideoCurrentTime;

- (void)play;
- (void)pause;
- (void)resume;
- (void)stop;
@end
