//
//  XYZAppDelegate.m
//  Tooth
//
//  Created by 吉井 竜太 on 13/09/07.
//  Copyright (c) 2013年 吉井 竜太. All rights reserved.
//

#import "XYZAppDelegate.h"

// 初期画面となるVCのヘッダファイルをインポート
#import "BlueToothTestViewController.h"

@implementation XYZAppDelegate {
    // 初期画面用のビューコントローラ
    UIViewController* viewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 初期画面をてきとうに作るよー！！
    viewController = [[BlueToothTestViewController alloc] init];
    [self.window addSubview:viewController.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end