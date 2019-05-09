//
//  NSFoundation+CRBoost.m
//  BMKP Driver Mobile
//
//  Created by Eric Wu
//  Copyright © 2016年 Cocoa. All rights reserved.
//

#import "NSFoundation+CRBoost.h"
#import <CommonCrypto/CommonDigest.h>
@import ObjectiveC.runtime;
#import "CRMath.h"
#import "UIColor+CRBoost.h"

#pragma mark -
#pragma mark NSObject
@implementation NSObject (CRBoost)
- (void)tryMethod:(SEL)sel
{
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL) = (void *)imp;
        func(self, sel);
    }
}

- (void)tryMethod:(SEL)sel arg:(id)arg
{
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL, id) = (void *)imp;
        func(self, sel, arg);
    }
}

- (void)tryMethod:(SEL)sel arg:(id)arg1 arg:(id)arg2
{
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL, id, id) = (void *)imp;
        func(self, sel, arg1, arg2);
    }

    //http://stackoverflow.com/questions/12454408/variable-number-of-method-parameters-in-objective-c-need-an-example

    //http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

    /*
     In your project Build Settings, under Other Warning Flags (WARNING_CFLAGS), add
     -Wno-arc-performSelector-leaks
     */
}

- (NSArray<NSString *> *)propertyList
{
    NSMutableArray *propertyNames = [NSMutableArray new];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);

    for (int index = 0; index < propertyCount; index++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[index])];
        [propertyNames addObject:propertyName];
    }
    free(properties);

    return [NSArray arrayWithArray:propertyNames];
}

- (NSArray<NSString *> *)propertyListWalkToAncestor:(Class)ancestor
{
    NSMutableArray *propertyList = [NSMutableArray array];

    Class nextclass = self.class;
    while (nextclass && nextclass != ancestor) { //sometime it may not work, the !=
        NSArray *list = [nextclass propertyList];
        [propertyList addObjectsFromArray:list];

        nextclass = nextclass.superclass;
    }

    return [NSArray arrayWithArray:propertyList];
}

- (id)nullToNil
{
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return self;
    }
}

@end

#pragma mark -
#pragma mark NSString
NSString *const kPathFlagRetina = @"@2x";
NSString *const kPathFlagBig = @"Big";
NSString *const kPathFlagHighlighted = @"Hlt";
NSString *const kPathFlagSelected = @"Slt";

@implementation NSString (CRBoost)
+ (NSString *)stringWithNumber:(NSInteger)number padding:(int)padding
{
    NSString *formater = CRString(@"%%0%id", padding);
    return CRString(formater, number);
}

+ (BOOL)isBase64String:(NSString *)input
{
    input = [[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    if ([input length] % 4 == 0) {
        static NSCharacterSet *invertedBase64CharacterSet = nil;
        if (invertedBase64CharacterSet == nil) {
            invertedBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="]invertedSet];
        }
        return [input rangeOfCharacterFromSet:invertedBase64CharacterSet options:NSLiteralSearch].location == NSNotFound;
    }
    return NO;
}

- (NSAttributedString *)underlineAttributeString
{
    static NSDictionary *underlineAttribute = nil;
    if (!underlineAttribute) {
        underlineAttribute = @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    }

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:underlineAttribute];

    return attributedString;
}

- (NSString *)pathByAppendingFlag:(NSString *)flag
{
    NSString *extension = [self pathExtension];
    NSString *pathBody = [self stringByDeletingPathExtension];
    NSString *newPath = CRString(@"%@%@.%@", pathBody, flag, extension);

    return newPath;
}

- (NSString *)join:(NSString *)path
{
    return path ? [self stringByAppendingString:path] : nil;
}

- (NSString *)joinExt:(NSString *)ext
{
    return [self stringByAppendingPathExtension:ext];
}

- (NSString *)joinUrl:(NSString *)url
{
    NSString *urlPath = self;
    if ([self endWith:kSeparatorSlash]) {
        urlPath = [self substringToIndex:self.length - 1];
    }
    if ([url beginWith:kSeparatorSlash]) {
        url = [url substringFromIndex:1];
    }
    return [[urlPath join:kSeparatorSlash] join:url];
//    return [urlPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)URLStringByAppendingQueryString:(NSString *)queryString
{
    if (![queryString length]) {
        return self;
    }
    return [NSString stringWithFormat:@"%@%@%@", self,
            [self rangeOfString:@"?"].length > 0 ? @"&" : @"?", queryString];
}

//- (NSString *)URLStringByAppendingQueryParameters:(NSDictionary *)parameters
//{
//    if (!parameters) {
//        return self;
//    }
//    NSURL *URL = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//}
- (NSString *)joinPath:(NSString *)path
{
    return [self stringByAppendingPathComponent:path];
}

- (NSString *)joinPath:(NSString *)path1 path:(NSString *)path2
{
    return [[self joinPath:path1] joinPath:path2];
}

- (NSString *)deleteLastPathComponent
{
    return [self stringByDeletingLastPathComponent];
}

- (NSString *)deletePathExtension
{
    return [self stringByDeletingPathExtension];
}

- (BOOL)endWith:(NSString *)string
{
    NSUInteger length = string.length;
    if (length == 0 || length > self.length) {
        return NO;
    }

    NSString *end = [self substringFromIndex:self.length - length];
    return [string isEqualToString:end];
}

- (BOOL)beginWith:(NSString *)string
{
    NSUInteger length = string.length;
    if (length == 0 || length > self.length) {
        return NO;
    }

    NSString *begin = [self substringToIndex:length];
    return [string isEqualToString:begin];
}

- (NSString *)base64String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64 = [data base64EncodedStringWithOptions:0];

    return base64;
}

//- (NSString *)decodeBase64String
//{
//    NSData *data = [GTMBase64 decodeString:self];
//    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//}
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{ NSFontAttributeName: font };
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (NSString *)md5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);

    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]];
}

