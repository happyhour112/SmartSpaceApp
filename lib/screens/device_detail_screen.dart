import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/dummy_rooms.dart';
import '../models/enums.dart';
import '../models/iot_device_model.dart';
import '../state/device_provider.dart';
import '../screens/edit_device_screen.dart';
import '../widgets/device_status_badge.dart';

// class DeviceDetailScreen extends StatefulWidget {
//   final IoTDeviceModel device;

//   const DeviceDetailScreen({
//     super.key,
//     required this.device,
//   });

//   @override
//   State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
// }

// class _DeviceDetailScreenState extends State<DeviceDetailScreen> {

class DeviceDetailScreen extends StatelessWidget {
  final IoTDeviceModel device;

  const DeviceDetailScreen({
    super.key,
    required this.device,
  });

  String _getRoomName(String roomId) {
    try {
      return dummyRooms.firstWhere((room) => room.id == roomId).name;
    } catch (_) {
      return 'Unknown Room';
    }
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

  bool _canToggle(DeviceType type) {
    return type == DeviceType.smartLamp ||
        type == DeviceType.smartFan ||
        type == DeviceType.smartPlug;
  }

  @override
  Widget build(BuildContext context) {
    //final device = widget.device;
    final deviceProvider = Provider.of<DeviceProvider>(context);

    Widget infoCard = Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DeviceStatusBadge(status: device.status),
            const SizedBox(height: 16),
            Text('Type: ${_getDeviceTypeText(device.type)}'),
            const SizedBox(height: 8),
            Text('Room: ${_getRoomName(device.roomId)}'),
            const SizedBox(height: 8),
            Text('Connection: ${device.isOnline ? 'Online' : 'Offline'}'),
            const SizedBox(height: 8),
            Text('Power: ${device.isOn ? 'ON' : 'OFF'}'),
            const SizedBox(height: 8),
            Text('Last Updated: ${device.lastUpdated.toString()}'),
          ],
        ),
      ),
    );

    Widget telemetryCard = Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Telemetry',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (device.temperature != null)
              Text(
                'Temperature: ${device.temperature!.toStringAsFixed(1)} °C',
                style: const TextStyle(fontSize: 16),
              ),
            if (device.humidity != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Humidity: ${device.humidity!.toStringAsFixed(1)} %',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            if (device.temperature == null && device.humidity == null)
              const Text(
                'This device does not provide sensor telemetry.',
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            if (_canToggle(device.type))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: device.isOnline
                      ? () {
                          // setState(() {
                          //   device.isOn = !device.isOn;
                          // });
                          deviceProvider.toggleDevice(device, !device.isOn);
                        }
                      : null,
                  icon: Icon(
                      device.isOn ? Icons.power_settings_new : Icons.power_off),
                  label:
                      Text(device.isOn ? 'Turn OFF Device' : 'Turn ON Device'),
                ),
              ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Detail'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditDeviceScreen(device: device),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 800;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: infoCard),
                            const SizedBox(width: 16),
                            Expanded(child: telemetryCard),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            infoCard,
                            const SizedBox(height: 16),
                            telemetryCard,
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
