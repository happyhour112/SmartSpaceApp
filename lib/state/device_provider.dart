import 'package:flutter/material.dart';

import '../data/dummy_devices.dart';
import '../models/iot_device_model.dart';

class DeviceProvider extends ChangeNotifier {
  final List<IoTDeviceModel> _devices =
      List<IoTDeviceModel>.from(initialDummyDevices);

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

  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  void addDevice(IoTDeviceModel newDevice) {
    _devices.add(newDevice);
    notifyListeners();
  }

  void toggleDevice(IoTDeviceModel device, bool newValue) {
    device.isOn = newValue;
    notifyListeners();
  }

  void updateDeviceName(IoTDeviceModel device, String newName) {
    device.name = newName;
    notifyListeners();
  }

  int get totalDevices => _devices.length;

  int get onlineDevices => _devices.where((device) => device.isOnline).length;

  int get activeDevices => _devices.where((device) => device.isOn).length;
}
