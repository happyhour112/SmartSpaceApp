import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/iot_device_model.dart';
import '../models/user_profile_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>> userDoc(String uid) =>
      _db.collection('users').doc(uid);
  CollectionReference<Map<String, dynamic>> userDevicesCollection(String uid) =>
      userDoc(uid).collection('devices');

  Stream<UserProfileModel?> watchUserProfile(String uid) => userDoc(uid)
      .snapshots()
      .map((doc) => doc.exists ? UserProfileModel.fromFirestore(doc) : null);

  Future<void> updateUserProfile(UserProfileModel profile) async {
    await userDoc(profile.uid)
        .set(profile.toUpdateMap(), SetOptions(merge: true));
  }

  Stream<List<IoTDeviceModel>> watchDevices(String uid) {
    return userDevicesCollection(uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(IoTDeviceModel.fromFirestore).toList();
    });
  }

  Future<void> createOrUpdateDevice(String uid, IoTDeviceModel device) async {
    await userDevicesCollection(uid)
        .doc(device.id)
        .set(device.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteDevice({
    required String uid,
    required String deviceId,
  }) async {
    final deviceRef = userDevicesCollection(uid).doc(deviceId);

    await deviceRef.delete();
  }

  Future<void> updateDevicePower(
      {required String uid,
      required IoTDeviceModel device,
      required bool isOn}) async {
    final deviceRef = userDevicesCollection(uid).doc(device.id);
    await deviceRef.set({
      'isOn': isOn,
      'lastUpdated': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp()
    }, SetOptions(merge: true));
    await deviceRef.collection('events').add({
      'eventType': 'powerChanged',
      'isOn': isOn,
      'createdAt': FieldValue.serverTimestamp()
    });
  }

  Future<void> updateDeviceName(
      {required String uid,
      required IoTDeviceModel device,
      required String newName}) async {
    await userDevicesCollection(uid).doc(device.id).set(
        {'name': newName, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true));
  }

  Future<void> saveSensorReading(
      {required String uid,
      required IoTDeviceModel device,
      required double? temperature,
      required double? humidity}) async {
    final deviceRef = userDevicesCollection(uid).doc(device.id);
    await deviceRef.set({
      'temperature': temperature,
      'humidity': humidity,
      'lastUpdated': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp()
    }, SetOptions(merge: true));
    await deviceRef.collection('telemetry').add({
      'temperature': temperature,
      'humidity': humidity,
      'createdAt': FieldValue.serverTimestamp()
    });
  }
}
