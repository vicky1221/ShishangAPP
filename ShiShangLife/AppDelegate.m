//
//  AppDelegate.m
//  ShiShangLife
//
//  Created by VickyCao on 9/30/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "AppDelegate.h"
#import "DTInit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setupTabbarItems {
    NSArray *originImageArray = @[@"icon_home", @"icon_rss", @"icon_group", @"icon_profile"];
    NSArray *selectImageArray = @[@"icon_home-s", @"icon_rss-s", @"icon_group-s", @"icon_profile-s"];
    for (int i = 0; i < self.tabbarController.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabbarController.tabBar.items[i];
        [item setFinishedSelectedImage:[UIImage imageNamed:selectImageArray[i]] withFinishedUnselectedImage:[UIImage imageNamed:originImageArray[i]]];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      rgb_color(128, 128, 128, 1), NSForegroundColorAttributeName, nil]
                            forState:UIControlStateNormal];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      rgb_color(255, 51, 102, 1), NSForegroundColorAttributeName,
                                      nil] forState:UIControlStateSelected];
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.tabbarController = (UITabBarController *)self.window.rootViewController;
    [self setupTabbarItems];            // 自定义Tabbar
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

@end