- (NSString *)removeDecimalLastZeros
{
    NSString *result = self;
    while ([result containsString:@"."] && [result hasSuffix:@"0"])
        result = [self substringToIndex:result.length - 1];
    if ([result hasSuffix:@"."]) {
        result = [self substringToIndex:result.length - 1];
    }
    return result;
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)mask
{
    if (string == nil) return NO;
    return [self rangeOfString:string options:mask].location != NSNotFound;
}

- (NSString *)phoneNumberFormat
{
    if (self.length == 11) {
        NSMutableString *strFormatPhone = [NSMutableString stringWithFormat:@"%@", self];
        for (int idx = 0; idx < self.length; idx++) {
            if (idx == 2) {
                [strFormatPhone insertString:@" " atIndex:idx + 1];
            } else if (idx == 7) {
                [strFormatPhone insertString:@" " atIndex:idx + 1];
            }
        }
        return strFormatPhone;
    }
    return self;
}

- (NSString *)randomStringWithLength:(NSInteger)len
{
    if (!self) return self;
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat:@"%C", [self characterAtIndex:arc4random_uniform((int)[self length])]];
    }
    return randomString;
}

@end

#pragma mark -
#pragma mark NSURL
@implementation NSURL (CRBoost)
- (NSString *)absoluteStringByTrimmingQuery
{
    NSURLComponents *urlcomponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    if (urlcomponents) {
        urlcomponents.query = nil;
    }
    return urlcomponents.string;
}

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString
{
    if (![queryString length]) {
        return self;
    }
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    NSURL *fullURL = [NSURL URLWithString:URLString];
    return fullURL;
}

@end

#pragma mark -
#pragma mark NSDate
@implementation NSDate (CRBoost)
+ (NSDate *)dateWithinYear
{
    NSDate *today = [NSDate date];
    NSTimeInterval interval = arc4random_uniform(60 * 60 * 24 * 360);

    NSDate *date = [today dateByAddingTimeInterval:-interval];

    return date;
}

+ (NSDate *)dateWithTimeIntervalSince1970Number:(NSNumber *)number
{
    NSTimeInterval timeInterval = [number doubleValue];
    if (timeInterval > 140000000000) {
        timeInterval = timeInterval / 1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return date;
}

+ (NSDate *)dateWithTimeIntervalSince1970String:(NSString *)string
{
    NSTimeInterval timeInterval = [string doubleValue];
    if (timeInterval > 140000000000) {
        timeInterval = timeInterval / 1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return date;
}

+ (NSDate *)dateWithString:(NSString *)date template:(NSString *)template
{
    if (!date || !template) {
        return nil;
    }
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }

    dateFormatter.dateFormat = template;
    return [dateFormatter dateFromString:date];
}

- (NSString *)stringWithTemplate:(NSString *)template
{
    if (!template) return nil;

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    //    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //    NSString *dateString = [NSDateFormatter dateFormatFromTemplate:tmplate options:0 locale:usLocale];
    dateFormatter.dateFormat = template;
    return [dateFormatter stringFromDate:self];
}

- (BOOL)isSameDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp1 = [calendar components:CRCOMPS_DATE fromDate:self];
    NSDateComponents *comp2 = [calendar components:CRCOMPS_DATE fromDate:date];

    return comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day;
}

