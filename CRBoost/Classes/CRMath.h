//
//  CRMath.h
//  TaxiNow
//
//  Created by Eric Wu
//  Copyright © 2016年 Cocoa. All rights reserved.
//

#ifndef CRMath_h
#define CRMath_h

#import <AVFoundation/AVFoundation.h>
#import "NSFoundation+CRBoost.h"
#import "CRMacros.h"

#pragma mark -
#pragma mark angle
//==================angle==================
#define CRRadian2degrees(radian)        ((radian) * 180.0 / M_PI)
#define CRDegrees2radian(degree)        (M_PI * (degree) / 180.0)
#define CRRadianOfTransform(transform)  atan2f(transform.b, transform.a)
#define CRHorizontalLength(p1, p2)      ABS(p1.x - p2.x)
#define CRVerticalLength(p1, p2)        ABS(p1.y - p2.y)
#define CRCenterX(p1, p2)               (p1.x + p2.x)/2
#define CRCenterY(p1, p2)               (p1.y + p2.y)/2


#define CREven(num)    (((int)(num) & 0x01) ? ((int)(num)-1) : (int)(num))
#define CREven_2(num)  (CREven(num) / 2)

typedef void (^AlertAction)(UIAlertAction *action);

CG_INLINE CGFloat //in radians
CRArcAngle(CGPoint start, CGPoint end) {
    CGPoint originPoint = CGPointMake(end.x - start.x, start.y - end.y);
    float radians = atan2f(originPoint.y, originPoint.x);
    
    radians = radians < 0.0 ? (M_PI*2 + radians) : radians;
    
    NSLog(@"arc radians is %f", radians);
    
    return M_PI*2 - radians;
}

CG_INLINE CGFloat
CRDistanceCompare(CGPoint start, CGPoint end) {
    float originX = end.x - start.x;
    float originY = end.y - start.y;
    
    return (originX*originX + originY*originY);
}

CG_INLINE CGFloat
CRDistance(CGPoint start, CGPoint end) {
    return sqrt(CRDistanceCompare(start, end));
}

CG_INLINE CGPoint
CRCenterPoint(CGPoint start, CGPoint end) {
    return CGPointMake((end.x + start.x)/2, (end.y + start.y)/2);
}




#pragma mark -
#pragma mark graphics
//==================point==================
CG_INLINE CGPoint
CRPointPlus(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CG_INLINE CGPoint
CRPointOffset(CGPoint p1, CGFloat x, CGFloat y) {
    return CGPointMake(p1.x + x, p1.y + y);
}

CG_INLINE CGPoint
CRPointSubtract(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}

CG_INLINE CGPoint
CRPointSacle(CGPoint point, CGFloat factor) {
    return CGPointMake(point.x * factor, point.y * factor);
}

CG_INLINE CGPoint
CRFrameCenter(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width/2,
                       rect.origin.y + rect.size.height/2);
}

CG_INLINE CGPoint
CRBoundCenter(CGRect rect) {
    return CGPointMake(rect.size.width/2, rect.size.height/2);
}

CG_INLINE CGPoint
CRLocationInRect(CGRect rect, CGPoint location) {
    return CGPointMake(location.x-rect.origin.x, location.y-rect.origin.y);
}

CG_INLINE CGPoint
CRLocationRatio(CGRect bounds, CGPoint location) {
    location = CRLocationInRect(bounds, location);
    
    return CGPointMake(location.x/bounds.size.width, location.y/bounds.size.height);
}


CG_INLINE CGPoint
CRSize2Point(CGSize size) {
    return CGPointMake(size.width, size.height);
}


//==================rect==================
CG_INLINE CGRect
CRCenteredFrame(CGRect frame, CGPoint center) {
    frame.origin = CGPointMake(center.x-frame.size.width/2,
                               center.y-frame.size.height/2);
    return frame;
}

CG_INLINE CGRect
CRRectAddedHeight(CGRect rect, CGFloat height) {
    return (CGRect){rect.origin, {rect.size.width, rect.size.height + height}};
}

CG_INLINE CGRect
CRRectUpdatedHeight(CGRect rect, CGFloat height) {
    return (CGRect){rect.origin, {rect.size.width, height}};
}

