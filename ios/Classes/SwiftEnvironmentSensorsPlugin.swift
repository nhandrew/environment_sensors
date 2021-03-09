import Flutter
import UIKit

let TYPE_TEMPERATURE = 0
let TYPE_HUMIDITY = 0
let TYPE_PRESSURE = 4
let TYPE_LIGHT = 10

public class SwiftEnvironmentSensorsPlugin: NSObject, FlutterPlugin {
   private let pressureStreamHandler = PressureStreamHandler()
   private let lightStreamHandler = PressureStreamHandler()


  public static func register(with registrar: FlutterPluginRegistrar) {
    let METHOD_CHANNEL_NAME = "environment_sensors/method"
    let instance = SwiftEnvironmentSensorsPlugin(registrar:registrar)
    let channel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  init(registrar: FlutterPluginRegistrar) {
          let PRESSURE_CHANNEL_NAME = "environment_sensors/pressure"
          let LIGHT_CHANNEL_NAME = "environment_sensors/light"

          let pressureChannel = FlutterEventChannel(name: PRESSURE_CHANNEL_NAME, binaryMessenger: registrar.messenger())
          pressureChannel.setStreamHandler(pressureStreamHandler)

          let lightChannel = FlutterEventChannel(name: LIGHT_CHANNEL_NAME, binaryMessenger: registrar.messenger())
          lightChannel.setStreamHandler(lightStreamHandler)
    
      }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
           case "isSensorAvailable":
               result(isSensorAvailable(call.arguments as! Int))
           default:
               result(FlutterMethodNotImplemented)
           }
  }
    
public func isSensorAvailable(_ sensorType: Int) -> Bool {
        switch sensorType {
        case TYPE_PRESSURE:
            return true
        case TYPE_LIGHT:
            return true
        case TYPE_TEMPERATURE:
            return false
        case TYPE_HUMIDITY:
            return false
        default:
            return false
        }
    }
}
