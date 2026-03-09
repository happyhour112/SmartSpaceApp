import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/iot_device_model.dart';
import 'device_status_badge.dart';

class DeviceCard extends StatelessWidget {
  final IoTDeviceModel device;
  final String roomName;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  const DeviceCard({
    super.key,
    required this.device,
    required this.roomName,
    required this.onTap,
    required this.onToggle,
  });

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.smartLamp:
        return Icons.lightbulb;
      case DeviceType.smartFan:
        return Icons.mode_fan_off;
      case DeviceType.smartPlug:
        return Icons.power;
      case DeviceType.temperatureSensor:
        return Icons.thermostat;
      case DeviceType.humiditySensor:
        return Icons.water_drop;
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Icon(_getDeviceIcon(device.type)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDeviceTypeText(device.type),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          roomName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DeviceStatusBadge(status: device.status),
                ],
              ),
              const SizedBox(height: 12),
              if (device.temperature != null)
                Text(
                    'Temperature: ${device.temperature!.toStringAsFixed(1)} °C'),
              if (device.humidity != null)
                Text('Humidity: ${device.humidity!.toStringAsFixed(1)} %'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    device.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: device.isOnline ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_canToggle(device.type))
                    Switch(
                      value: device.isOn,
                      onChanged: device.isOnline ? onToggle : null,
                    )
                  else
                    const Text(
                      'Read Only Sensor',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
