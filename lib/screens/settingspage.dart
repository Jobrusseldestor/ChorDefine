import 'dart:ui';
import 'package:flutter/material.dart';

// Main function to run the app

// SettingsPage with styled buttons for navigation
class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  SettingsPage({required this.isDarkMode, required this.onDarkModeChanged});

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassMorphicAppBar(title: 'Settings'),
      body: Stack(
        children: [
          _buildGlassMorphicContainer(),
          Padding(
            padding: EdgeInsets.only(top: appBarHeight + statusBarHeight), // Add padding to account for AppBar height
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 350),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Reduced vertical padding
                  children: [
                    _buildButton(
                      context: context,
                      label: 'About Us',
                      icon: Icons.groups_2,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutUsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildButton(
                      context: context,
                      label: 'About the App',
                      icon: Icons.contact_support,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutAppPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.orange),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Custom GlassMorphicAppBar for a frosted glass effect
class GlassMorphicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const GlassMorphicAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(245, 245, 110, 15),
          elevation: 0,
        ),
      ),
    );
  }
}

// AboutUsPage with sample developer info
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> developers = [
      {"name": "Richie Paul Aquiño", "image": "assets/images/richie.jpeg", "description": "Developer 1"},
      {"name": "Willie Deadio Jr.", "image": "assets/images/willie.jpg", "description": "Developer 2"},
      {"name": "Job Russel Destor", "image": "assets/images/job.jpg", "description": "Developer 3"},
      {"name": "Ron Philip Magpantay", "image": "assets/images/ron.jpg", "description": "Developer 4"},
      {"name": "Jose Miguell Monsale", "image": "assets/images/miggy.jpg", "description": "Developer 5"},
      {"name": "Ralph Voltaire Dayot", "image": "assets/images/dayot.jpg", "description": "Thesis Adviser"},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassMorphicAppBar(title: 'About Us'),
      body: Stack(
        children: [
          _buildGlassMorphicContainer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: developers.length,
                    itemBuilder: (context, index) {
                      final name = developers[index]['name']!;
                      final imagePath = developers[index]['image']!;
                      final description = developers[index]['description']!;
                      return DeveloperCard(
                        name: name,
                        imagePath: imagePath,
                        description: description,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    'ChordDefine is developed by five BSIT students at West Visayas State University. '
                    'Our mission is to create an accessible, engaging, and user-friendly mobile application for guitar enthusiasts.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// DeveloperCard widget for displaying developer information
class DeveloperCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String description;

  const DeveloperCard({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(245, 255, 248, 243),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// AboutAppPage with placeholder content
class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassMorphicAppBar(title: 'About the App'),
      body: Stack(
        children: [
          _buildGlassMorphicContainer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 90.0, 16.0, 16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/logo.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Text(
                      'ChordDefine is an innovative mobile application specifically designed to assist beginner guitarists in mastering their instrument through real-time chord recognition. '
                      'This app offers a comprehensive solution by integrating advanced computer vision and audio recognition technologies to enhance the learning experience.',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// Helper function for the glass-morphic effect background
Widget _buildGlassMorphicContainer() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ),
    ),
  );
}
