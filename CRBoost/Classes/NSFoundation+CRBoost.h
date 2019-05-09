//
//  NSFoundation+CRBoost.h
//  BMKP Driver Mobile
//
//  Created by Eric Wu
//  Copyright © 2016年 Cocoa. All rights reserved.
//



#pragma mark -
#pragma mark NSObject
@interface NSObject (CRBoost)
- (void)tryMethod:(SEL)sel;
- (void)tryMethod:(SEL)sel arg:(id)arg;
- (void)tryMethod:(SEL)sel arg:(id)arg1 arg:(id)arg2;
- (NSArray<NSString *> *)propertyList;
- (NSArray<NSString *> *)propertyListWalkToAncestor:(Class)ancestor; //ancestor not included
- (id)nullToNil;
@end




#pragma mark -
#pragma mark NSString
extern NSString *const kPathFlagRetina;
extern NSString *const kPathFlagBig;
extern NSString *const kPathFlagHighlighted;
extern NSString *const kPathFlagSelected;

@interface NSString (CRBoost)
+ (NSString *)stringWithNumber:(NSInteger)number padding:(int)padding;
+ (BOOL)isBase64String:(NSString *)input;

- (NSAttributedString *)underlineAttributeString;
- (NSString *)pathByAppendingFlag:(NSString *)flag; //appending between file name and extension
- (NSString *)join:(NSString *)path;
- (NSString *)joinExt:(NSString *)ext;
- (NSString *)joinUrl:(NSString *)url;
- (NSString *)URLStringByAppendingQueryString:(NSString *)queryString;

- (NSString *)joinPath:(NSString *)path;
- (NSString *)joinPath:(NSString *)path1 path:(NSString *)path2;
- (NSString *)deleteLastPathComponent;
- (NSString *)deletePathExtension;
- (BOOL)beginWith:(NSString *)string;
- (BOOL)endWith:(NSString *)string;
- (NSString *)base64String;
//- (NSString *)decodeBase64String;
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (NSString *)md5String;
- (NSString *)removeDecimalLastZeros;

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)mask;

- (NSString *)phoneNumberFormat;
- (NSString *)randomStringWithLength:(NSInteger)len;



@end

#pragma mark -
#pragma mark NSURL
@interface NSURL (CRBoost)

/**
 remove the url query
 */
- (NSString *)absoluteStringByTrimmingQuery;

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString;
@end

#pragma mark -
#pragma mark NSDate
/**
 * date formatter
 *
 * date format
 * 0: no separator
 * 1: use '/' as separator
 * 2: use '-' as separator
 *
 * time format
 * 0: use ':' as separator
 */
static NSString *const kDateTemplate0yyyyMMdd = @"yyyyMMdd";
static NSString *const kDateTemplate0hmma = @"h:mm a";

static NSString *const kDateTemplate1MMddyyyy = @"MM/dd/yyyy";
static NSString *const kDateTemplate1MMddyy = @"MM/dd/yy";
static NSString *const kDateTemplate1ddMMyyyy0HHmmss = @"dd/MM/yyyy HH:mm:ss";
static NSString *const kDateTemplate1ddMMyyyy0HHmm = @"dd/MM/yyyy HH:mm";

static NSString *const kDateTemplate2MMddyyyy = @"MM-dd-yyyy";
static NSString *const kDateTemplate2yyyyMMdd0HHmmss = @"yyyy-MM-dd HH:mm:ss";
static NSString *const kDateTemplate2yyyyMMdd0HHmmssZZZ = @"yyyy-MM-dd HH:mm:ss ZZZ";
@interface NSDate (CRBoost)
+ (NSDate *)dateWithinYear;
+ (NSDate *)dateWithTimeIntervalSince1970Number:(NSNumber *)number;
+ (NSDate *)dateWithTimeIntervalSince1970String:(NSString *)string;
+ (NSDate *)dateWithString:(NSString *)date template:(NSString *)tmplate;
- (NSString *)stringWithTemplate:(NSString *)tmplate;
- (NSString *)timeIntervalSince1970String;
- (NSNumber *)timeIntervalSince1970Number;
- (NSNumber *)timeIntervalSince1970Number13;
- (BOOL)isSameDay:(NSDate *)date;
@end





#pragma mark -
#pragma mark NSMutableDictionary
@interface NSMutableDictionary (CRBoost)
- (void)safeSetObject:(id)obj forKey:(id<NSCopying>)key;
@end






#pragma mark -
#pragma mark NSArray
@interface NSArray (CRBoost)
- (id)safeObjectAtIndex:(NSInteger)index;
- (BOOL)containsKeyIgnoreCase:(NSString *)key;

@end





#pragma mark -
#pragma mark NSMutableArray
@interface NSMutableArray (CRBoost)
- (void)safeAddObject:(id)obj;
- (void)safeRemoveObjectAtIndex:(NSInteger)index;
- (void)moveObjectAtIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end




#pragma mark -
#pragma mark NSAttributedString
@interface NSAttributedString (CRBoost)
+ (instancetype)stringWithJSON:(id)json;
+ (instancetype)stringWithJSONString:(NSString *)string;
+ (instancetype)stringWithString:(NSString *)string attribute:(NSString *)attribute;

- (id)dumpJSON;
- (id)attributeJSON; //dump only the attribte to json
- (NSString *)jsonString;
//- (NSString *)attributes; //json like
- (BOOL)onlyContainsAchromaticColor; //whole string only contains black, white, grey color

- (CGSize)sizeThatFits:(CGSize)size;

- (CGFloat)widthToFit;

- (CGFloat)heightForWidth:(CGFloat)width;

@end;




#pragma mark -
#pragma mark NSMutableAttributedString
@interface NSMutableAttributedString (CRBoost)
@end





#pragma mark -
#pragma mark UIImage
typedef NS_ENUM(NSUInteger, UIImageType) {
    UIImageTypeJPG  = 0,
    UIImageTypePNG,
    UIImageTypeTIFF,
    UIImageTypeGIF,
};


@interface UIImage (CRBoost)
@property (nonatomic, assign) UIImageType type; //unless you are very sure, please do not change it
// image
+ (UIImage *)imageByScalingImage:(UIImage *)image toSize:(CGSize)newSize;
+ (UIImage *)imageByColorizingImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIImage *)imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIImage *)imageFromView:(UIView *)view;
+ (UIImage *)imageFromView:(UIView *)view size:(CGSize)size scale:(CGFloat)scale;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)scaleToSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
- (UIImage *)resizeWithImageMode:(UIImageResizingMode)resizingMode;
+ (CGSize)imageSizeWithURL:(NSURL *)URL;
@end