CG_INLINE CGPoint //frame within bounds
CRAdjustedFrameCenter(CGRect frame, CGPoint center, CGRect bounds) {
    CGFloat boundWidth = bounds.size.width;
    CGFloat boundHeight = bounds.size.height;
    
    CGFloat finalX = center.x;
    CGFloat finalY = center.y;
    CGFloat width = frame.size.width / 2.0;
    CGFloat height = frame.size.height / 2.0;
    
    if (finalX < width)  {
        finalX = width;
    } else if (finalX+width > boundWidth ) {
        finalX = boundWidth - width;
    }
    
    if (finalY < height) {
        finalY = height;
    } else if (finalY+height > boundHeight ) {
        finalY = boundHeight - height;
    }
    return CGPointMake(finalX, finalY);
}

CG_INLINE CGRect
CRAdjustedFrameInBounds(CGRect frame, CGRect bounds) {
    CGFloat boundWidth = bounds.size.width;
    CGFloat boundHeight = bounds.size.height;
    
    CGFloat finalX = frame.origin.x;
    CGFloat finalY = frame.origin.y;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    if (finalX < 0)  {
        finalX = 0;
    } else if (finalX+width > boundWidth ) {
        finalX = boundWidth - width;
    }
    
    if (finalY < 0) {
        finalY = 0;
    } else if (finalY+height > boundHeight ) {
        finalY = boundHeight - height;
    }
    
    frame.origin.x = finalX;
    frame.origin.y = finalY;
    return frame;
}


//=====================area==========================
CG_INLINE CGFloat
CRSizeArea(CGSize size) {
    return size.width * size.height;
}

CG_INLINE CGFloat //the area size
CRFrameArea(CGRect frame) {
    return CRSizeArea(frame.size);
}



//==================size: a new one==================
CG_INLINE CGSize
CRSizeEnlarged(CGSize size, CGFloat width, CGFloat height) {
    return CGSizeMake(size.width + width, size.height + height);
}

CG_INLINE CGSize
CRSizeZoomed(CGSize size, CGFloat factor) {
    return CGSizeMake(size.width*factor, size.height*factor);
}

CG_INLINE CGSize
CRSizeAddedWidth(CGSize size, CGFloat width) {
    return CRSizeEnlarged(size, width, 0);
}

CG_INLINE CGSize
CRSizeAddedHeight(CGSize size, CGFloat height) {
    return CRSizeEnlarged(size, 0, height);
}

CG_INLINE CGSize
CRSizeUpdatedWidth(CGSize size, CGFloat width) { //a new size
    return CGSizeMake(width, size.height);
}

CG_INLINE CGSize
CRSizeUpdatedHeight(CGSize size, CGFloat height) { //a new size
    return CGSizeMake(size.width, height);
}

CG_INLINE BOOL
CRSizeLarger(CGSize s1, CGSize s2) { //not a good algorithm
    return s1.width>s2.width && s1.height>s2.height;
}

CG_INLINE BOOL
CRSizeIsEmpty(CGSize size) {
    return size.width==0 || size.height==0;
}


#pragma mark -
#pragma mark device
CG_INLINE CGRect
CRScreenBounds(BOOL landscape) {
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (landscape && rect.size.width<rect.size.height) {
        CGFloat height = rect.size.height;
        rect.size.height = rect.size.width;
        rect.size.width = height;
    }
    
    return rect;
}

CG_INLINE BOOL
CRScreenIsLandscape() {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    //UIDeviceOrientationIsLandscape(CRCurrentDevice.orientation);
}

CG_INLINE CGSize
CRScreenSize() {
    CGRect rect = CRScreenBounds(CRScreenIsLandscape());
    return rect.size;
}

CG_INLINE CGRect
CRScreenRect() {
    return CRScreenBounds(CRScreenIsLandscape());
}


CG_INLINE UIWindow *
CRMainWindow(void) {
    static UIWindow *mainWindow = nil;
    
    if (!mainWindow) {
        mainWindow = [[[UIApplication sharedApplication] delegate] window];
    }
    
    if (!mainWindow) {
        NSArray *arrWindow = [[UIApplication sharedApplication] windows];
        
        if(arrWindow.count>0) mainWindow = arrWindow[0];
    }
    
    return mainWindow;
}

