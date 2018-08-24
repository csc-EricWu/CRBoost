//
//  CRBoost.h
//  BMKP Driver Mobile
//
//  Created by Eric Wu
//  Copyright © 2016年 Cocoa. All rights reserved.
//



@interface UIColor (CRBoost)
+ (UIColor *)randomColor;
+ (UIColor *)randomColorMix:(UIColor *)color;

/**
 *  create a UIColor object with the string
 *
 *  @param string the color string, must in this format: {white, alpha} or {red, gree, blue, alpha}
 *
 *  @return a UIColor object
 *
 *  @discuss use this method pair with the .string method.
 */
+ (UIColor *)colorWithString:(NSString *)string;
- (NSString *)string;


- (UIColor *)lighten:(float)amount; //amount: 0-1
- (UIColor *)darken:(float)amount;



/**
 *  create a UIColor object with the hex string, alpha channel will be ignored
 *
 *  @param hex the hex string, must be in this format: #rrggbb
 *
 *  @return a UIColor instance
 */
+ (UIColor *)colorWithHex:(NSString *)hex; //must in this format: #rrggbb
- (NSString *)hex; //a string with this pattern #rrggbb


/**
 *  return white or black color to suit the given color
 *
 *  @return White color, or black color
 *
 */
- (UIColor *)whiteOrBlack;

- (UIColor *)oppositeColor;

- (UIColor *)lighterOrDarker;

@end
