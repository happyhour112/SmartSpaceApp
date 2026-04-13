import 'package:flutter/material.dart';

//import 'data/dummy_devices.dart';
//import 'models/iot_device_model.dart';
import 'screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'state/device_provider.dart';

void main() {
  runApp(const SmartSpaceApp());
}

class SmartSpaceApp extends StatelessWidget {
  const SmartSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeviceProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartSpace IoT',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}

// class SmartSpaceHome extends StatefulWidget {
//   const SmartSpaceHome({super.key});

//   @override
//   State<SmartSpaceHome> createState() => _SmartSpaceHomeState();
// }

// class _SmartSpaceHomeState extends State<SmartSpaceHome> {
//   final List<IoTDeviceModel> _devices =
//       List<IoTDeviceModel>.from(initialDummyDevices);

//   void _addDevice(IoTDeviceModel newDevice) {
//     setState(() {
//       _devices.add(newDevice);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DashboardScreen(
//       devices: _devices,
//       onAddDevice: _addDevice,
//     );
//   }
// }
