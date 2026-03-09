import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About SmartSpace IoT'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SmartSpace IoT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'This Flutter application is used for classroom teaching to simulate a simple IoT device management system.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Key learning topics:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text('- Widget layout'),
            Text('- Dart model classes and enums'),
            Text('- ListView and reusable widgets'),
            Text('- Navigation between screens'),
            Text('- Forms and input validation'),
            Text('- Drawer navigation'),
            Text('- Stateful interaction before ChangeNotifier'),
          ],
        ),
      ),
    );
  }
}
