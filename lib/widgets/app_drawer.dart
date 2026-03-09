import 'package:flutter/material.dart';
import 'package:smart_space_app/models/iot_device_model.dart';

import '../screens/about_screen.dart';
import '../screens/add_device_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/device_list_screen.dart';

class AppDrawer extends StatelessWidget {
  final List<IoTDeviceModel> devices;
  final Function(IoTDeviceModel) onAddDevice;

  const AppDrawer({
    super.key,
    required this.devices,
    required this.onAddDevice,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('MyDemoApp'),
            accountEmail: Text('smartspace@classroom.demo'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.school),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardScreen(
                    devices: devices,
                    onAddDevice: onAddDevice,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.devices),
            title: const Text('Devices'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DeviceListScreen(
                    devices: devices,
                    onAddDevice: onAddDevice,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Device'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddDeviceScreen(
                    onAddDevice: onAddDevice,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
