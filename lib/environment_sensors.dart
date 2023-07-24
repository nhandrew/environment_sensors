import 'dart:async';

import 'package:flutter/services.dart';

///Main channel for method calls
const MethodChannel _methodChannel =
    MethodChannel('environment_sensors/method');

///Event channel for ambient temperature readings
const EventChannel _temperatureEventChannel =
    EventChannel('environment_sensors/temperature');

///Event channel for relative humdity readings
const EventChannel _humidityEventChannel =
    EventChannel('environment_sensors/humidity');

///Event channel for ambient light readings
const EventChannel _lightEventChannel =
    EventChannel('environment_sensors/light');

///Event channel for pressure readings
const EventChannel _pressureEventChannel =
    EventChannel('environment_sensors/pressure');

class EnvironmentSensors {
  ///Stream of relative humidity readings
  Stream<double>? _humidityEvents;

  ///Stream of ambient temperature readings
  Stream<double>? _temperatureEvents;

  ///Stream of ambient light readings
  Stream<double>? _lightEvents;

  ///Stream of pressure readings
  Stream<double>? _pressureEvents;

  ///Check for the availability of device sensor by sensor type.
  Future<bool> isSensorAvaliable(SensorType sensorType) async {
    if (sensorType == SensorType.AmbientTemperature)
      return await _methodChannel.invokeMethod('isSensorAvailable', 13);
    if (sensorType == SensorType.Humidity)
      return await _methodChannel.invokeMethod('isSensorAvailable', 12);
    if (sensorType == SensorType.Light)
      return await _methodChannel.invokeMethod('isSensorAvailable', 5);
    if (sensorType == SensorType.Pressure)
      return await _methodChannel.invokeMethod('isSensorAvailable', 6);

    return false;
  }

  ///Gets the ambient temperature reading from device sensor, if present
  Stream<double> get temperature {
    if (_temperatureEvents == null) {
      _temperatureEvents = _temperatureEventChannel
          .receiveBroadcastStream()
          .map((event) => double.parse(event.toString()));
    }
    return _temperatureEvents!;
  }

  ///Gets the relative humidity reading from device sensor, if present
  Stream<double> get humidity {
    if (_humidityEvents == null) {
      _humidityEvents = _humidityEventChannel
          .receiveBroadcastStream()
          .map((event) => double.parse(event.toString()));
    }
    return _humidityEvents!;
  }

  ///Gets the ambient light reading from device sensor, if present
  Stream<double> get light {
    if (_lightEvents == null) {
      _lightEvents = _lightEventChannel
          .receiveBroadcastStream()
          .map((event) => double.parse(event.toString()));
    }
    return _lightEvents!;
  }

  ///Gets the pressure reading from device sensor, if present
  Stream<double> get pressure {
    if (_pressureEvents == null) {
      _pressureEvents = _pressureEventChannel
          .receiveBroadcastStream()
          .map((event) => double.parse(event.toString()));
    }
    return _pressureEvents!;
  }
}

///An enum for defining device types when checking for sensor availability
enum SensorType { AmbientTemperature, Humidity, Light, Pressure }
