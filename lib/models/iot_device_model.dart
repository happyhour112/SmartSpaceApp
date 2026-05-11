import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class IoTDeviceModel {
  final String id;
  String name;
  final DeviceType type;
  final String roomId;
  bool isOn;
  bool isOnline;
  DeviceStatus status;
  double? temperature;
  double? humidity;
  final DateTime lastUpdated;

  IoTDeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.roomId,
    required this.isOn,
    required this.isOnline,
    required this.status,
    this.temperature,
    this.humidity,
    required this.lastUpdated,
  });

  bool get isSensor =>
      type == DeviceType.temperatureSensor || type == DeviceType.humiditySensor;

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'name': name,
        'type': type.firestoreValue,
        'roomId': roomId,
        'isOn': isOn,
        'isOnline': isOnline,
        'status': status.firestoreValue,
        'temperature': temperature,
        'humidity': humidity,
        'lastUpdated': Timestamp.fromDate(lastUpdated),
        'updatedAt': FieldValue.serverTimestamp()
      };

  factory IoTDeviceModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return IoTDeviceModel(
      id: doc.id,
      name: data['name'] ?? 'Unnamed Device',
      type: DeviceTypeExtension.fromFirestore(data['type'] ?? 'smartLamp'),
      roomId: data['roomId'] ?? 'r1',
      isOn: data['isOn'] ?? false,
      isOnline: data['isOnline'] ?? true,
      status: DeviceStatusExtension.fromFirestore(data['status'] ?? 'normal'),
      temperature: (data['temperature'] as num?)?.toDouble(),
      humidity: (data['humidity'] as num?)?.toDouble(),
      lastUpdated: data['lastUpdated'] is Timestamp
          ? (data['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