- (NSString *)timeIntervalSince1970String
{
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    NSString *timeString = CRString(@"%f", timeInterval);
    return timeString;
}

- (NSNumber *)timeIntervalSince1970Number   //in seconds
{
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    return @(timeInterval);
}

- (NSNumber *)timeIntervalSince1970Number13 //in milliseconds
{
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    NSTimeInterval interval = timeInterval * 1000;
    return @(interval);
}

@end

#pragma mark -
#pragma mark NSMutableDictionary
@implementation NSMutableDictionary (CRBoost)
- (void)safeSetObject:(id)obj forKey:(id<NSCopying>)key
{
    if (key && obj) {
        [self setObject:obj forKey:key];
    }
}

@end

#pragma mark -
#pragma mark NSArray
@implementation NSArray (CRBoost)
- (id)safeObjectAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.count) {
        return nil;
    } else return self[index];
}

- (BOOL)containsKeyIgnoreCase:(NSString *)key
{
    BOOL result = NO;
    for (NSString *item in self) {
        if ([item.lowercaseString isEqualToString:key.lowercaseString]) {
            result = YES;
            break;
        }
    }
    return result;
}

@end

#pragma mark -
#pragma mark NSMutableArray
@implementation NSMutableArray (CRBoost)
- (void)safeAddObject:(id)obj
{
    if (obj) {
        [self addObject:obj];
    }
}

- (void)safeRemoveObjectAtIndex:(NSInteger)index
{
    index = (NSInteger)index;
    if (index > -1 && index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

- (void)moveObjectAtIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (from == to) return;
    id obj = [self safeObjectAtIndex:from];
    if (!obj || to >= self.count) return;

    //    if (from > to) {
    [self removeObjectAtIndex:from];
    [self insertObject:obj atIndex:to];
    //    } else {
    //        [self insertObject:obj atIndex:to];
    //        [self removeObjectAtIndex:from];
    //    }
}

@end

#pragma mark -
#pragma mark NSAttributedString
#define JSON_STRING_KEY                   @"string"
#define JSON_VALUE_KEY                    @"value"
#define JSON_ATTRIBUTE_KEY                @"attribute"
#define JSON_LIGATURE_KEY                 @"ligature"
#define JSON_KERN_KEY                     @"kern"
#define JSON_EFFECT_KEY                   @"effect"
#define JSON_LINK_KEY                     @"link"
#define JSON_OFFSET_KEY                   @"offset"
#define JSON_OBLIQUENESS_KEY              @"obliqueness"
#define JSON_EXPANSION_KEY                @"expansion"
#define JSON_DIRECTION_KEY                @"direction"
#define JSON_GLYPH_KEY                    @"glyph"
#define JSON_RADIUS_KEY                   @"radius"
#define JSON_ALIGNMENT_KEY                @"alignment"
#define JSON_INDENT_FIRST_LINE_HEAD_KEY   @"firstLineHeadIndent"
#define JSON_INDENT_HEAD_KEY              @"headIndent"
#define JSON_INDENT_TAIL_KEY              @"tailIndent"
#define JSON_LINE_BREAKING_MODE_KEY       @"lineBreakingMode"
#define JSON_LINE_HEIGHT_MULTIPLE_KEY     @"lineHeightMultiple"
#define JSON_LINE_HEIGHT_MAX_KEY          @"lineHeightMax"
#define JSON_LINE_HEIGHT_MIN_KEY          @"lineHeightMin"
#define JSON_SPACING_LINE_KEY             @"lineSpacing"
#define JSON_SPACING_PARAGRAPH_KEY        @"paragraphSpacing"
#define JSON_SPACING_PARAGRAPH_BEFORE_KEY @"paragraphSpacingBefore"
#define JSON_BASE_WRITING_DIRECTION_KEY   @"baseWritingDirection"
#define JSON_HYPHENATION_FACTOR_KEY       @"hyphenationFactor"

@implementation NSAttributedString (CRBoost)
+ (instancetype)stringWithJSONString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    return [self stringWithJSON:json];
}

