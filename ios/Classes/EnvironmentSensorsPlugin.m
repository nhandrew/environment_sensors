#import "EnvironmentSensorsPlugin.h"
#if __has_include(<environment_sensors/environment_sensors-Swift.h>)
#import <environment_sensors/environment_sensors-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "environment_sensors-Swift.h"
#endif

@implementation EnvironmentSensorsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEnvironmentSensorsPlugin registerWithRegistrar:registrar];
}
@end
