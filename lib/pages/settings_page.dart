import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/dark_theme_manager/dark_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.white30,
              child: Icon(Icons.light),
              ),
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: context.watch<ThemeProvider>().themeValue,
                onChanged: (value) {
                  context.read<ThemeProvider>().themeValue = value;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
