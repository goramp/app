#import <Flutter/Flutter.h>
#import <ReplayKit/ReplayKit.h>

@interface FlutterScreenCaptureButtonController : NSObject <FlutterPlatformView, FlutterStreamHandler>

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end

@interface FlutterScreenCaptureButtonFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

@interface ScreenCaptureButtonPlugin : NSObject<FlutterPlugin>
@end

