import 'package:get_it/get_it.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/login_screen_view_model.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/splash_screen_view_model.dart';

var locator = GetIt.instance;

setLocator() {
  locator.registerLazySingleton(() => SplashScreenViewModel());
  locator.registerLazySingleton(() => LoginScreenViewModel());
}
