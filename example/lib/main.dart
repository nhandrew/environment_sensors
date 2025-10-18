import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Environment Sensors Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EnvironmentSensorsDemo(),
    );
  }
}

class EnvironmentSensorsDemo extends StatefulWidget {
  const EnvironmentSensorsDemo({super.key});

  @override
  State<EnvironmentSensorsDemo> createState() => _EnvironmentSensorsDemoState();
}

class _EnvironmentSensorsDemoState extends State<EnvironmentSensorsDemo> {
  String _status = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _checkSensors();
  }

  Future<void> _checkSensors() async {
    try {
      // Check if sensors are available
      final isAvailable = await EnvironmentSensors().getSensorAvailable(
        SensorType.AmbientTemperature,
      );

      if (isAvailable) {
        setState(() {
          _status = 'Environment sensors are available!';
        });
      } else {
        setState(() {
          _status = 'Environment sensors are not available on this device.';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Environment Sensors Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sensors, size: 64, color: Colors.deepPurple),
              const SizedBox(height: 24),
              const Text(
                'Environment Sensors Plugin',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _status,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _checkSensors,
                child: const Text('Check Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
