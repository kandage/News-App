import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestMicrophonePermission(); // Request microphone permission on startup
  runApp(MyApp());
}

Future<void> requestMicrophonePermission() async {
  var status = await Permission.microphone.status;
  if (status
      .isDenied) { // We didn't ask for permission yet or the permission has been denied before but not permanently.
    await Permission.microphone.request();
  } else if (status
      .isPermanentlyDenied) { // The permission has been permanently denied, open app settings.
    await openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
      NewsProvider()
        ..loadTheme(),
      child: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          return MaterialApp(
            title: 'News App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white, // Light background color
                selectedItemColor: Colors.blue, // Highlight selected item
                unselectedItemColor: Colors.grey, // Grey for unselected items
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.black, // Dark background color
                selectedItemColor: Colors.white, // Highlight selected item
                unselectedItemColor:
                Colors.white70, // Grey for unselected items
              ),
            ),
            themeMode:
            newsProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
