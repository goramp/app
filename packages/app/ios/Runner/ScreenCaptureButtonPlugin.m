//
//  FlutterScreenCaptureController.m
//  Pods-Runner
//
//  Created by Onyemaechi Okafor on 8/15/19.
//

#import <Foundation/Foundation.h>
#import "ScreenCaptureButtonPlugin.h"


@implementation ScreenCaptureButtonPlugin

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterScreenCaptureButtonFactory* screenFactory = [[FlutterScreenCaptureButtonFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:screenFactory withId:@"gotok.app/ScreenCaptureButtonPlugin"];
}

@end

@implementation FlutterScreenCaptureButtonFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    FlutterScreenCaptureButtonController* screenCaptureController =
    [[FlutterScreenCaptureButtonController alloc] initWithWithFrame:frame
                                        viewIdentifier:viewId
                                             arguments:args
                                       binaryMessenger:_messenger];
    return screenCaptureController;
}

@end


@implementation FlutterScreenCaptureButtonController{
    RPSystemBroadcastPickerView* _broadcastPicker;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    FlutterEventChannel* _eventChannel;
    FlutterEventSink _eventSink;
}

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        NSDictionary* argsMap = (NSDictionary*)args;
        NSNumber* height = ((NSNumber*)argsMap[@"height"]);
        NSNumber* width = ((NSNumber*)argsMap[@"width"]);
        _viewId = viewId;
        _broadcastPicker = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(0,0, [width intValue], [height intValue])];
        _broadcastPicker.translatesAutoresizingMaskIntoConstraints = false;
        _broadcastPicker.preferredExtension = @"io.goramp.Gotok";
        UIButton *button = (UIButton *)_broadcastPicker.subviews.firstObject;
        if (button && button.imageView) {
            button.imageView.tintColor = [UIColor clearColor];
            button.imageView.image = [UIImage imageNamed:@"mobile_screen_share"];;
        }
        NSString* channelName = [NSString stringWithFormat:@"gotok.app/ScreenCaptureButtonPlugin%lld", viewId];
        NSString* eventChannelName = [NSString stringWithFormat:@"gotok.app/ScreenCaptureButtonPlugin/events/%lld", viewId];
        _eventChannel = [FlutterEventChannel
                         eventChannelWithName:eventChannelName
                         binaryMessenger:messenger];
        [_eventChannel setStreamHandler:self];     
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
    }
    return self;
}

- (UIView*)view {
    return _broadcastPicker;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"dispose"]) {
        [_eventChannel setStreamHandler:nil];
        _channel = nil;
        _eventChannel = nil;
        _eventSink = nil;
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - FlutterStreamHandler methods

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)sink {
    _eventSink = sink;
    return nil;
}

@end
