//
//  CRAppDelegate.m
//  CRBoost
//
//  Created by Eric Wu on 08/15/2018.
//  Copyright (c) 2018 Eric Wu. All rights reserved.
//

#import "CRAppDelegate.h"
#import <JPush/JPUSHService.h>
@import UserNotifications;

#define kJPushAppKey                                  @"fb3c39cc1f8ee7d2a9e7ce1a"


@interface CRAppDelegate()< JPUSHRegisterDelegate >

@end

@implementation CRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self registerJPush:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark- jpush
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"JPUSH registrationID :%@", JPUSHService.registrationID);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);

}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
}

- (void)registerJPush:(NSDictionary *)launchOptions {
    // 极光推送
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [JPUSHService setBadge:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Required
    BOOL isProduction = YES;
#if DEBUG
    [JPUSHService setDebugMode];
    isProduction = NO;
#endif
//    [JPUSHService setAlias:@"iM" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"JPUSH Alias :%@ %@", iAlias, iResCode == 0 ? @"succeed" : @"failed");
//    } seq:1];
    [JPUSHService setTags:[NSSet setWithArray:@[@"TEST"]] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSLog(@"JPUSH Tags :%@ %@", iTags, iResCode == 0 ? @"succeed" : @"failed");

    } seq:1];
    [JPUSHService setupWithOption:launchOptions
                           appKey:kJPushAppKey
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler(); // 系统要求执行这个方法
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    } else {
        //从通知设置界面进入应用
    }
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置

}

@end
