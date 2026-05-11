import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid, displayName, email, country, organization, role;
  const UserProfileModel(
      {required this.uid,
      required this.displayName,
      required this.email,
      required this.country,
      required this.organization,
      required this.role});
  factory UserProfileModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserProfileModel(
        uid: doc.id,
        displayName: data['displayName'] ?? '',
        email: data['email'] ?? '',
        country: data['country'] ?? '',
        organization: data['organization'] ?? '',
        role: data['role'] ?? 'student');
  }
  Map<String, dynamic> toUpdateMap() => {
        'displayName': displayName,
        'country': country,
        'organization': organization,
        'role': role,
        'updatedAt': FieldValue.serverTimestamp()
      };
  UserProfileModel copyWith(
          {String? displayName,
          String? email,
          String? country,
          String? organization,
          String? role}) =>
      UserProfileModel(
          uid: uid,
          displayName: displayName ?? this.displayName,
          email: email ?? this.email,
          country: country ?? this.country,
          organization: organization ?? this.organization,
          role: role ?? this.role);
}