+ (instancetype)stringWithJSON:(id)json
{
    if (!CRJSONIsDictionary(json)) return nil;
    NSString *string = json[JSON_STRING_KEY];
    NSDictionary *dicAttribute = json[JSON_ATTRIBUTE_KEY];
    return [self stringWithString:string jsonAttribute:dicAttribute];
}

+ (instancetype)stringWithString:(NSString *)string attribute:(NSString *)attribute
{
    NSAttributedString *attributedString = nil;
    if (attribute.length > 0) {
        NSData *data = [attribute dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        attributedString =  [self stringWithString:string jsonAttribute:json];
    } else {
        attributedString = [[NSAttributedString alloc] initWithString:string];
    }

    return attributedString;
}

+ (instancetype)stringWithString:(NSString *)string jsonAttribute:(NSDictionary *)attribute
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];

    [attribute enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *attributeName = (NSString *)key;
        NSArray *arrAttribute = (NSArray *)obj;
        [arrAttribute enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dicPair = (NSDictionary *)obj; //attribute value & range

            //range
            NSString *strRange = dicPair[JSON_RANGE_KEY];
            NSRange range = NSRangeFromString(strRange);

            //value
            NSDictionary *dicValue = dicPair[JSON_VALUE_KEY];
            if (dicValue.count > 0) {
                id value = nil;

                if ([attributeName isEqualToString:NSFontAttributeName]) {
                    UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:dicValue];
                    value = [UIFont fontWithDescriptor:descriptor size:-1];
                } else if ([attributeName isEqualToString:NSParagraphStyleAttributeName]) {
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    id styleValue = nil;

                    styleValue = dicValue[JSON_LINE_HEIGHT_MULTIPLE_KEY];
                    if (styleValue) {
                        paragraphStyle.lineHeightMultiple = [styleValue floatValue];
                    }

                    styleValue = dicValue[JSON_LINE_HEIGHT_MAX_KEY];
                    if (styleValue) {
                        paragraphStyle.maximumLineHeight = [styleValue floatValue];
                    }

                    styleValue = dicValue[JSON_SPACING_PARAGRAPH_BEFORE_KEY];
                    if (styleValue) {
                        paragraphStyle.paragraphSpacingBefore = [styleValue floatValue];
                    }

                    styleValue = dicValue[JSON_HYPHENATION_FACTOR_KEY];
                    if (styleValue) {
                        paragraphStyle.hyphenationFactor = [styleValue floatValue];
                    }

                    paragraphStyle.alignment = (NSTextAlignment)[dicValue[JSON_ALIGNMENT_KEY] integerValue];
                    paragraphStyle.firstLineHeadIndent = [dicValue[JSON_INDENT_FIRST_LINE_HEAD_KEY] floatValue];
                    paragraphStyle.headIndent = [dicValue[JSON_INDENT_HEAD_KEY] floatValue];
                    paragraphStyle.tailIndent = [dicValue[JSON_INDENT_TAIL_KEY] floatValue];
                    paragraphStyle.lineBreakMode = (NSLineBreakMode)[dicValue[JSON_LINE_BREAKING_MODE_KEY] integerValue];
                    paragraphStyle.minimumLineHeight = [dicValue[JSON_LINE_HEIGHT_MIN_KEY] floatValue];
                    paragraphStyle.lineSpacing = [dicValue[JSON_SPACING_LINE_KEY] floatValue];
                    paragraphStyle.paragraphSpacing = [dicValue[JSON_SPACING_PARAGRAPH_KEY] floatValue];
                    paragraphStyle.baseWritingDirection = (NSWritingDirection)[dicValue[JSON_BASE_WRITING_DIRECTION_KEY] integerValue];

                    value = (NSParagraphStyle *)paragraphStyle;
                } else if ([attributeName isEqualToString:NSForegroundColorAttributeName]   ||
                           [attributeName isEqualToString:NSBackgroundColorAttributeName]   ||
                           [attributeName isEqualToString:NSStrokeColorAttributeName]       ||
                           [attributeName isEqualToString:NSUnderlineColorAttributeName]    ||
                           [attributeName isEqualToString:NSStrikethroughColorAttributeName]) {
                    NSString *colorString = dicValue[JSON_COLOR_KEY];
                    value = [UIColor colorWithHex:colorString];
                } else if ([attributeName isEqualToString:NSLigatureAttributeName]) {
                    value = dicValue[JSON_LIGATURE_KEY]; //value is a NSNumber
                } else if ([attributeName isEqualToString:NSKernAttributeName]) {
                    value = dicValue[JSON_KERN_KEY]; //value is a NSNumber
                } else if ([attributeName isEqualToString:NSStrikethroughStyleAttributeName]) {
                    value = dicValue[JSON_STYLE_KEY]; //NSNumber
                } else if ([attributeName isEqualToString:NSUnderlineStyleAttributeName]) {
                    value = dicValue[JSON_STYLE_KEY]; //NSNumber
                } else if ([attributeName isEqualToString:NSStrokeWidthAttributeName]) {
                    value = dicValue[JSON_WIDTH_KEY]; //value is a NSNumber
                } else if ([attributeName isEqualToString:NSShadowAttributeName]) {
                    //value is a NSShadow
                    NSShadow *shadow = [[NSShadow alloc] init];
                    id shadowValue = nil;

                    shadowValue = dicValue[JSON_OFFSET_KEY];
                    if (shadowValue) {
                        shadow.shadowOffset = CGSizeFromString(shadowValue);
                    }

                    shadowValue = dicValue[JSON_RADIUS_KEY];
                    if (shadowValue) {
                        shadow.shadowBlurRadius = [shadowValue floatValue];
                    }

                    shadowValue = dicValue[JSON_COLOR_KEY];
                    if (shadowValue) {
                        shadow.shadowColor = [UIColor colorWithHex:shadowValue];
                    }
                } else if ([attributeName isEqualToString:NSTextEffectAttributeName]) {
                    //value is an NSString
                    value = dicValue[JSON_EFFECT_KEY];
                } else if ([attributeName isEqualToString:NSAttachmentAttributeName]) {
                    //todo: value is an NSTextAttachment
                } else if ([attributeName isEqualToString:NSLinkAttributeName]) {
                    //value is a url NSString
                    value = dicValue[JSON_LINK_KEY];
                } else if ([attributeName isEqualToString:NSBaselineOffsetAttributeName]) {
                    //value is an NSNumber
                    value = dicValue[JSON_LINK_KEY];
                } else if ([attributeName isEqualToString:NSObliquenessAttributeName]) {
                    //value is an NSNumber
                    value = dicValue[JSON_OBLIQUENESS_KEY];
                } else if ([attributeName isEqualToString:NSExpansionAttributeName]) {
                    //value is an NSNumber
                    value = dicValue[JSON_EXPANSION_KEY];
                } else if ([attributeName isEqualToString:NSWritingDirectionAttributeName]) {
                    //value is an NSArray of several NSNumber
                    value = dicValue[JSON_DIRECTION_KEY];
                } else if ([attributeName isEqualToString:NSVerticalGlyphFormAttributeName]) {
                    //value is an NSNumber
                    value = dicValue[JSON_GLYPH_KEY];
                }

                if (value) {
                    [attributedString addAttribute:attributeName value:value range:range];
                }
            }
        }];
    }];

    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

