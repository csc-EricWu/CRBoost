//
//  CRKeyboardUtility.h
//
//  Created by Eric Wu 15/13/13.
//  Copyright (c) 2013 Cocoa. All rights reserved.
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
