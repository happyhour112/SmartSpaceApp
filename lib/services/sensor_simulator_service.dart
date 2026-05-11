import 'dart:async';
import 'dart:math';
import '../models/enums.dart';
import '../models/iot_device_model.dart';
import 'firestore_service.dart';

class SensorSimulatorService {
  SensorSimulatorService({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;
  final FirestoreService _firestoreService;
  final Random _random = Random();
  Timer? _timer;

  void start(
      {required String uid,
      required List<IoTDeviceModel> Function() getDevices}) {
    stop();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      final sensors = getDevices().where((device) => device.isSensor).toList();
      for (final device in sensors) {
        double? temperature = device.temperature;
        double? humidity = device.humidity;
        if (device.type == DeviceType.temperatureSensor)
          temperature = 24 + _random.nextDouble() * 8;
        if (device.type == DeviceType.humiditySensor)
          humidity = 50 + _random.nextDouble() * 25;
        await _firestoreService.saveSensorReading(
            uid: uid,
            device: device,
            temperature: temperature,
            humidity: humidity);
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
