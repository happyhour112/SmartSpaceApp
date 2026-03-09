import 'package:flutter/material.dart';

import '../models/enums.dart';

class DeviceStatusBadge extends StatelessWidget {
  final DeviceStatus status;

  const DeviceStatusBadge({
    super.key,
    required this.status,
  });

  Color _getBackgroundColor() {
    switch (status) {
      case DeviceStatus.normal:
        return Colors.green.shade100;
      case DeviceStatus.warning:
        return Colors.orange.shade100;
      case DeviceStatus.offline:
        return Colors.red.shade100;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case DeviceStatus.normal:
        return Colors.green.shade800;
      case DeviceStatus.warning:
        return Colors.orange.shade800;
      case DeviceStatus.offline:
        return Colors.red.shade800;
    }
  }

  String _getLabel() {
    switch (status) {
      case DeviceStatus.normal:
        return 'Normal';
      case DeviceStatus.warning:
        return 'Warning';
      case DeviceStatus.offline:
        return 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          color: _getTextColor(),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
