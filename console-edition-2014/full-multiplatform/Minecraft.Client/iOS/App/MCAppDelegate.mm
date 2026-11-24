#import <GameController/GameController.h>
#import <UIKit/UIKit.h>

#import "MCGameViewController.h"
#include "../Platform/MCIOSPlatform.h"

@interface MCAppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic, strong) UIWindow* window;
@end

@implementation MCAppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)options
{
    (void)application;
    (void)options;
    MCIOSPlatform::shared().launch();

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [MCGameViewController new];
    [self.window makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter] addObserverForName:GCControllerDidConnectNotification
                                                      object:nil
                                                       queue:NSOperationQueue.mainQueue
                                                  usingBlock:^(__unused NSNotification* notification) {
        MCIOSPlatform::shared().controllerConnected();
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:GCControllerDidDisconnectNotification
                                                      object:nil
                                                       queue:NSOperationQueue.mainQueue
                                                  usingBlock:^(__unused NSNotification* notification) {
        MCIOSPlatform::shared().controllerDisconnected();
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application { (void)application; MCIOSPlatform::shared().suspend(); }
- (void)applicationDidBecomeActive:(UIApplication*)application { (void)application; MCIOSPlatform::shared().resume(); }
- (void)applicationWillTerminate:(UIApplication*)application { (void)application; MCIOSPlatform::shared().terminate(); }

@end

int main(int argc, char* argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(MCAppDelegate.class));
    }
}
