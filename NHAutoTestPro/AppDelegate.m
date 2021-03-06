//
//  AppDelegate.m
//  NHAutoTestPro
//
//  Created by hu jiaju on 16/5/10.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NHADApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIImage *bgImg = [UIImage imageNamed:@"ad_bg.png"];
    UIImage *adImg = [UIImage imageNamed:@"ad.png"];
    NHADLocation info = {.type = NHADTypeUp, .scale = 0.75};
    [NHADApi showIn:bgImg withAd:adImg withInfo:info withEvent:^{
        NSLog(@"ad touched !");
    }];
    
    CGRect mainSize = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:mainSize];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *vcr = [[ViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vcr];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    listenMainThreadIdleState();
    [self listenMainRunloopIdle];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

static void listenMainThreadIdleState() {
    id handler = ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                // About to enter the processing loop. Happens
                // once per `CFRunLoopRun` or `CFRunLoopRunInMode` call
                break;
            case kCFRunLoopBeforeTimers:
            case kCFRunLoopBeforeSources:
                // Happens before timers or sources are about to be handled
                break;
            case kCFRunLoopBeforeWaiting:
                // All timers and sources are handled and loop is about to go
                // to sleep. This is most likely what you are looking for :)
                NSLog(@"main runloop about to sleep");
                break;
            case kCFRunLoopAfterWaiting:
                // About to process a timer or source
                NSLog(@"main runloop about to process");
                break;
            case kCFRunLoopExit:
                // The `CFRunLoopRun` or `CFRunLoopRunInMode` call is about to
                // return
                NSLog(@"main runloop about to exit");
                break;
                
            default:
                break;
        }
    };
    CFRunLoopObserverRef obs = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, handler);
    CFRunLoopAddObserver([NSRunLoop mainRunLoop].getCFRunLoop, obs, kCFRunLoopCommonModes);
    CFRelease(obs);
}

- (void)listenMainRunloopIdle {
    
    id handler = ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                // About to enter the processing loop. Happens
                // once per `CFRunLoopRun` or `CFRunLoopRunInMode` call
                break;
            case kCFRunLoopBeforeTimers:
            case kCFRunLoopBeforeSources:
                // Happens before timers or sources are about to be handled
                break;
            case kCFRunLoopBeforeWaiting:
                // All timers and sources are handled and loop is about to go
                // to sleep. This is most likely what you are looking for :)
                NSLog(@"main runloop about to sleep");
                break;
            case kCFRunLoopAfterWaiting:
                // About to process a timer or source
                NSLog(@"main runloop about to process");
                break;
            case kCFRunLoopExit:
                // The `CFRunLoopRun` or `CFRunLoopRunInMode` call is about to
                // return
                NSLog(@"main runloop about to exit");
                break;
                
            default:
                break;
        }
    };
    CFRunLoopObserverRef obs = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, handler);
    CFRunLoopAddObserver([NSRunLoop mainRunLoop].getCFRunLoop, obs, kCFRunLoopCommonModes);
    CFRelease(obs);
}

@end
