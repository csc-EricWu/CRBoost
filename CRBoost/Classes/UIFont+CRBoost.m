//
//  UIFont+CRBoost.m
//  TED
//
//  Created by Eric Wu on 2/18/14.
//  Copyright (c) 2014 Cocoa. All rights reserved.
//

#import "UIFont+CRBoost.h"

#pragma mark -
#pragma mark UIFont
@implementation UIFont (CRBoost)
+ (UIFont *)helvetica14 {
    return [self helvetica:14];
}

+ (UIFont *)helvetica:(CGFloat)fontSize {
    static UIFont *helvetica = nil;
    helvetica = [self staticFont:helvetica type:@"Helvetica" size:fontSize];
    return helvetica;
}

+ (UIFont *)staticFont:(UIFont *)font type:(NSString *)name size:(CGFloat)fontSize {
    if (font == nil) {
        font = [UIFont fontWithName:name size:fontSize];
    } else if (font.pointSize != fontSize) {
        font = [font fontWithSize:fontSize];
    }
    return font;
}
@end