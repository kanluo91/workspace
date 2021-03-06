//
//  AppDelegate.m
//  17-Crash分析
//
//  Created by luokan on 2021/3/13.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static bool canDimiss = NO;

void MyCustonExceptionHandle(NSException * exception){
    NSLog(@"程序崩溃了  前\n");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"崩溃日志上传完毕\n");
        canDimiss = YES;
    });
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFArrayRef allModels = CFRunLoopCopyAllModes(runloop);
    while (!canDimiss) {
        for (NSString *model in (__bridge  NSArray *)allModels) {
            CFRunLoopRunInMode((CFStringRef)model, 0.0001, false);
        }
    }
    CFRelease(allModels);
    
    NSLog(@"程序崩溃了  后\n");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    NSSetUncaughtExceptionHandler(&MyCustonExceptionHandle);
    
    return YES;
}

-(void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"崩溃  applicationWillTerminate\n");
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
