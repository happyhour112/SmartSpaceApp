enum DeviceType {
  smartLamp,
  smartFan,
  smartPlug,
  temperatureSensor,
  humiditySensor,
}

enum DeviceStatus {
  normal,
  warning,
  offline,
}

extension DeviceTypeExtension on DeviceType {
  String get firestoreValue => name;
  static DeviceType fromFirestore(String value) => DeviceType.values
      .firstWhere((e) => e.name == value, orElse: () => DeviceType.smartLamp);
}

extension DeviceStatusExtension on DeviceStatus {
  String get firestoreValue => name;
  static DeviceStatus fromFirestore(String value) => DeviceStatus.values
      .firstWhere((e) => e.name == value, orElse: () => DeviceStatus.normal);
}
