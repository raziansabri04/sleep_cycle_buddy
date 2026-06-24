import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

class RingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;
  const RingScreen({super.key, required this.alarmSettings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101225),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.alarm, color: Color(0xFFFFB95A), size: 80),
            const SizedBox(height: 20),
            const Text(
              "Wake Up! ☀️",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () async {
                await Alarm.stop(alarmSettings.id);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
              ),
              child: const Text("MATIKAN ALARM", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}