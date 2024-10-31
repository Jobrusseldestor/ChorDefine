import 'package:flutter/material.dart';
import 'settingspage.dart';
import 'package:chordefine/screens/featuerd_screen.dart';
import 'package:chordefine/constants/color.dart';
import 'package:chordefine/constants/size.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false; // This controls whether dark mode is active

  // Define a method to handle page selection
  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return FeaturedScreen();  // Featured page
      case 1:
        return Center(child: Text("My Learning", style: TextStyle(fontSize: 24)));  // My Learning page placeholder
      case 2:
        return SettingsPage(
          isDarkMode: _isDarkMode, 
          onDarkModeChanged: (bool value) {
            setState(() {
              _isDarkMode = value; // Update the dark mode state
            });
          },
        );  // Settings page
      default:
        return FeaturedScreen();  // Default to FeaturedScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(), // Apply theme based on dark mode state
      home: Scaffold(
        body: _getSelectedPage(), // Show selected page based on _selectedIndex
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                'assets/icons/star.png',
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                'assets/icons/play_outlined.png',
                height: kBottomNavigationBarItemSize,
              ),
              label: "Featured",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                'assets/icons/play.png',
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                'assets/icons/play_outlined.png',
                height: kBottomNavigationBarItemSize,
              ),
              label: "My Learning",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                'assets/icons/settings.png',
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                'assets/icons/settings_outlined.png',
                height: kBottomNavigationBarItemSize,
              ),
              label: "Settings",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
