import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _organizationController = TextEditingController();
  final _roleController = TextEditingController();
  bool _isEditing = false, _isSaving = false, _filled = false;
  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _organizationController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _fill(UserProfileModel p) {
    if (_filled) return;
    _nameController.text = p.displayName;
    _countryController.text = p.country;
    _organizationController.text = p.organization;
    _roleController.text = p.role;
    _filled = true;
  }

  Future<void> _save(UserProfileModel p) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final updated = p.copyWith(
        displayName: _nameController.text.trim(),
        country: _countryController.text.trim(),
        organization: _organizationController.text.trim(),
        role: _roleController.text.trim());
    await _firestoreService.updateUserProfile(updated);
    await FirebaseAuth.instance.currentUser
        ?.updateDisplayName(_nameController.text.trim());
    if (mounted) {
      setState(() {
        _isSaving = false;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return const Scaffold(body: Center(child: Text('No logged-in user.')));
    return Scaffold(
        appBar: AppBar(title: const Text('User Profile'), actions: [
          IconButton(
              onPressed: () async => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout))
        ]),
        body: StreamBuilder<UserProfileModel?>(
            stream: _firestoreService.watchUserProfile(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());
              final profile = snapshot.data;
              if (profile == null)
                return const Center(child: Text('Profile document not found.'));
              _fill(profile);
              return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                      key: _formKey,
                      child: Column(children: [
                        Text('Logged in as ${profile.email}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        TextFormField(
                            controller: _nameController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder()),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Name is required.'
                                : null),
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: _countryController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                                labelText: 'Country',
                                border: OutlineInputBorder()),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Country is required.'
                                : null),
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: _organizationController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                                labelText: 'Organization / Campus',
                                border: OutlineInputBorder())),
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: _roleController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                                labelText: 'Role',
                                border: OutlineInputBorder())),
                        const SizedBox(height: 20),
                        if (!_isEditing)
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                  onPressed: () =>
                                      setState(() => _isEditing = true),
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit Profile')))
                        else
                          Row(children: [
                            Expanded(
                                child: ElevatedButton.icon(
                                    onPressed:
                                        _isSaving ? null : () => _save(profile),
                                    icon: const Icon(Icons.save),
                                    label: Text(
                                        _isSaving ? 'Saving...' : 'Save'))),
                            const SizedBox(width: 12),
                            Expanded(
                                child: OutlinedButton(
                                    onPressed: _isSaving
                                        ? null
                                        : () {
                                            setState(() {
                                              _filled = false;
                                              _fill(profile);
                                              _isEditing = false;
                                            });
                                          },
                                    child: const Text('Cancel')))
                          ])
                      ])));
            }));
  }
}
