//
//  AppDelegate.m
//  WawaSDKDemo
//

#import "AppDelegate.h"
#import <WawaSDK/WawaSDK.h>
#import "WwHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 普通接入方
    
    
    
    [[WawaSDK WawaSDKInstance] registerApp:@"2017111515302844" appKey:@"1c8e5f1c06d09d431ec59dca8c7abe18" complete:^(BOOL success, int code, NSString * _Nullable message) {
        if (success == NO) {
            NSLog(@"游戏服务正在准备中,请稍后尝试");
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSDKNotifyKey object:nil];
        }
    }];
    
    // 阿里云接入方
//    [[WawaSDK WawaSDKInstance] registerApp:@"2017112317115128" appKey:@"8d9749e5e77a6ba814a4e36ba6e5ef7c" complete:^(BOOL success, int code, NSString * _Nullable message) {
//        if (success == NO) {
//            NSLog(@"游戏服务正在准备中,请稍后尝试");
//        }
//        else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kSDKNotifyKey object:nil];
//        }
//    }];
    
    [WwUserInfoManager UserInfoMgrInstance].userInfo = ^UserInfo *{
        UserInfo * user = [UserInfo new];
        user.uid = @"123456789";  // 接入方用户ID
        user.name = @"嘿嘿嘿";  // 接入方用户昵称
        user.avatar = @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=444225515,3056104404&fm=27&gp=0.jpg";  // 接入方
        return user;
    };
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
