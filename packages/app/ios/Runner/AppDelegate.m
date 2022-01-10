#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "ScreenCaptureButtonPlugin.h"
// #import "FlutterVoipPushNotificationPlugin.h"
// #import "FlutterCallKitPlugin.h"

@import Firebase;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSError *error = nil;
    FIROptions *options = [FIROptions defaultOptions];
    [FIRApp configureWithOptions:options];
    //[FIRAuth.auth useUserAccessGroup:kaccessGroup error:&error];
    if (error) {
        NSLog(@"ERROR SETTIG UP APP GROUP FOR GOTOK APP: %@", error.localizedDescription);
    }
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [ScreenCaptureButtonPlugin registerWithRegistrar:[self registrarForPlugin:NSStringFromClass([ScreenCaptureButtonPlugin class])]];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

/* Add PushKit delegate method */

// Handle updated push credentials
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
    // [FlutterVoipPushNotificationPlugin didUpdatePushCredentials:credentials forType:(NSString *)type];
}

// Handle incoming pushes
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type withCompletionHandler:(nonnull void (^)(void))completion{
    // [FlutterVoipPushNotificationPlugin didReceiveIncomingPushWithPayload:payload forType:(NSString *)type];
    // NSString *callType = payload.dictionaryPayload[@"type"];
    // NSString *uuid = payload.dictionaryPayload[@"callId"];;
    // NSString *callerName = payload.dictionaryPayload[@"eventTitle"];
    // NSString *handle = payload.dictionaryPayload[@"senderUsername"];
    // BOOL hasVideo = callType != nil && [callType isEqualToString:@"call/video"];;
    // [FlutterCallKitPlugin reportNewIncomingCall:uuid handle:handle handleType:@"generic" hasVideo:hasVideo localizedCallerName:callerName fromPushKit:YES];
    completion();
}

@end
