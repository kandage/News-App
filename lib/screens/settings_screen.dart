import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/state_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text('Dark Theme'),
          value: newsProvider.isDarkTheme,
          onChanged: (bool value) {
            newsProvider.toggleTheme();
          },
        ),
      ),
    );
  }
}