CG_INLINE UIViewController *
CRRootViewController(void) {
    return [CRMainWindow() rootViewController];
}

CG_INLINE UIView *
CRRootView(void) {
    return [[CRMainWindow() rootViewController] view];
}

CG_INLINE UINavigationController *
CRRootNaviation(void) {
    return (UINavigationController *)CRRootViewController();
}

CG_INLINE CGFloat
CRNaviationHeight(void)
{
    if (IS_IPHONEX)
    {
        return 44 + 44;
    }
    else
    {
        return 64;
    }
//    if (@available(iOS 11.0, *))
//    {
//        return (CRSharedApp.keyWindow.safeAreaInsets.top + 44);
//    }
//    else
//    {
//        return 64;
//    }
}

CG_INLINE void
CRPopToViewController(__kindof Class controller)
{
    if (CRKindClass(controller, UIViewController))
    {
        UINavigationController *navigation = ((UIViewController *)controller).navigationController;
        [navigation.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:controller])
            {
                [CRRootNaviation() popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
    }
}



CG_INLINE UIViewController *
CRRecursionTopViewController(UIViewController *controller)
{
    if (controller.presentedViewController)
    {
        return CRRecursionTopViewController(controller.presentedViewController);
    }
    else if ([controller isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarCtrl = (UITabBarController *)controller;
        return CRRecursionTopViewController(tabBarCtrl.selectedViewController);
    }
    else if ([controller isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationCtrl = (UINavigationController *)controller;
        return CRRecursionTopViewController(navigationCtrl.visibleViewController);
    }
    else
    {
        for (UIViewController *childVc in controller.childViewControllers)
        {
            if (childVc && childVc.view.window)
            {
                controller = CRRecursionTopViewController(childVc);
                break;
            }
        }
        return controller;
    }
}

CG_INLINE UIViewController *
CRTopViewController(void)
{
    UIWindow *mainAppWindow = CRMainWindow();
    UIViewController *topController = CRRecursionTopViewController(mainAppWindow.rootViewController);
    return topController;
}

CG_INLINE BOOL
CRKeyboardHide(void) {
    UIWindow *window = CRMainWindow();
    return [window endEditing:YES];
}


CG_INLINE CGFloat
CRSystemVolume(void) {
    return [[AVAudioSession sharedInstance] outputVolume];
}

CG_INLINE BOOL
CRIsRetina(void) {
    if ((CRMainScreen.scale==2.0) && [CRMainScreen respondsToSelector:@selector(displayLinkWithTarget:selector:)]) {
        return YES;
    } else return NO;
}

CG_INLINE UIInterfaceOrientation
CRDeviceOrientation(void) {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsValidInterfaceOrientation(orientation)) {
        return (UIInterfaceOrientation)orientation;
    }
    
    //    UIWindow *window = CRMainWindow();
    //    window.rootViewController.interfaceOrientation;
    
    return [UIApplication sharedApplication].statusBarOrientation;
}


#pragma mark -
#pragma mark file
CG_INLINE NSNumber *
CRFileSize(NSString *path) {
    //    NSFileManager *fileMgr = [NSFileManager new]; //thread safe
    NSDictionary *attributes = [CRFileMgr attributesOfItemAtPath:path error:nil];
    if(attributes) return attributes[NSFileSize];
    else return nil;
}

CG_INLINE NSDate *
CRFileModifyDate(NSString *path) {
    NSDictionary *attributes = [CRFileMgr attributesOfItemAtPath:path error:nil];
    if(attributes) return [attributes fileModificationDate];
    else return nil;
}


CG_INLINE NSString *
CRBundlePath(NSString *fileName) {
    return [[CRBundle resourcePath] stringByAppendingPathComponent:fileName];
}

CG_INLINE BOOL
CRFileExistsAtPath(NSString *path) {
    return [CRFileMgr fileExistsAtPath:path];
}


#pragma mark -
#pragma mark url
CG_INLINE NSURL *
CRURL(NSString *url) {
    return [NSURL URLWithString: url];
}


#pragma mark -
#pragma mark UI
CG_INLINE void
CRPresentView(UIView *view, BOOL animated) {
    UIViewController *root = CRMainWindow().rootViewController;
    if (animated) {
        view.alpha = 0.0;
        
        [root.view addSubview:view];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{view.alpha = 1.0;} completion:nil];
    } else {
        [root.view addSubview:view];
    }
}

CG_INLINE UIAlertController *
CRPresentAlert(NSString *title, NSString *msg, AlertAction handler, NSString *canel, NSString *action, ...) {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (canel)
    {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:canel style:UIAlertActionStyleCancel handler:handler];
        [alertCtrl addAction:alertAction];
    }
    va_list args;
    va_start(args, action);

    if (action)
    {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:action style:UIAlertActionStyleDefault handler:handler];
        [alertCtrl addAction:alertAction];
        NSString *eachObject;
        while ((eachObject = va_arg(args, NSString *)))
        {
            alertAction = [UIAlertAction actionWithTitle:eachObject style:UIAlertActionStyleDefault handler:handler];
            [alertCtrl addAction:alertAction];
        }
    }
    va_end(args);
    [CRTopViewController() presentViewController:alertCtrl animated:YES completion:nil];
    return alertCtrl;
}

