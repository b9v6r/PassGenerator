import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'dart:io' as io;

import 'buttons/exit_btn.dart';
import 'buttons/generate_btn.dart';
import 'buttons/author_btn.dart';
import 'buttons/copy_btn.dart';
import 'buttons/theme_btn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    final newThemeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newThemeMode == ThemeMode.dark);
    setState(() {
      _themeMode = newThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator',
      theme: ThemeData.light(), // Светлая тема
      darkTheme: ThemeData.dark(), // Тёмная тема
      themeMode: _themeMode, // Управление темой
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Password Generator',
        onThemeChange: _toggleTheme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.onThemeChange});

  final String title;
  final VoidCallback onThemeChange;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _password = '';

  void _generatePassword() {
    setState(() {
      _password = _generateRandomPassword();
    });
  }

  void _exitFunc() {
    if (io.Platform.isWindows) {
      io.exit(0);
    } else {
      SystemNavigator.pop();
    }
  }

  void _copyFunc() {
    if (_password.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _password));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password copied to clipboard')),
      );
    }
  }

  Future<void> _authorFunc() async {
    final Uri url = Uri.parse('https://taplink.cc/b9v6r');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  String _generateRandomPassword() {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+[]{}|;:,.<>?';
    Random rnd = Random();
    int length = 8 + rnd.nextInt(9); // Генерирует случайное число от 8 до 16
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 144, 239, 177),
        foregroundColor: Colors.black,
        title: Text(widget.title),
        centerTitle: true,
        leading: ThemeButton(onPressed: widget.onThemeChange),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your password:',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 22.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _password,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            CopyButton(onPressed: _copyFunc),
            const SizedBox(height: 30),
            GenerateButton(onPressed: _generatePassword),
            const SizedBox(height: 30),
            AuthorButton(onPressed: _authorFunc),
            const SizedBox(height: 30),
            ExitButton(onPressed: _exitFunc),
          ],
        ),
      ),
    );
  }
}
