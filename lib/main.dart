import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/routing/router.dart';

import 'core/routing/locator/locator.dart';
import 'core/routing/routes.dart';

void main() {
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
      initialRoute: Routes.splashScreen,
      onGenerateRoute: PageRouter.generateRoutes,
    );
  }
}