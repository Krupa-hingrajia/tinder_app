import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/provider/theme_changer.dart';
import 'core/routing/locator/locator.dart';
import 'core/routing/router.dart';
import 'core/routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setLocator();

  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool("darkMode") ?? true;

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (context) {
            return ThemeNotifier(darkModeOn ? darkTheme : lightTheme);
          },
        ),
      ],
      builder: (context, child) {
        return const Myapp();
      },
    ));
  });
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),
      debugShowCheckedModeBanner: false,
      // initialRoute: Routes.splashScreen,
      // initialRoute: Routes.allScreenBottom,
      initialRoute: Routes.allScreenBottom,
      onGenerateRoute: PageRouter.generateRoutes,
    );
  }
}