CG_INLINE void
CRPresentAlert2(NSString *title, NSString *msg) {
    CRPresentAlert(title, msg, nil, NSLocalizedString(@"OK", nil), nil);
}


CG_INLINE id
CRControllerFromNib(NSString *nib) { //required that the nib name is the same with the controller name
    Class aController = NSClassFromString(nib);
    if (![aController isSubclassOfClass:[UIViewController class]]) {
        return nil;
    }
    
    return [[aController alloc] initWithNibName:nib bundle:nil];
}
#define CRControllerWithNib(cla) CRControllerFromNib(NSStringFromClass(CRClass(cla)))


CG_INLINE id
CRControllerWithStoryboard(NSString *storyboard, NSString *identifier) {
    return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}


#pragma mark -
#pragma mark foundation
//Bitwise
CG_INLINE BOOL
CRBitwiseHas(NSUInteger base, NSUInteger bit)
{
    return (base & bit) == (bit);
}

//UUID
CG_INLINE NSString *
CRUUIDString()
{
    return [[NSUUID UUID] UUIDString];
}


//NSDate
CG_INLINE NSDate *
CRNow() {
    return [NSDate date];
}


//NSArray
CG_INLINE NSMutableArray *
CRMArrayNull(NSInteger num) {
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i < num; i++) {
        [array addObject:CRNull];
    }
    return array;
}

CG_INLINE id
CRArrayObject(NSArray *array, NSInteger idx) {
    return [array safeObjectAtIndex:idx];
}

CG_INLINE void
CRMArrayAdd(NSMutableArray *array, id obj) {
    [array safeAddObject:obj];
}

CG_INLINE void
CRMArrayRemove(NSMutableArray *array, NSUInteger idx) {
    [array safeRemoveObjectAtIndex:idx];
}


//NSSet
CG_INLINE void
CRMSetAdd(NSMutableSet *set, id obj) {
    if(!obj) return;
    
    [set addObject: obj];
}



//NSMutableDictionary
CG_INLINE NSMutableDictionary *
CRMDictionaryA(NSArray *key, NSArray *value) {
    if(!key || !value || key.count!=value.count) return nil;
    
    return [NSMutableDictionary dictionaryWithObjects:value forKeys:key];
}

CG_INLINE NSMutableDictionary *
CRMDictionaryD(NSDictionary *dic) {
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}

CG_INLINE NSMutableDictionary *
CRMDictionary(id<NSCopying> key, id obj) {
    if (!key || !obj) {
        return nil;
    }
    return [NSMutableDictionary dictionaryWithObject:obj forKey:key];
}

CG_INLINE void
CRMDictionaryAdd(NSMutableDictionary *dic, id<NSCopying> key, id obj) {
    [dic safeSetObject:obj forKey:key];
}




#pragma mark -
#pragma mark timer
CG_INLINE void
CRStopTimer(__strong NSTimer **tmr) {
    NSTimer *timer = *tmr;
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
    *tmr = nil;
}