- (NSString *)jsonString
{
    id json = [self dumpJSON];

    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return string;
}

- (id)dumpJSON
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];

    //string
    CRMDictionaryAdd(json, JSON_STRING_KEY, self.string);

    //attribute
    id dicAttribute = [self attributeJSON];
    CRMDictionaryAdd(json, JSON_ATTRIBUTE_KEY, dicAttribute);

    return json;
}

- (NSString *)attributes
{
    id json = [self attributeJSON];
    if (![NSJSONSerialization isValidJSONObject:json]) {
        return nil;
    }
    //NSData *data = [NSPropertyListSerialization dataFromPropertyList:json format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return string;
}

- (id)attributeJSON
{
    static NSArray *arrAttributeName = nil;
    if (!arrAttributeName) {
        arrAttributeName = @[NSFontAttributeName,               NSParagraphStyleAttributeName,
                             NSForegroundColorAttributeName,    NSBackgroundColorAttributeName,
                             NSStrokeColorAttributeName,        NSStrikethroughColorAttributeName,
                             NSUnderlineColorAttributeName,     NSLigatureAttributeName,
                             NSKernAttributeName,               NSStrikethroughStyleAttributeName,
                             NSUnderlineStyleAttributeName,     NSStrokeWidthAttributeName,
                             NSShadowAttributeName,             NSTextEffectAttributeName,
                             NSAttachmentAttributeName,         NSLinkAttributeName,
                             NSBaselineOffsetAttributeName,     NSObliquenessAttributeName,
                             NSExpansionAttributeName,          NSWritingDirectionAttributeName,
                             NSVerticalGlyphFormAttributeName];
    }
    NSMutableDictionary *dicAttribute = [NSMutableDictionary dictionary];

    NSRange wholeRange = NSMakeRange(0, self.string.length);
    for (NSString *attributeName in arrAttributeName) {
        NSMutableArray *arrValue = [NSMutableArray array];
        [self enumerateAttribute:attributeName inRange:wholeRange options:NSAttributedStringEnumerationReverse usingBlock:^(id value, NSRange range, BOOL *stop) {
            if (value) {
                //value
                NSMutableDictionary *dicValue = [NSMutableDictionary dictionary];
                if ([attributeName isEqualToString:NSFontAttributeName]) {
                //value is a UIFont
                    UIFont *font = (UIFont *)value;
                    UIFontDescriptor *descriptor = font.fontDescriptor;
                    [dicValue addEntriesFromDictionary:descriptor.fontAttributes];
                } else if ([attributeName isEqualToString:NSParagraphStyleAttributeName]) {
                //value is an NSParagraphStyle
                    if ([value isKindOfClass:[NSParagraphStyle class]]) {
                        NSParagraphStyle *paragraphStyle = (NSParagraphStyle *)value;

                        if (paragraphStyle.lineHeightMultiple != 0.0) {
                            dicValue[JSON_LINE_HEIGHT_MULTIPLE_KEY] = @(paragraphStyle.lineHeightMultiple);
                        }
                        if (paragraphStyle.maximumLineHeight != 0.0) {
                            dicValue[JSON_LINE_HEIGHT_MAX_KEY] = @(paragraphStyle.maximumLineHeight);
                        }
                        if (paragraphStyle.paragraphSpacingBefore != 0.0) {
                            dicValue[JSON_SPACING_PARAGRAPH_BEFORE_KEY] = @(paragraphStyle.paragraphSpacingBefore);
                        }
                        if (paragraphStyle.hyphenationFactor != 0.0) {
                            dicValue[JSON_HYPHENATION_FACTOR_KEY] = @(paragraphStyle.hyphenationFactor);
                        }

                        //todo: tab stops

                        dicValue[JSON_ALIGNMENT_KEY]                = @(paragraphStyle.alignment);
                        dicValue[JSON_INDENT_FIRST_LINE_HEAD_KEY]   = @(paragraphStyle.firstLineHeadIndent);
                        dicValue[JSON_INDENT_HEAD_KEY]              = @(paragraphStyle.headIndent);
                        dicValue[JSON_INDENT_TAIL_KEY]              = @(paragraphStyle.tailIndent);
                        dicValue[JSON_LINE_BREAKING_MODE_KEY]       = @(paragraphStyle.lineBreakMode);
                        dicValue[JSON_LINE_HEIGHT_MIN_KEY]          = @(paragraphStyle.minimumLineHeight);
                        dicValue[JSON_SPACING_LINE_KEY]             = @(paragraphStyle.lineSpacing);
                        dicValue[JSON_SPACING_PARAGRAPH_KEY]        = @(paragraphStyle.paragraphSpacing);
                        dicValue[JSON_BASE_WRITING_DIRECTION_KEY]   = @(paragraphStyle.baseWritingDirection);
                    }
                } else if ([attributeName isEqualToString:NSForegroundColorAttributeName]   ||
                           [attributeName isEqualToString:NSBackgroundColorAttributeName]   ||
                           [attributeName isEqualToString:NSUnderlineColorAttributeName]    ||
                           [attributeName isEqualToString:NSStrokeColorAttributeName]       ||
                           [attributeName isEqualToString:NSStrikethroughColorAttributeName]) {
                    UIColor *color = (UIColor *)value;
                    dicValue[JSON_COLOR_KEY] = color.hex;
                } else if ([attributeName isEqualToString:NSLigatureAttributeName]) {
                    dicValue[JSON_LIGATURE_KEY] = value; //NSNumber
                } else if ([attributeName isEqualToString:NSKernAttributeName]) {
                    dicValue[JSON_KERN_KEY] = value; //NSNumber
                } else if ([attributeName isEqualToString:NSStrikethroughStyleAttributeName]) {
                    dicValue[JSON_STYLE_KEY] = value; //NSNumber
                } else if ([attributeName isEqualToString:NSUnderlineStyleAttributeName]) {
                    dicValue[JSON_STYLE_KEY] = value; //NSNumber
                } else if ([attributeName isEqualToString:NSStrokeWidthAttributeName]) {
                    dicValue[JSON_WIDTH_KEY] = value; //NSNumber
                } else if ([attributeName isEqualToString:NSShadowAttributeName]) {
                    //value is an NSShadow
                    if ([value isKindOfClass:[NSShadow class]]) {
                        NSShadow *shadow = (NSShadow *)value;
                        CRMDictionaryAdd(dicValue, JSON_OFFSET_KEY, NSStringFromCGSize(shadow.shadowOffset));
                        CRMDictionaryAdd(dicValue, JSON_RADIUS_KEY, @(shadow.shadowBlurRadius));
                        if ([shadow.shadowColor isKindOfClass:[UIColor class]]) {
                            dicValue[JSON_COLOR_KEY] = [(UIColor *)shadow.shadowColor hex];
                        }
                    }
                } else if ([attributeName isEqualToString:NSTextEffectAttributeName]) {
                    //value is an NSString
                    dicValue[JSON_EFFECT_KEY] = value;
                } else if ([attributeName isEqualToString:NSAttachmentAttributeName]) {
                    //todo: value is an NSTextAttachment
                } else if ([attributeName isEqualToString:NSLinkAttributeName]) {
                    //value is an NSURL or NSString
                    if ([value isKindOfClass:[NSString class]]) {
                        dicValue[JSON_LINK_KEY] = value;
                    } else if ([value isKindOfClass:[NSURL class]]) {
                        NSString *url = [(NSURL *)value absoluteString];
                        if (url) {
                            dicValue[JSON_LINK_KEY] = url;
                        }
                    }
                } else if ([attributeName isEqualToString:NSBaselineOffsetAttributeName]) {
                    //value is an NSNumber
                    dicValue[JSON_OFFSET_KEY] = value;
                } else if ([attributeName isEqualToString:NSObliquenessAttributeName]) {
                    //value is an NSNumber
                    dicValue[JSON_OBLIQUENESS_KEY] = value;
                } else if ([attributeName isEqualToString:NSExpansionAttributeName]) {
                    //value is an NSNumber
                    dicValue[JSON_EXPANSION_KEY] = value;
                } else if ([attributeName isEqualToString:NSWritingDirectionAttributeName]) {
                    //value is an NSAray of several NSNumber
                    dicValue[JSON_DIRECTION_KEY] = value;
                } else if ([attributeName isEqualToString:NSVerticalGlyphFormAttributeName]) {
                    //value is an NSNumber
                    dicValue[JSON_GLYPH_KEY] = value;
                }

                if (dicValue.count > 0) {
                    NSMutableDictionary *dicPair = [NSMutableDictionary dictionary]; //attribute value & range

                    //value
                    dicPair[JSON_VALUE_KEY] = dicValue;
                    //range
                    dicPair[JSON_RANGE_KEY] = NSStringFromRange(range);

                    //add value&range pair to array
                    CRMArrayAdd(arrValue, dicPair);
                }
            }
        }];
        if (arrValue.count > 0) {
            CRMDictionaryAdd(dicAttribute, attributeName, arrValue);
        }
    }

    return dicAttribute;
}

