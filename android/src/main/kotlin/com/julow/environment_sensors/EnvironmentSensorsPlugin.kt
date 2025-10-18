package com.julow.environment_sensors

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** EnvironmentSensorsPlugin */
class EnvironmentSensorsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private val METHOD_CHANNEL_NAME = "environment_sensors/method"
  private val TEMPERATURE_CHANNEL_NAME = "environment_sensors/temperature"
  private val HUMIDITY_CHANNEL_NAME = "environment_sensors/humidity"
  private val LIGHT_CHANNEL_NAME = "environment_sensors/light"
  private val PRESSURE_CHANNEL_NAME = "environment_sensors/pressure"

  private var sensorManager: SensorManager? = null
  private var methodChannel: MethodChannel? = null
  private var temperatureChannel: EventChannel? = null
  private var humidityChannel: EventChannel? = null
  private var lightChannel: EventChannel? = null
  private var pressureChannel: EventChannel? = null

  private var temperatureStreamHandler: StreamHandlerImpl? = null
  private var humidityStreamHandler: StreamHandlerImpl? = null
  private var lightStreamHandler: StreamHandlerImpl? = null
  private var pressureStreamHandler: StreamHandlerImpl? = null


  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    val context = binding.applicationContext
    setupEventChannels(context, binding.binaryMessenger)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    teardownEventChannels()
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "isSensorAvailable") {
      result.success(sensorManager!!.getSensorList(call.arguments as Int).isNotEmpty())
    } else {
      result.notImplemented()
    }
  }



  private fun setupEventChannels(context: Context, messenger: BinaryMessenger) {
    sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

    methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
    methodChannel!!.setMethodCallHandler(this)

    temperatureChannel = EventChannel(messenger, TEMPERATURE_CHANNEL_NAME)
    temperatureStreamHandler = StreamHandlerImpl(sensorManager!!, Sensor.TYPE_AMBIENT_TEMPERATURE)
    temperatureChannel!!.setStreamHandler(temperatureStreamHandler!!)

    humidityChannel = EventChannel(messenger, HUMIDITY_CHANNEL_NAME)
    humidityStreamHandler = StreamHandlerImpl(sensorManager!!, Sensor.TYPE_RELATIVE_HUMIDITY)
    humidityChannel!!.setStreamHandler(humidityStreamHandler!!)

    lightChannel = EventChannel(messenger, LIGHT_CHANNEL_NAME)
    lightStreamHandler = StreamHandlerImpl(sensorManager!!, Sensor.TYPE_LIGHT)
    lightChannel!!.setStreamHandler(lightStreamHandler!!)

    pressureChannel = EventChannel(messenger, PRESSURE_CHANNEL_NAME)
    pressureStreamHandler = StreamHandlerImpl(sensorManager!!, Sensor.TYPE_PRESSURE)
    pressureChannel!!.setStreamHandler(pressureStreamHandler!!)

  }

  private fun teardownEventChannels() {
    methodChannel!!.setMethodCallHandler(null)
    temperatureChannel!!.setStreamHandler(null)
    humidityChannel!!.setStreamHandler(null)
    lightChannel!!.setStreamHandler(null)
    pressureChannel!!.setStreamHandler(null)
  }
}

class StreamHandlerImpl(private val sensorManager: SensorManager, sensorType: Int, private var interval: Int = SensorManager.SENSOR_DELAY_NORMAL) :
        EventChannel.StreamHandler, SensorEventListener {
  private val sensor = sensorManager.getDefaultSensor(sensorType)
  private var eventSink: EventChannel.EventSink? = null

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    if (sensor != null) {
      eventSink = events
      sensorManager.registerListener(this, sensor, interval)
    }
  }

  override fun onCancel(arguments: Any?) {
    sensorManager.unregisterListener(this)
    eventSink = null
  }

  override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {

  }

  override fun onSensorChanged(event: SensorEvent?) {
    val sensorValues = event!!.values[0]
    eventSink?.success(sensorValues)
  }

  fun setUpdateInterval(interval: Int) {
    this.interval = interval
    if (eventSink != null) {
      sensorManager.unregisterListener(this)
      sensorManager.registerListener(this, sensor, interval)
    }
  }
}
