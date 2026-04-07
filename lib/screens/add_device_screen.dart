import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/dummy_rooms.dart';
import '../models/enums.dart';
import '../models/iot_device_model.dart';
import '../state/device_provider.dart';
import '../widgets/custom_text_field.dart';

class AddDeviceScreen extends StatefulWidget {
  // final Function(IoTDeviceModel) onAddDevice;

  // const AddDeviceScreen({
  //   super.key,
  //   required this.onAddDevice,
  // });

  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DeviceType _selectedType = DeviceType.smartLamp;
  String _selectedRoomId = dummyRooms.first.id;
  bool _isOn = false;
  bool _isOnline = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _getDeviceTypeText(DeviceType type) {
    switch (type) {
      case DeviceType.smartLamp:
        return 'Smart Lamp';
      case DeviceType.smartFan:
        return 'Smart Fan';
      case DeviceType.smartPlug:
        return 'Smart Plug';
      case DeviceType.temperatureSensor:
        return 'Temperature Sensor';
      case DeviceType.humiditySensor:
        return 'Humidity Sensor';
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool isSensor = _selectedType == DeviceType.temperatureSensor ||
        _selectedType == DeviceType.humiditySensor;

    final newDevice = IoTDeviceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      type: _selectedType,
      roomId: _selectedRoomId,
      isOn: isSensor ? true : _isOn,
      isOnline: _isOnline,
      status: _isOnline ? DeviceStatus.normal : DeviceStatus.offline,
      temperature: _selectedType == DeviceType.temperatureSensor ? 26.0 : null,
      humidity: _selectedType == DeviceType.humiditySensor ? 60.0 : null,
      lastUpdated: DateTime.now(),
    );
    //widget.onAddDevice(newDevice);
    Provider.of<DeviceProvider>(context, listen: false).addDevice(newDevice);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New device added successfully.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isSensor = _selectedType == DeviceType.temperatureSensor ||
        _selectedType == DeviceType.humiditySensor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Device'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _nameController,
                  label: 'Device Name',
                  hintText: 'Enter device name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Device name is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<DeviceType>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Device Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: DeviceType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getDeviceTypeText(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRoomId,
                  decoration: InputDecoration(
                    labelText: 'Room',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: dummyRooms.map((room) {
                    return DropdownMenuItem(
                      value: room.id,
                      child: Text(room.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRoomId = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Device Online'),
                  subtitle:
                      const Text('Simulate device network connection status'),
                  value: _isOnline,
                  onChanged: (value) {
                    setState(() {
                      _isOnline = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Power ON'),
                  subtitle: Text(
                    isSensor
                        ? 'Sensor devices are read-only and stay active automatically.'
                        : 'Turn the device on or off at creation time.',
                  ),
                  value: isSensor ? true : _isOn,
                  onChanged: isSensor
                      ? null
                      : (value) {
                          setState(() {
                            _isOn = value;
                          });
                        },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Save Device'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
