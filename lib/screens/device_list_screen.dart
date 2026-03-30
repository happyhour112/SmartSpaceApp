import 'package:flutter/material.dart';

import '../data/dummy_rooms.dart';
import '../models/iot_device_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/device_card.dart';
import 'add_device_screen.dart';
import 'device_detail_screen.dart';

class DeviceListScreen extends StatefulWidget {
  final List<IoTDeviceModel> devices;
  final Function(IoTDeviceModel) onAddDevice;

  const DeviceListScreen({
    super.key,
    required this.devices,
    required this.onAddDevice,
  });

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getRoomName(String roomId) {
    try {
      return dummyRooms.firstWhere((room) => room.id == roomId).name;
    } catch (_) {
      return 'Unknown Room';
    }
  }

  List<IoTDeviceModel> _getFilteredDevices() {
    if (_searchKeyword.trim().isEmpty) {
      return widget.devices;
    }

    return widget.devices.where((device) {
      return device.name.toLowerCase().contains(_searchKeyword.toLowerCase());
    }).toList();
  }

  void _toggleDevice(IoTDeviceModel device, bool newValue) {
    setState(() {
      device.isOn = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredDevices = _getFilteredDevices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device List'),
      ),
      drawer: AppDrawer(
        devices: widget.devices,
        onAddDevice: widget.onAddDevice,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 800;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search device',
                        hintText: 'Enter device name',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchKeyword = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: filteredDevices.isEmpty
                        ? const Center(
                            child: Text(
                              'No device found.',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : isWide
                            ? GridView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 2.0,
                                ),
                                itemCount: filteredDevices.length,
                                itemBuilder: (context, index) {
                                  final device = filteredDevices[index];
                                  return DeviceCard(
                                    device: device,
                                    roomName: _getRoomName(device.roomId),
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DeviceDetailScreen(
                                              device: device),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    onToggle: (value) =>
                                        _toggleDevice(device, value),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: filteredDevices.length,
                                itemBuilder: (context, index) {
                                  final device = filteredDevices[index];
                                  return DeviceCard(
                                    device: device,
                                    roomName: _getRoomName(device.roomId),
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DeviceDetailScreen(
                                              device: device),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    onToggle: (value) =>
                                        _toggleDevice(device, value),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddDeviceScreen(
                onAddDevice: (newDevice) {
                  widget.onAddDevice(newDevice);
                  setState(() {});
                },
              ),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
