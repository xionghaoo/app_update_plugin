#import "UpdatePlugin.h"
#if __has_include(<appupdateplugin/appupdateplugin-Swift.h>)
#import <appupdateplugin/appupdateplugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "appupdateplugin-Swift.h"
#endif

@implementation UpdatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUpdatePlugin registerWithRegistrar:registrar];
}
@end
