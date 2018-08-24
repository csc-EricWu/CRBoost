//
//  Utility.h
//  CRBoost
//
//  Created by Eric Wu
//  Copyright (c) 2016 Cocoa. All rights reserved.
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
