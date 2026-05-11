import 'package:flutter/material.dart';
import 'dart:async';
import '../data/dummy_devices.dart';
import '../models/iot_device_model.dart';
import '../services/firestore_service.dart';
import '../services/sensor_simulator_service.dart';

class DeviceProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  late final SensorSimulatorService _sensorSimulatorService =
      SensorSimulatorService(firestoreService: _firestoreService);
  final List<IoTDeviceModel> _devices = [];

  StreamSubscription<List<IoTDeviceModel>>? _devicesSubscription;
  String? _uid;
  String _searchKeyword = '';

  List<IoTDeviceModel> get devices => _devices;

  String get searchKeyword => _searchKeyword;

  List<IoTDeviceModel> get filteredDevices {
    if (_searchKeyword.trim().isEmpty) {
      return _devices;
    }

    return _devices.where((device) {
      return device.name.toLowerCase().contains(_searchKeyword.toLowerCase());
    }).toList();
  }

  Future<void> startForUser(String uid) async {
    if (_uid == uid) return;
    _uid = uid;
    await _devicesSubscription?.cancel();
    _devicesSubscription =
        _firestoreService.watchDevices(uid).listen((devices) async {
      final wasEmpty = _devices.isEmpty;
      _devices
        ..clear()
        ..addAll(devices);
      notifyListeners();
      _sensorSimulatorService.start(uid: uid, getDevices: () => _devices);
      if (devices.isEmpty && wasEmpty) await seedInitialDevicesForUser();
    });
  }

  Future<void> seedInitialDevicesForUser() async {
    final uid = _uid;
    if (uid == null) return;
    for (final device in initialDummyDevices) {
      await _firestoreService.createOrUpdateDevice(uid, device);
    }
  }

  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  Future<void> addDevice(IoTDeviceModel newDevice) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestoreService.createOrUpdateDevice(uid, newDevice);
  }

  Future<void> toggleDevice(IoTDeviceModel device, bool newValue) async {
    final uid = _uid;
    if (uid == null) return;
    device.isOn = newValue;
    notifyListeners();
    await _firestoreService.updateDevicePower(
        uid: uid, device: device, isOn: newValue);
  }

  Future<void> updateDeviceName(IoTDeviceModel device, String newName) async {
    final uid = _uid;
    if (uid == null) return;
    device.name = newName;
    notifyListeners();
    await _firestoreService.updateDeviceName(
        uid: uid, device: device, newName: newName);
  }

  Future<void> deleteDevice(IoTDeviceModel device) async {
    final uid = _uid;

    if (uid == null) return;

    _devices.removeWhere((item) => item.id == device.id);
    notifyListeners();

    await _firestoreService.deleteDevice(
      uid: uid,
      deviceId: device.id,
    );
  }

  int get totalDevices => _devices.length;

  int get onlineDevices => _devices.where((device) => device.isOnline).length;

  int get activeDevices => _devices.where((device) => device.isOn).length;

  @override
  void dispose() {
    _devicesSubscription?.cancel();
    _sensorSimulatorService.stop();
    super.dispose();
  }
}
