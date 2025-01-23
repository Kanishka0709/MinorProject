import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/ngo_search_page.dart';
import 'pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PashuRakshakApp());
}

class PashuRakshakApp extends StatelessWidget {
  const PashuRakshakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pashu Rakshak',
      theme: ThemeData(
        // Earthy color scheme
        primaryColor: const Color(0xFF8B7355), // Brown
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B7355),
          secondary: const Color(0xFF9B8B7A), // Light brown
          tertiary: const Color(0xFF6B8E23), // Olive green
          background: const Color(0xFFF5F5DC), // Beige
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('userName') ?? '';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(username: _username),
      const NGOSearchPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find NGOs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

// NGO Search Page
class NGOSearchPage extends StatelessWidget {
  const NGOSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find NGOs'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('NGO Search Content'),
      ),
    );
  }
}
