import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  SettingsPage({required this.isDarkMode, required this.onDarkModeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassMorphicAppBar(title: 'Settings',),
      body: Stack(
        children: [
          _buildGlassMorphicContainer(),
          ListView(
            padding: const EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0),
            children: [
              const Divider(),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                leading: const Icon(Icons.groups_2, size: 30),
                title: const Text(
                  'About Us',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                leading: const Icon(Icons.contact_support, size: 30),
                title: const Text(
                  'About the App',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutAppPage(),
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}

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
            style: const TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(245, 245, 110, 15),
          elevation: 0,
        ),
      ),
    );
  }
}

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
                
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: developers.length,
                    itemBuilder: (context, index) {
                      final name = developers[index]['name']!;
                      final imagePath = developers[index]['image']!;
                      final description = developers[index]['description']!;
                      return Align(
                        alignment: index == developers.length - 1
                            ? Alignment.centerRight
                            : Alignment.topCenter,
                        child: DeveloperCard(
                          name: name,
                          imagePath: imagePath,
                          description: description,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'ChordDefine is developed by five BSIT students at West Visayas State University. '
                  'Our mission is to create an accessible, engaging, and user-friendly mobile application for guitar enthusiasts.',
                  style: TextStyle(fontSize: 16, height: 1.5, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                  const SizedBox(height: 20),
                  const Text(
                    'ChordDefine is an innovative mobile application specifically designed to assist beginner guitarists in mastering their instrument through real-time chord recognition. '
                    'This app offers a comprehensive solution by integrating advanced computer vision and audio recognition technologies to enhance the learning experience.',
                    style: TextStyle(fontSize: 20, height: 1.5, color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
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

Widget _buildGlassMorphicContainer() {
  return Container(
    decoration: BoxDecoration(
      color: Color.fromARGB(255,255,255,255),
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