import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/dummy_rooms.dart';
import '../state/device_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/dashboard_summary_card.dart';
import 'device_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);

    final summaryCards = [
      DashboardSummaryCard(
        title: 'Total Devices',
        value: deviceProvider.totalDevices.toString(),
        icon: Icons.devices,
      ),
      DashboardSummaryCard(
        title: 'Online Devices',
        value: deviceProvider.onlineDevices.toString(),
        icon: Icons.wifi,
      ),
      DashboardSummaryCard(
        title: 'Active Devices',
        value: deviceProvider.activeDevices.toString(),
        icon: Icons.power,
      ),
      DashboardSummaryCard(
        title: 'Registered Rooms',
        value: dummyRooms.length.toString(),
        icon: Icons.meeting_room,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartSpace IoT Dashboard'),
      ),
      drawer: AppDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 700;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
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
                        'Monitor and manage classroom devices in one place.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (!isWide)
                        ...summaryCards
                      else
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: summaryCards.map((card) {
                            return SizedBox(
                              width: (constraints.maxWidth - 48) / 2,
                              child: card,
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DeviceListScreen(),
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
            ),
          );
        },
      ),
    );
  }
}
