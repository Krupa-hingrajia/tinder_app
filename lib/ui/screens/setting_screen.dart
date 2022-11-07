import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/provider/theme_changer.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool valueTheme = true;

  @override
  Widget build(BuildContext context) {
    Future<void> onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
      (value) ? themeNotifier.setTheme(darkTheme) : themeNotifier.setTheme(lightTheme);
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool("darkMode", value);
    }

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTING'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            const Text('Theme'),
            const Spacer(),
            CupertinoSwitch(
                value: valueTheme,
                onChanged: (bool? value) {
                  valueTheme = value!;
                  setState(() {});
                  onThemeChanged(value, themeNotifier);
                })
          ],
        ),
      ),
    );
  }
}
