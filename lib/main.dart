import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_cycle_buddy/screens/dashboard_screen.dart';
import 'package:sleep_cycle_buddy/screens/sleep_log_screen.dart';
import 'package:sleep_cycle_buddy/screens/insight_screen.dart';
import 'package:sleep_cycle_buddy/screens/relax_screen.dart';
import 'package:sleep_cycle_buddy/screens/profile_screen.dart';
import 'package:sleep_cycle_buddy/screens/login_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:alarm/alarm.dart';
import 'package:sleep_cycle_buddy/screens/ring_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // 1. Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  final currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));

  await Alarm.init();

  // 2. Inisialisasi Firebase dengan opsi sesuai platform (Android/iOS)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Listener: setiap alarm bunyi, otomatis pindah ke RingScreen
  Alarm.ringing.listen((alarmSet) {
    for (final alarm in alarmSet.alarms) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => RingScreen(alarmSettings: alarm)),
      );
    }
  });

  runApp(const SleepCycleApp());
}

class SleepCycleApp extends StatelessWidget {
  const SleepCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'SleepCycle Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // Menggunakan Warna Utama Anda (#101225)
        scaffoldBackgroundColor: const Color(0xFF101225),

        // Menggunakan Warna Aksen Anda (#FFB95A)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB95A),
          primary: const Color(0xFFFFB95A),
          secondary: const Color(0xFFC8C5CE), // Warna Pendukung
          brightness: Brightness.dark,
        ),

        // Menggunakan Font Plus Jakarta Sans
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),

        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final List<Widget> _screens = [
      // Kirim perintah pindah ke index 3 (Relax) melalui DashboardScreen
      DashboardScreen(onStartSleeping: () {
        setState(() {
          _selectedIndex = 3;
        });
      }),
      const SleepLogScreen(),
      const InsightScreen(),
      const RelaxScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1C2E), // Sedikit lebih terang dari bg utama
        selectedItemColor: const Color(0xFFFFB95A), // Warna Aksen
        unselectedItemColor: const Color(0xFFC8C5CE), // Warna Pendukung
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Log'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Relax'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}