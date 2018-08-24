//
//  CRKeyboardUtility.m
//
//  Created by Eric Wu
//  Copyright (c) 2016 Cocoa. All rights reserved.
//

#import "CRKeyboardUtility.h"
#import "CRMacros.h"



#pragma mark -
#pragma mark Keyboard manager
@interface CRKeyboardManager : NSObject

@property (nonatomic, readonly) BOOL keyboardIsVisible; //something is editing
@property (nonatomic, readonly) BOOL keyboardWillBeVisible;
@property (nonatomic, readonly) BOOL keyboardIsHidden;
@property (nonatomic, readonly) BOOL keyboardWillBeHidden; //currently shown, but will soon be hidden


@property (nonatomic, readonly) CGRect keyboardFrameBegin;
@property (nonatomic, readonly) CGRect keyboardFrameEnd;
@property (nonatomic, assign) BOOL bVisible;
+ (id)sharedManager;

@end



@implementation CRKeyboardManager
CRManager(CRKeyboardManager);

- (id)init {
    if (self=[super init]) {
        CRRegisterNotification(@selector(onNotifiedKeyboardWillShow:), UIKeyboardWillShowNotification);
        CRRegisterNotification(@selector(onNotifiedKeyboardDidShow:), UIKeyboardDidShowNotification);
        CRRegisterNotification(@selector(onNotifiedKeyboardWillHide:), UIKeyboardWillHideNotification);
        CRRegisterNotification(@selector(onNotifiedKeyboardDidHide:), UIKeyboardDidHideNotification);
        CRRegisterNotification(@selector(onNotifiedKeyboardWillChangeFrame:), UIKeyboardWillChangeFrameNotification);
        CRRegisterNotification(@selector(onNotifiedKeyboardDidChangeFrame:), UIKeyboardDidChangeFrameNotification);
    }
    
    return self;
}

- (void)onNotifiedKeyboardWillShow:(NSNotification *)notification {
    _keyboardIsVisible = NO;
    _keyboardWillBeVisible = YES;
    
    _keyboardIsHidden = YES;
    _keyboardWillBeHidden = NO;
    
    [self refresh:notification.userInfo];
}

- (void)onNotifiedKeyboardDidShow:(NSNotification *)notification {
    _keyboardIsVisible = YES;
    _keyboardWillBeVisible = YES;
    
    _keyboardIsHidden = NO;
    _keyboardWillBeHidden = NO;
    
    [self refresh:notification.userInfo];
}

- (void)onNotifiedKeyboardWillHide:(NSNotification *)notification {
    _keyboardIsVisible = YES;
    _keyboardWillBeVisible = NO;
    
    _keyboardIsHidden = NO;
    _keyboardWillBeHidden = YES;
    
    [self refresh:notification.userInfo];
}

- (void)onNotifiedKeyboardDidHide:(NSNotification *)notification {
    _keyboardIsVisible = NO;
    _keyboardWillBeVisible = NO;
    
    _keyboardIsHidden = YES;
    _keyboardWillBeHidden = YES;
    
    [self refresh:notification.userInfo];
}

- (void)onNotifiedKeyboardWillChangeFrame:(NSNotification *)notification {
    [self refresh:notification.userInfo];
}

- (void)onNotifiedKeyboardDidChangeFrame:(NSNotification *)notification {
    [self refresh:notification.userInfo];
}

- (void)refresh:(NSDictionary *)info {
    _keyboardFrameBegin = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    _keyboardFrameEnd = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

@end




#pragma mark -
#pragma mark Keyboard Utility

static CRKeyboardManager *keyboardMgr;
@implementation CRKeyboardUtility
+ (BOOL)startObserving {
    keyboardMgr = [CRKeyboardManager sharedManager];
    
    return YES;
}

+ (BOOL)isKeyboardVisible {
    return keyboardMgr.keyboardIsVisible;
}

+ (BOOL)willKeyboardBeVisible {
    return keyboardMgr.keyboardWillBeVisible;
}

+ (BOOL)willKeyboardBeHidden {
    return keyboardMgr.keyboardWillBeHidden;
}

+ (BOOL)isKeyboardHidden {
    return keyboardMgr.keyboardIsHidden;
}

+ (CGRect)keyboardFrameBegin {
    CRKeyboardManager *keyboardMgr = [CRKeyboardManager sharedManager];
    return keyboardMgr.keyboardFrameBegin;
}

+ (CGRect)keyboardFrameEnd {
    CRKeyboardManager *keyboardMgr = [CRKeyboardManager sharedManager];
    return keyboardMgr.keyboardFrameEnd;
}

@end
