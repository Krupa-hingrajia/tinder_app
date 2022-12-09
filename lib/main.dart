import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/provider/theme_changer.dart';
import 'core/routing/locator/locator.dart';
import 'core/routing/router.dart';
import 'core/routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setLocator();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool("darkMode") ?? false;  //true;

    runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (context) {
        return ThemeNotifier(darkModeOn ? darkTheme : lightTheme);
      },
      builder: (context, child) {
        return const Myapp();
      },
    ));
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("call background");
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return OverlaySupport(
      child: MaterialApp(
        theme: themeNotifier.getTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splashScreen,
        // initialRoute: Routes.signupScreen,
        // initialRoute: Routes.allScreenBottom,
        // initialRoute: Routes.settingScreen,
        onGenerateRoute: PageRouter.generateRoutes,
      ),
    );
  }
}
