//
//  CRKeyboardUtility.h
//
//  Created by Eric Wu
//  Copyright (c) 2016 Cocoa. All rights reserved.
//



@interface CRKeyboardUtility : NSObject

+ (BOOL)startObserving;

+ (BOOL)isKeyboardVisible;
+ (BOOL)willKeyboardBeVisible;

+ (BOOL)willKeyboardBeHidden;
+ (BOOL)isKeyboardHidden;

+ (CGRect)keyboardFrameBegin;
+ (CGRect)keyboardFrameEnd;

@end
