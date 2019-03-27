//
//  Utility.m
//  CRBoost
//
//  Created by Eric Wu
//  Copyright (c) 2016 Cocoa. All rights reserved.
//

#import "Utility.h"
#import "CRMacros.h"
#import "CRMath.h"

@implementation Utility

#pragma mark -
#pragma mark - path
+ (NSString *)documentDirectory
{
    NSArray<NSString *> *arrDocument = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [arrDocument lastObject];
}

+ (NSString *)libraryDirectory
{
    NSArray<NSString *> *arrLibrary = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [arrLibrary lastObject];
}

+ (NSString *)cachesDirectory
{
    NSArray<NSString *> *arrCaches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [arrCaches lastObject];
}

+ (NSString *)tempDirectory
{
    NSString *tempPath = NSTemporaryDirectory();
    [self ensureExistsOfDirectory:tempPath];
    return tempPath;
}

+ (BOOL)ensureExistsOfDirectory:(NSString *)dirPath
{
    BOOL isDir;
    if (![CRFileMgr fileExistsAtPath:dirPath isDirectory:&isDir] || !isDir)
    {
        BOOL succeed = [CRFileMgr createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        return succeed;
    }
    return YES;
}

+ (BOOL)ensureExistsOfFile:(NSString *)path
{
    BOOL isDir;
    if ([CRFileMgr fileExistsAtPath:path isDirectory:&isDir] && !isDir)
    {
        return YES;
    }
    NSString *dir = path.stringByDeletingLastPathComponent;
    [self ensureExistsOfDirectory:dir];
    BOOL ret = [CRFileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return ret;
}

+ (NSString *)bundlePath
{
    return [NSBundle mainBundle].resourcePath;
}

+ (NSString *)pathOfBundleFile:(NSString *)path
{
    return [[self bundlePath] stringByAppendingPathComponent:path];
}

#pragma mark -
#pragma mark - gcd
+ (void)performeBackgroundTask:(void (^)(void))backgroundBlock beforeMainTask:(void (^)(void))mainBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (backgroundBlock)
        {
            backgroundBlock();
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (mainBlock)
            {
                mainBlock();
            }
        });
    });
}

#pragma mark -
#pragma mark - view
+ (void)presentView:(UIView *)view animated:(BOOL)animated
{
    UIViewController *root = CRRootViewController();
    if (animated)
    {
        view.alpha = 0;
        [root.view addSubview:view];
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            view.alpha = 1;
        } completion:nil];
    }
    else
    {
        [root.view addSubview:view];
    }
}

#pragma mark -
#pragma mark - interaction
+ (void)lockUserInteraction
{
    [CRMainWindow() setUserInteractionEnabled:NO];
}

+ (void)unlockUserInteraction
{
    [CRMainWindow() setUserInteractionEnabled:YES];
}

+ (void)lockUserInteractionWithDuration:(NSTimeInterval)duration
{
    [self lockUserInteraction];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self unlockUserInteraction];
    });
}

#pragma mark -
#pragma mark - animation

#pragma mark -
#pragma mark - system

#pragma mark -
#pragma mark - device

#pragma mark -
#pragma mark - storyboard

//+ (id)controllerWithIdentifier:(NSString *)identifier
//{
//    return [self controllerInStoryboard:kStoryboardMain withIdentifier:identifier];
//}

+ (id)controllerInStoryboard:(NSString *)storyboard withIdentifier:(NSString *)identifier
{
    return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

#pragma mark -
#pragma mark - nib
+ (id)controllerWithNib:(NSString *)nib
{
    Class aController = NSClassFromString(nib);
    if (![aController isSubclassOfClass:[UIViewController class]])
    {
        return nil;
    }
    else
    {
        return [[aController alloc] initWithNibName:nib bundle:nil];
    }
}

#pragma mark -
#pragma mark - navigation
+ (void)goStringUrl:(NSString *)str
{
    if (str)
    {
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:str];
        [self goURL:url];
    }
}

+ (void)goURL:(NSURL *)url
{
    if ([CRSharedApp canOpenURL:url])
    {
        if (@available(iOS 10.0, *)) {
            [CRSharedApp openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            [CRSharedApp openURL:url];
        }
    }
}

#pragma mark -
#pragma mark activity

@end
