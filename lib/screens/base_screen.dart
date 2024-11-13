import 'dart:ui';
import 'package:chordefine/screens/major.dart';
import 'package:chordefine/screens/progress.dart';
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
  bool _isDarkMode = false;

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return const FeaturedScreen();
      case 1:
        return const MyProgress();
      case 2:
        return SettingsPage(
          isDarkMode: _isDarkMode,
          onDarkModeChanged: (bool value) {
            setState(() {
              _isDarkMode = value;
            });
          },
        );
      default:
        return const FeaturedScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        extendBody: true, // Extends the body behind the bottom navigation bar for transparency
        body: Stack(
          children: [
            _buildGlassMorphicBackground(), // Adds glassmorphic effect to background
            _getSelectedPage(),
          ],
        ),
        bottomNavigationBar: _buildGlassMorphicBottomNavigationBar(),
      ),
    );
  }

  Widget _buildGlassMorphicBackground() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(247, 194, 89, 4).withOpacity(0.2), // Set color with opacity
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Blur for glass effect
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildGlassMorphicBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(245, 245, 110, 15).withOpacity(1), // Glassmorphic color with opacity
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: Colors.white70,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  'assets/icons/star.png',
                  height: kBottomNavigationBarItemSize,
                ),
                icon: Image.asset(
                  'assets/icons/star.png',
                  height: kBottomNavigationBarItemSize,
                ),
                label: "Featured",
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  'assets/icons/heart.png',
                  height: kBottomNavigationBarItemSize,
                ),
                icon: Image.asset(
                  'assets/icons/heart.png',
                  height: kBottomNavigationBarItemSize,
                ),
                label: "Progress",
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  'assets/icons/settings.png',
                  height: kBottomNavigationBarItemSize,
                ),
                icon: Image.asset(
                  'assets/icons/settings.png',
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
      ),
    );
  }
}
