import 'package:flutter/material.dart';

import '../data/dummy_rooms.dart';
import '../models/iot_device_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/dashboard_summary_card.dart';
import 'device_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  final List<IoTDeviceModel> devices;
  final Function(IoTDeviceModel) onAddDevice;

  const DashboardScreen({
    super.key,
    required this.devices,
    required this.onAddDevice,
  });

  @override
  Widget build(BuildContext context) {
    final int totalDevices = devices.length;
    final int onlineDevices = devices.where((device) => device.isOnline).length;
    final int activeDevices = devices.where((device) => device.isOn).length;
    final int totalRooms = dummyRooms.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartSpace IoT Dashboard'),
      ),
      drawer: AppDrawer(
        devices: devices,
        onAddDevice: onAddDevice,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to SmartSpace IoT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Monitor and manage smart devices in one place.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              DashboardSummaryCard(
                title: 'Total Devices',
                value: totalDevices.toString(),
                icon: Icons.devices,
              ),
              DashboardSummaryCard(
                title: 'Online Devices',
                value: onlineDevices.toString(),
                icon: Icons.wifi,
              ),
              DashboardSummaryCard(
                title: 'Active Devices',
                value: activeDevices.toString(),
                icon: Icons.power,
              ),
              DashboardSummaryCard(
                title: 'Registered Rooms',
                value: totalRooms.toString(),
                icon: Icons.meeting_room,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeviceListScreen(
                          devices: devices,
                          onAddDevice: onAddDevice,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Go to Device List'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
