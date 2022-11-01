import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/routing/router.dart';

import 'core/routing/locator/locator.dart';
import 'core/routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setLocator();
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: Routes.splashScreen,
      initialRoute: Routes.homeScreen,
      onGenerateRoute: PageRouter.generateRoutes,
    );
  }
}
