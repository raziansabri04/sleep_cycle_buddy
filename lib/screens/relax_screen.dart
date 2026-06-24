import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:audioplayers/audioplayers.dart';
import 'package:alarm/alarm.dart';

class RelaxScreen extends StatefulWidget {
  const RelaxScreen({super.key});

  @override
  State<RelaxScreen> createState() => _RelaxScreenState();
}

class _RelaxScreenState extends State<RelaxScreen> {
  final user = FirebaseAuth.instance.currentUser;

  // 1. Inisialisasi Plugin Notifikasi
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AudioPlayer _audioPlayer = AudioPlayer();

  TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 30);

  String selectedAlarmSound = "Custom Alarm Suara 1"; // Default
  final List<String> alarmSounds = [
    "Custom Alarm Suara 1",      // Ini yang akan memicu alarm_suara1
    "System Default Alarm",
    "System Default Notification"
  ];

  bool isPlayingRain = false;
  double rainVolume = 0.6;
  bool isPlayingOcean = false;

  @override
  void initState() {
    super.initState();
    _setupNotifications(); // Inisialisasi sistem notifikasi saat buka halaman
    _loadAlarmFromFirebase();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Mematikan mesin audio saat aplikasi ditutup
    super.dispose();
  }

  void _showSoundPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1C2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Alarm Sound", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              ...alarmSounds.map((sound) => ListTile(
                title: Text(sound, style: TextStyle(color: selectedAlarmSound == sound ? const Color(0xFFFFB95A) : Colors.white)),
                trailing: selectedAlarmSound == sound ? const Icon(Icons.check, color: Color(0xFFFFB95A)) : null,
                onTap: () {
                  setState(() => selectedAlarmSound = sound);
                  _saveAlarmSoundToFirebase(sound); // <--- Tambahkan pemanggilan fungsi ini
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleRain() async {
    if (isPlayingRain) {
      await _audioPlayer.stop();
    } else {
      // Pastikan nama file sesuai dengan yang di pubspec.yaml
      await _audioPlayer.play(AssetSource('audio/rain.mp3'));
      await _audioPlayer.setVolume(rainVolume);
    }
    setState(() {
      isPlayingRain = !isPlayingRain;
    });
  }

  // 2. FUNGSI SETUP AWAL NOTIFIKASI
  Future<void> _setupNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    // 1. Buat Channel secara resmi di sistem Android
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'sleep_alarm_channel_v4',
      'SleepCycle Alarm',
      description: 'Saluran untuk alarm bangun pagi',
      importance: Importance.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('alarm_suara1'),
      enableVibration: true,
    );

    await androidPlugin?.createNotificationChannel(channel);

    // 2. Minta izin pop-up
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  // 3. FUNGSI PENJADWALAN ALARM (PAKAI PACKAGE alarm)
  Future<void> _scheduleAlarm(TimeOfDay time) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: 42,
      dateTime: scheduledDate,
      assetAudioPath: 'assets/audio/alarm_suara1.mp3',
      loopAudio: true,
      vibrate: true,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: const Duration(seconds: 5),
        volumeEnforced: true,
      ),
      notificationSettings: const NotificationSettings(
        title: 'Wake Up! ☀️',
        body: 'Saatnya bangun dan mulai hari yang hebat!',
        stopButton: 'Matikan Alarm',
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alarm Scheduled!")),
      );
    }
  }

  Future<void> _testInstant() async {
    final alarmSettings = AlarmSettings(
      id: 99,
      dateTime: DateTime.now().add(const Duration(seconds: 5)),
      assetAudioPath: 'assets/audio/alarm_suara1.mp3',
      loopAudio: true,
      vibrate: true,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: const Duration(seconds: 3),
        volumeEnforced: true,
      ),
      notificationSettings: const NotificationSettings(
        title: 'Tes Alarm',
        body: 'Alarm akan bunyi dalam 5 detik',
        stopButton: 'Matikan Alarm',
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      _saveAlarmToFirebase(picked);
      _scheduleAlarm(picked); // <--- AKTIFKAN PENJADWALAN SAAT JAM DIPILIH
    }
  }

  Future<void> _saveAlarmToFirebase(TimeOfDay time) async {
    try {
      String timeStr = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'alarmTime': timeStr,
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Alarm Scheduled!")));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _loadAlarmFromFirebase() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    if (doc.exists && doc.data()?['alarmTime'] != null) {
      String timeStr = doc.data()?['alarmTime'];
      List<String> parts = timeStr.split(':');
      setState(() {
        selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      });
    }
  }

  Future<void> _saveAlarmSoundToFirebase(String soundName) async {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      'selectedSound': soundName,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex')),
                const SizedBox(width: 12),
                Text("Good evening, ${user?.displayName ?? 'User'}", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 30),
            Text("Gentle Wake Alarm", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            /*ElevatedButton(
              onPressed: _testInstant,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("KLIK UNTUK TES SUARA SEKARANG", style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
            const SizedBox(height: 10),*/

            GestureDetector(
              onTap: _pickTime,
              child: _buildAlarmCard(formattedTime),
            ),
            const SizedBox(height: 30),
            Text("Relaxation Sounds", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildSoundCard(
              title: "Rain",
              subtitle: "Soft pitter on a window",
              icon: Icons.umbrella,
              isPlaying: isPlayingRain,
              volume: rainVolume,
              onPlayTap: _toggleRain, // <--- Hubungkan fungsi toggle
              onVolumeChanged: (val) {
                setState(() {
                  rainVolume = val;
                });
                _audioPlayer.setVolume(val); // <--- Ubah volume secara real-time
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmCard(String time) {
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Icon(Icons.alarm, color: Color(0xFFFFB95A), size: 20)],
          ),
          Text(time, style: GoogleFonts.plusJakartaSans(fontSize: 56, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const Text("Tap to set alarm time", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 20),
          _buildSoundSelector(),
        ],
      ),
    );
  }

  Widget _buildSoundSelector() {
    return GestureDetector(
      onTap: _showSoundPicker, // <--- TAMBAHKAN INI AGAR BISA DIKLIK
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xFF252841), borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.music_note, size: 16, color: Color(0xFFFFB95A)),
            const SizedBox(width: 8),
            // GANTI TEKS STATIS MENJADI VARIABEL selectedAlarmSound
            Text(selectedAlarmSound, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundCard({required String title, required String subtitle, required IconData icon, required bool isPlaying, required double volume, required VoidCallback onPlayTap, required ValueChanged<double> onVolumeChanged}) {
    return Container(
      padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF1A1C2E), borderRadius: BorderRadius.circular(24)),
      child: Column(children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF252841), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: const Color(0xFFFFB95A))),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11))])),
          IconButton(onPressed: onPlayTap, icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled), color: const Color(0xFFFFB95A), iconSize: 40)
        ]),
        const SizedBox(height: 10),
        Row(children: [
          const Text("VOLUME", style: TextStyle(fontSize: 8, color: Colors.grey)),
          Expanded(child: Slider(value: volume, activeColor: const Color(0xFFFFB95A), onChanged: onVolumeChanged)),
          Text("${(volume * 100).toInt()}%", style: const TextStyle(fontSize: 8, color: Colors.grey)),
        ])
      ]),
    );
  }
}