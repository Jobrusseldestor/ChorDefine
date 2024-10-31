import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode; // The current dark mode status
  final ValueChanged<bool> onDarkModeChanged; // Callback for dark mode toggle

  SettingsPage({required this.isDarkMode, required this.onDarkModeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Dark Mode Toggle
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (bool value) {
                onDarkModeChanged(value); // Call the callback to update the dark mode state
              },
            ),
          ),
          const Divider(),
          // Additional settings options can be added here
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle notification settings here
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle privacy settings here
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