- (BOOL)onlyContainsAchromaticColor
{
    BOOL result = NO;
    NSDictionary *attrsDic = self.attributeJSON;
    NSArray *colorArr = nil;
    if ([[attrsDic allKeys] containsObject:NSForegroundColorAttributeName]) {
        colorArr = [attrsDic objectForKey:NSForegroundColorAttributeName];
    } else {
        return YES;
    }

    if (colorArr.count <= 2) {
        NSDictionary *cDic = [colorArr firstObject];
        NSString *string = [[cDic valueForKey:@"value"] valueForKey:@"color"];
        if (string.length >= 7) {
            NSString *r = [string substringWithRange:NSMakeRange(1, 2)];
            NSString *g = [string substringWithRange:NSMakeRange(3, 2)];
            NSString *b = [string substringWithRange:NSMakeRange(5, 2)];

            if ([r isEqualToString:g] && [r isEqualToString:b]) {
                result = YES;
            }
        }
    }
    return result;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGRect rect =  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}

- (CGFloat)widthToFit
{
    CGSize size = [self sizeThatFits:CGSizeMake(HUGE, HUGE)];
    return size.width;
}

- (CGFloat)heightForWidth:(CGFloat)width
{
    CGSize size = [self sizeThatFits:CGSizeMake(width, HUGE)];
    return size.height;
}

