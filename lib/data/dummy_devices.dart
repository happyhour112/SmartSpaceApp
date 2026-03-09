import '../models/enums.dart';
import '../models/iot_device_model.dart';

final List<IoTDeviceModel> initialDummyDevices = [
  IoTDeviceModel(
    id: 'd1',
    name: 'Front Lamp',
    type: DeviceType.smartLamp,
    roomId: 'r1',
    isOn: true,
    isOnline: true,
    status: DeviceStatus.normal,
    lastUpdated: DateTime.now(),
  ),
  IoTDeviceModel(
    id: 'd2',
    name: 'Ceiling Fan',
    type: DeviceType.smartFan,
    roomId: 'r1',
    isOn: false,
    isOnline: true,
    status: DeviceStatus.normal,
    lastUpdated: DateTime.now(),
  ),
  IoTDeviceModel(
    id: 'd3',
    name: 'Temperature Sensor 01',
    type: DeviceType.temperatureSensor,
    roomId: 'r2',
    isOn: true,
    isOnline: true,
    status: DeviceStatus.normal,
    temperature: 24.6,
    humidity: 58.2,
    lastUpdated: DateTime.now(),
  ),
  IoTDeviceModel(
    id: 'd4',
    name: 'Power Plug A',
    type: DeviceType.smartPlug,
    roomId: 'r3',
    isOn: false,
    isOnline: false,
    status: DeviceStatus.offline,
    lastUpdated: DateTime.now(),
  ),
];