#pragma mark -
#pragma mark GCD
CG_INLINE void
CRRunOnMainThread(CRVoidBlock task) {
    if (task) {
        if ([NSThread isMainThread]) {
            task();
        } else {
            dispatch_async(dispatch_get_main_queue(), task);
        }
    }
}




#pragma mark -
#pragma mark json
CG_INLINE id
CRJSONFromPath(NSString *path) {
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    if(!jsonData) return nil;
    
    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];
    if (json && jsonError == nil) {
        return json;
    }
    return nil;
}
CG_INLINE id
CRJSONFromString(NSString *string)
{
    if (!CRKindClass(string, NSString))
    {
        return string;
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData)
        return nil;

    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];
    if (json && jsonError == nil)
    {
        return json;
    }
    return nil;
}

CG_INLINE NSNumber *
CRCurrentTimestamp()
{
    return @((long)[[CRNow() timeIntervalSince1970Number13] integerValue]);
}

CG_INLINE BOOL
CRJSONIsArray(id json) {
    return [json isKindOfClass:[NSArray class]];
}

CG_INLINE BOOL
CRJSONIsDictionary(id json) {
    return [json isKindOfClass:[NSDictionary class]];
}

CG_INLINE id
CRJSONFromQuery(NSString *query) {
    NSArray *tokens = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    [tokens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *token = obj;
        NSArray *keyValue = [token componentsSeparatedByString:@"="];
        if (keyValue.count == 2) {
            json[keyValue[0]] = keyValue[1];
        }
    }];
    
    return json.count>0 ? json : nil;
}

CG_INLINE NSString *
CRQueryFromJSON(NSDictionary *json)
{
    if (json.count > 0)
    {
        NSMutableArray *queryList = [NSMutableArray array];
        [json enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *query = CRString(@"%@=%@", key, obj);
            [queryList addObject:query];
        }];

        return [queryList componentsJoinedByString:@"&"];
    }

    return nil;
}

CG_INLINE void
CRCallWithPhoneNumber(NSString *phone)
{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", phone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [CRRootView() addSubview:callWebview];
}

CG_INLINE NSString *
CRJSONString(id obj)
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (json) {
        json = [json stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }
    if (error)
    {

    }
    return json;
}

CG_INLINE BOOL
CRIsMatch(NSString *pattern, NSString *text)
{
    if (text.length == 0)
    {
        return NO;
    }
    if (pattern.length == 0)
    {
        return YES;
    }
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
    if (result)
    {
        return YES;
    }
    return NO;
}

CG_INLINE NSArray<NSTextCheckingResult *> *
CRMatches(NSString *pattern, NSString *text)
{
    
    if (text.length == 0)
    {
        return nil;
    }
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *results=[regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    return results;
}
CG_INLINE NSTextCheckingResult *
CRMatch(NSString *pattern, NSString *text)
{
    
    if (text.length == 0)
    {
        return nil;
    }
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
    return result;
}

CG_INLINE BOOL
CRIsEmail(NSString *text)
{
    NSString *pattern = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    return CRIsMatch(pattern, text);
}

/**
 * 判断字符串是否符合手机号码格式
 * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
 * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
 * 电信号段: 133,149,153,170,173,177,180,181,189
 * @param text 待检测的字符串
 * @return 待检测的字符串
 */
CG_INLINE BOOL
CRIsPhoneNumber(NSString *text)
{
    NSString *pattern = @"^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\\d{8}$";
    return CRIsMatch(pattern, text);
}

CG_INLINE BOOL
CRIsInteger(NSString *text)
{
    NSString *pattern = @"^\\d+$";
    return CRIsMatch(pattern, text);
}

CG_INLINE BOOL
CRIsURL(NSString *text)
{
    //(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]
    NSString *pattern = @"(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]";
    return CRIsMatch(pattern, text);
}




CG_INLINE BOOL
CRIsNullOrEmpty(NSString *text)
{
    if ([text isKindOfClass:[NSNull class]] || text == nil)
    {
        return YES;
    }
    else
    {
        if ([text isKindOfClass:[NSString class]])
        {
            return text.length == 0 || [text isEqualToString:@"(null)"] || [text isEqualToString:@"<null>"];
        }
    }
    return NO;
}

#endif
