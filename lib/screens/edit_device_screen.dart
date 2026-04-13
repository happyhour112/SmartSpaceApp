import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/iot_device_model.dart';
import '../state/device_provider.dart';
import '../widgets/custom_text_field.dart';

class EditDeviceScreen extends StatefulWidget {
  final IoTDeviceModel device;

  const EditDeviceScreen({
    super.key,
    required this.device,
  });

  @override
  State<EditDeviceScreen> createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // setState(() {
    //   widget.device.name = _nameController.text.trim();
    // });

    Provider.of<DeviceProvider>(context, listen: false).updateDeviceName(
      widget.device,
      _nameController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Device name updated successfully.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Device Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Device Name',
                hintText: 'Enter updated device name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Device name is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
