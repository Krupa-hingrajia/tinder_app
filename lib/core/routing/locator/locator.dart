import 'package:get_it/get_it.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/all_screen_bottom_view_model.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/chat_screen_view_model.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/home_screen_view_model.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/login_screen_view_model.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/profile_screen_view_model.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/setting_screen_view_model.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/signup_screen_view_model.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/splash_screen_view_model.dart';


var locator = GetIt.instance;

setLocator() {
  locator.registerLazySingleton(() => SplashScreenViewModel());
  locator.registerLazySingleton(() => LoginScreenViewModel());
  locator.registerLazySingleton(() => SignUpScreenViewModel());
  locator.registerLazySingleton(() => AllScreenBottomViewModel());
  locator.registerLazySingleton(() => HomeScreenViewModel());
  locator.registerLazySingleton(() => ProfileScreenViewModel());
  locator.registerLazySingleton(() => SettingScreenViewModel());
  locator.registerLazySingleton(() => ChatScreenViewModel());
}
