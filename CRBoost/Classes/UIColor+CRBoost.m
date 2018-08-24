//
//  CRBoost.h
//  BMKP Driver Mobile
//
//  Created by Eric Wu
//  Copyright © 2016年 Cocoa. All rights reserved.
//

#import "UIColor+CRBoost.h"
#import "CRMacros.h"

#pragma mark -
#pragma mark UIColor
@implementation UIColor (CRBoost)
+ (UIColor *)randomColor {
    int red = arc4random_uniform(256);
    int green = arc4random_uniform(256);
    int blue = arc4random_uniform(256);
    return CRRGB(red, green, blue);
}

+ (UIColor *)randomColorMix:(UIColor *)color {
    UIColor *originalColor = [self randomColor];
    
    CGFloat red, green, blue;
    [originalColor getRed:&red green:&green blue:&blue alpha:nil];
    
    CGFloat mixRed, mixGreen, mixBlue;
    [color getRed:&mixRed green:&mixGreen blue:&mixBlue alpha:nil];
    
    return CRRGB_F((red+mixRed)/2, (green+mixGreen)/2, (blue+mixBlue)/2);
}





#pragma mark -
#pragma mark color from {R, G, B}
+ (UIColor *)colorWithString:(NSString *)string {
    if(![string hasPrefix:kBracketBigBegin] || ![string hasSuffix:kBracketBigEnd]) return nil;
    
    NSString *colorValue = [string substringWithRange:NSMakeRange(1, string.length-2)];
    NSArray *token = [colorValue componentsSeparatedByString:kSeparatorComma];
    UIColor *color = nil;
    if (token.count == 2) { //in white mode
        CGFloat white = [token[0] doubleValue];
        CGFloat alpha = [token[1] doubleValue];
        
        color = [UIColor colorWithWhite:white alpha:alpha];
        return color;
    }
    
    if (token.count == 3) { //R,G,B
        CGFloat red = [token[0] doubleValue];
        if(red>1) red = red/255;
        CGFloat green = [token[1] doubleValue];
        if(green>1) green = green/255;
        CGFloat blue = [token[2] doubleValue];
        if(blue>1) blue = blue/255;
        
        CGFloat alpha = 1;
        
        color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        return color;
    }
    
    if (token.count == 4) { //in R,G,B,A mode
        CGFloat red = [token[0] doubleValue];
        if(red>1) red = red/255;
        CGFloat green = [token[1] doubleValue];
        if(green>1) green = green/255;
        CGFloat blue = [token[2] doubleValue];
        if(blue>1) blue = blue/255;
        
        CGFloat alpha = [token[3] doubleValue];
        
        color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        return color;
    }
    
    return nil;
}

- (NSString *)string {
    CGFloat alpha;
    NSString *string = nil;
    
    const CGFloat *comps = CGColorGetComponents(self.CGColor);
    NSInteger count = CGColorGetNumberOfComponents(self.CGColor);
    
    if (count == 2) {
        string = [NSString stringWithFormat:@"{%0.3f,%0.3f}", comps[0], comps[1]];
    } else if (count == 4) {
        string = [NSString stringWithFormat:@"{%0.3f,%0.3f,%0.3f,%0.3f}", comps[0], comps[1], comps[2], comps[3]];
    }
    return string;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
    //try R, G, B mode
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    BOOL ret = [self getRed:&red green:&green blue:&blue alpha:&alpha];
    if (ret) {
        string = CRString(@"{%@,%@,%@,%@}", @(red), @(green), @(blue), @(alpha));
        return string;
    }
    
    //try white mode
    CGFloat white;
    ret = [self getWhite:&white alpha:&alpha];
    if (ret) {
        string = [NSString stringWithFormat:@"{%@,%@}", @(white), @(alpha)];
        return string;
    }
    
    return nil;
#pragma clang diagnostic pop

}

#pragma mark -
#pragma mark color from #rrggbb
+ (UIColor *)colorWithHex:(NSString *)hex
{
    if (![hex hasPrefix:@"#"])
    {
        hex = CRString(@"#%@", hex);
    }

    if (hex.length < 7)
        return nil;

    unsigned rgbHex = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbHex];
    
    if (hex.length == 9) {
        return [UIColor colorWithRed:((rgbHex & 0xFF000000) >> 24)/255.0 green:((rgbHex & 0xFF0000) >> 16)/255.0
                                blue:((rgbHex & 0xFF00) >> 8)/255.0 alpha:(rgbHex & 0xFF)/255.0];
    }
    
    if (hex.length == 7) {
        return [UIColor colorWithRed:((rgbHex & 0xFF0000) >> 16)/255.0 green:((rgbHex & 0xFF00) >> 8)/255.0
                                blue:(rgbHex & 0xFF)/255.0 alpha:1.0];
    }
    
    return nil;
}

- (NSString *)hex {
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int r = 255 * red, g = 255 * green, b = 255 * blue, a = 255 * alpha;
    
    return [NSString stringWithFormat:@"#%02x%02x%02x%02x", r, g, b, a];
}



#pragma mark -
#pragma mark lighten, darken
- (UIColor *)lighten:(float)amount {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        float newb= b * (1 + amount);
        float newh= h * (1 + amount);

        return [UIColor colorWithHue:newh saturation:s brightness:newb alpha:1];
    }
    
    return self;
}

- (UIColor *)darken:(float)amount {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        float newb = b * (1 - amount);
        float newh= h * (1 - amount/2);

        return [UIColor colorWithHue:newh saturation:s brightness:newb alpha:1];
    }
    
    return self;
}



#pragma mark - lighter or darker color
- (UIColor *)lighterOrDarker
{
    CGFloat amount = 0.2;
    CGFloat white;
    CGFloat alpha;
    [self getWhite:&white alpha:&alpha]; //REVIEW: what about RGB color space
    
    if (white<0.3) {
        return [[UIColor whiteColor] darken:amount];
    }
    else return [self darken:amount];
}



#pragma mark - white or black color
- (UIColor *)whiteOrBlack
{
    CGFloat white;
    CGFloat alpha;
    [self getWhite:&white alpha:&alpha]; //REVIEW: what about RGB color space
    if (white<0.35)
    {
        return [UIColor whiteColor];
    }
    else
    {
        return [UIColor blackColor];
    }
}




#pragma mark - opposite UIColor
- (UIColor *)oppositeColor
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha]; //REVIEW: what about White color space
    return [UIColor colorWithRed:1-red green:1-green blue:1-blue alpha:1];
}
@end
