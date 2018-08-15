//
//  Utility.h
//  Object-C.Demo
//
//  Created by Eric Wu on 16/1/7.
//  Copyright © 2016年 bmkp. All rights reserved.
//



@interface Utility : NSObject
// directory
+ (NSString *)documentDirectory;
+ (NSString *)libraryDirectory;
+ (NSString *)cachesDirectory;
+ (NSString *)tempDirectory;
+ (BOOL)ensureExistsOfDirectory:(NSString *)dirPath;
+ (BOOL)ensureExistsOfFile:(NSString *)path;

//path
+ (NSString *)pathOfBundleFile:(NSString *)path;

//GCD
+ (void)performeBackgroundTask:(void (^)(void))backgroundBlock beforeMainTask:(void (^)(void))mainBlock;

//View
+ (void)presentView:(UIView *)view animated:(BOOL)animated;

//interaction
+ (void)lockUserInteraction;
+ (void)unlockUserInteraction;
+ (void)lockUserInteractionWithDuration:(NSTimeInterval)duration;

// animation

// system

// device

// story board
//+ (id)controllerWithIdentifier:(NSString *)identifier;
+ (id)controllerInStoryboard:(NSString *)storyboard withIdentifier:(NSString *)identifier;

+ (id)controllerWithNib:(NSString *)nib;
+ (void)goStringUrl:(NSString *)str;

+ (void)goURL:(NSURL *)url;
@end
