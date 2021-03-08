import 'dart:async';

import 'package:flutter/services.dart';

final EnvironmentSensors environmentSensors = EnvironmentSensors();
const MethodChannel _methodChannel = MethodChannel('environment_sensors/method');
const EventChannel _temperatureEventChannel = EventChannel('environment_sensors/temperature');
const EventChannel _humidityEventChannel = EventChannel('environment_sensors/humidity');
const EventChannel _lightEventChannel = EventChannel('environment_sensors/light');
const EventChannel _pressureEventChannel = EventChannel('environment_sensors/pressure');

class EnvironmentSensors {
  Stream<double>? _humidityEvents;
  Stream<double>? _temperatureEvents;
  Stream<double>? _lightEvents;
  Stream<double>? _pressureEvents;

  Future<bool> getSensorAvailable(SensorType sensorType) async {
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

  Stream<double> get temperature {
    if (_temperatureEvents == null){
      _temperatureEvents = _temperatureEventChannel.receiveBroadcastStream().map((event) => double.parse(event.toString()));
    }
    return _temperatureEvents!;
  }

  Stream<double> get humidity {
    if (_humidityEvents == null){
      _humidityEvents = _humidityEventChannel.receiveBroadcastStream().map((event) => double.parse(event.toString()));
    }
    return _humidityEvents!;
  }

  Stream<double> get light {
    if (_lightEvents == null){
      _lightEvents = _lightEventChannel.receiveBroadcastStream().map((event) => double.parse(event.toString()));
    }
    return _lightEvents!;
  }

  Stream<double> get pressure{
    if (_pressureEvents == null){
      _pressureEvents = _pressureEventChannel.receiveBroadcastStream().map((event) => double.parse(event.toString()));
    }
    return _pressureEvents!;
  }



}

enum SensorType { AmbientTemperature, Humidity, Light, Pressure }
