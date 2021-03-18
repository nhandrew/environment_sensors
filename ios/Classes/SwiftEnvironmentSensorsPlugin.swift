import Flutter
import UIKit
import CoreMotion

let TYPE_TEMPERATURE = 13
let TYPE_HUMIDITY = 12
let TYPE_PRESSURE = 6
let TYPE_LIGHT = 5

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

          let pressureChannel = FlutterEventChannel(name: PRESSURE_CHANNEL_NAME, binaryMessenger: registrar.messenger())
          pressureChannel.setStreamHandler(pressureStreamHandler)

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
            return CMAltimeter.isRelativeAltitudeAvailable()
        case TYPE_LIGHT:
            return false
        case TYPE_HUMIDITY:
            return false
        case TYPE_TEMPERATURE:
            return false
        default:
            return false
        }
    }
}

class PressureStreamHandler: NSObject, FlutterStreamHandler {
    let altimeter = CMAltimeter()
    private let queue = OperationQueue()
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        

        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: queue) { (data, error) in
                if data != nil {
                    //Get Pressure and convert kilopascals to millibars
                    var pressurePascals = data?.pressure
                    events(pressurePascals!.doubleValue * 10.0)
                }
            }
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        altimeter.stopRelativeAltitudeUpdates()
        return nil
    }
    
}
