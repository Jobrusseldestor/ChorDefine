import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  SettingsPage({required this.isDarkMode, required this.onDarkModeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings', 
          style: TextStyle(fontSize: 28),
        ), automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            leading: const Icon(Icons.dark_mode, size: 30),
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (bool value) {
                onDarkModeChanged(value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            leading: const Icon(Icons.groups_2, size: 30),
            title: const Text(
              'About Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> developers = [
      {"name": "Richie Paul Aquiño", "image": "assets/images/richie.jpg", "description": "Developer 1"},
      {"name": "Willie Deadio Jr.", "image": "assets/images/willie.jpg", "description": "Developer 2"},
      {"name": "Job Russel Destor", "image": "assets/images/job.jpg", "description": "Developer 3"},
      {"name": "Ron Magpantay", "image": "assets/images/ron.jpg", "description": "Developer 4"},
      {"name": "Jose Miguell Monsale", "image": "assets/images/miggy.jpg", "description": "Developer 5"},
      {"name": "Ralph Voltaire Dayot", "image": "assets/images/dayot.jpg", "description": "Thesis Adviser"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontSize: 24),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Meet the Team',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
  child: GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.8, // Made the boxes shorter
    ),
    itemCount: developers.length,
    itemBuilder: (context, index) {
      final name = developers[index]['name']!;
      final imagePath = developers[index]['image']!;
      final description = developers[index]['description']!;
      return Align(
        alignment: index == developers.length - 1 
            ? Alignment.centerRight // Center the last item
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
              'ChorDefine is developed by 5 Bachelors of Science in Information Technology students of West Visayas State University.'
              'Our mission is to developed a mobile application, that is engaging and user-friendly for guitar enthusiast that is accessible for everyone.',
              style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black,fontWeight: FontWeight.bold),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

// DeveloperCard widget to display each developer's image, name, and description
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
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
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}




// "About the App" Page
class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About the App',
          style: TextStyle(fontSize: 24),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use min size to fit the content
            children: [
              Image.asset(
                'assets/icons/logo.png', // Replace with your image path
                height: 250, // Set a suitable height
                width: 250,  // Set a suitable width
                fit: BoxFit.cover, // Adjust the image to fit the container
              ),
              const SizedBox(height: 20), // Add space between image and text
              const Text(
                'ChorDefine is an innovative mobile application specifically designed to assist beginner guitarists in mastering their instrument through real-time chord recognition. '
                'This app offers a comprehensive solution by integrating advanced computer vision and audio recognition technologies to enhance the learning experience.',
                style: TextStyle(fontSize: 20, height: 1.5, color: Colors.black,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
