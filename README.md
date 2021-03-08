# Environment Sensors


A plugin for checking the availability of and reading values of device ambient temperature, relative humidity, light, and pressure sensors.  Currently only Android is supported.
## Install
Add ```environment_sensors``` as a dependency in  `pubspec.yaml`.
For help on adding as a dependency, view the [documentation](https://flutter.io/using-packages/).

## Usage
Check for availability of sensors
```dart
final environmentSensors = EnvironmentSensors();   

    var tempAvailable = await environmentSensors.getSensorAvailable(SensorType.AmbientTemperature);
    var humidityAvailable = await environmentSensors.getSensorAvailable(SensorType.Humidity);
    var lightAvailable = await environmentSensors.getSensorAvailable(SensorType.Light);
    var pressureAvailable = await environmentSensors.getSensorAvailable(SensorType.Pressure);
```

Get sensor stream
```dart
final environmentSensors = EnvironmentSensors();

  environmentSensors.pressure.listen((pressure) {
    print(pressure.toString());
  });
```