@end

#pragma mark -
#pragma mark NSMutableAttributedString
/**
 *
 {
 "string": "Hello World",
 "attribute": {
 "NSFont": [
 {
 "range": "{6, 14}",
 "value": {
 "NSFontNameAttribute": "ArialMT",
 "NSFontSizeAttribute": 23
 }
 },
 {
 "range": "{2, 3}",
 "value": {
 "NSFontNameAttribute": "Helvetica",
 "NSFontSizeAttribute": 18
 }
 }
 ]
 }
 }
 */
@implementation NSMutableAttributedString (CRBoost)

@end;

#pragma mark -
#pragma mark UIImage
@implementation UIImage (CRBoost)
static char kImageTypeKey;
- (void)setType:(UIImageType)type
{
    objc_setAssociatedObject(self, &kImageTypeKey, @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageType)type
{
    NSNumber *type = objc_getAssociatedObject(self, &kImageTypeKey);
    return (UIImageType)[type integerValue];
}

- (UIImage *)scaleToSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);

    [self drawInRect:CGRectMake(0, 0, size.width, size.height)]; //draw in context

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); //new image

    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)resizeWithImageMode:(UIImageResizingMode)resizingMode
{
    if (!self) {
        return self;
    }
    CGFloat top = self.size.height / 2.0;
    CGFloat left = self.size.width / 2.0;
    CGFloat bottom = self.size.height / 2.0;
    CGFloat right = self.size.width / 2.0;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:resizingMode];
}

