//
//  AppDelegate.h
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

