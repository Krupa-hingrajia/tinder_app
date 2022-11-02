import 'package:tinder_app_new/core/view_model/base_model.dart';
import 'package:tinder_app_new/ui/screens/all_screen_bottom.dart';
import 'package:tinder_app_new/ui/screens/home_screen.dart';
import 'package:tinder_app_new/ui/screens/setting_screen.dart';

class AllScreenBottomViewModel extends BaseModel {
  int pageIndex = 0;

  final pages = [
    const HomeScreen(),
    const Page2(),
    SettingScreen(/*screenArguments: ProfileData(name: nameController.text)*/),
  ];
}
