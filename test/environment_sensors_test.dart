import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:environment_sensors/environment_sensors.dart';

void main() {
  const MethodChannel channel = MethodChannel('environment_sensors');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await EnvironmentSensors.platformVersion, '42');
  // });
}