+ (UIImage *)imageByScalingImage:(UIImage *)image toSize:(CGSize)newSize
{
    //image.scale or [UIScreen mainScreen].scale)
    //create a graphics image context
    //used to be: UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);

    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)]; //draw in context

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext(); //new image

    UIGraphicsEndImageContext();

    return newImage;
}

+ (UIImage *)imageByColorizingImage:(UIImage *)image withColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(image.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = (CGRect) {0, 0, image.size };

    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);

    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);

    [color set];

    CGContextFillRect(context, area);
    CGContextRestoreGState(context);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextDrawImage(context, area, image.CGImage);

    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return colorizedImage;
}

+ (UIImage *)imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color
{
    //decode color
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    CGColorRef colorRef = color.CGColor;
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    const CGFloat *colors = CGColorGetComponents(colorRef);
    if (numComponents == 2) {
        red = green = blue = colors[0];
        alpha = colors[1];
    } else if (numComponents == 4) {
        red = colors[0];
        green = colors[1];
        blue = colors[2];
        alpha = colors[3];
    }

    //decode image
    CGImageRef imageRef = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(width * height * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPercomponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPercomponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, (CGRect) {0, 0, width, height }, imageRef);
    CGContextRelease(context);

    // change color
    int byteIndex = 0;
    for (int ii = 0; ii < width * height; ii++) {
        rawData[byteIndex] = (char)(red * 255);
        rawData[byteIndex + 1] = (char)(green * 255);
        rawData[byteIndex + 2] = (char)(blue * 255);
        //        if(rawData[byteIndex+3]>0) rawData[byteIndex+3] = (char)(alpha * 255);
        rawData[byteIndex + 3] = (char)(alpha * rawData[byteIndex + 3]);

        byteIndex += 4;
    }

    //create new image
    CGContextRef ctx;
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth(imageRef),
                                CGImageGetHeight(imageRef),
                                bitsPercomponent,
                                CGImageGetBytesPerRow(imageRef),
                                CGImageGetColorSpace(imageRef),
                                (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *renderedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(rawData);

    return renderedImage;
}

+ (UIImage *)imageFromView:(UIView *)view
{
    CRLog(@"about to create an image from a view");
    return [self imageFromView:view size:view.bounds.size scale:0];
}

+ (UIImage *)imageFromView:(UIView *)view size:(CGSize)size scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    //[view.layer renderInContext:UIGraphicsGetCurrentContext()];
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

    /*
     __block UIImage *image = nil;
     dispatch_sync(dispatch_get_main_queue(), ^{
     UIGraphicsBeginImageContextWithOptions(size, YES, scale);
     [view.layer renderInContext:UIGraphicsGetCurrentContext()];
     //    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];

     image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     });

     return image;*/
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CGSize)imageSizeWithURL:(NSURL *)URL
{
    NSURL *url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;

    if (imageSourceRef) {
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);

        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);

#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }

            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);

            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }

            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);

            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue (imageProperties, kCGImagePropertyOrientation)integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

@end
