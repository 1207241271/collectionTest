//
//  AppDelegate.h
//  collectionTest
//
//  Created by yangxu on 15/10/31.
//  Copyright (c) 2015年 yangxu. All rights reserved.
//
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatusBarHeight (IOS7==YES ? 0 : 20)
#define BackHeight      (IOS7==YES ? 0 : 15)

#define fNavBarHeigth (IOS7==YES ? 64 : 44)
#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height-StatusBarHeight)

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

