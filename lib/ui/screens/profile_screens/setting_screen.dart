import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder_app_new/core/constant/text_style_constant.dart';
import 'package:tinder_app_new/core/provider/theme_changer.dart';
import 'package:tinder_app_new/core/routing/routes.dart';
import 'package:tinder_app_new/core/view_model/base_view.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/view_model/screens_view_model/profile_screen_view_models/setting_screen_view_model.dart';
import 'package:tinder_app_new/ui/widget/custom_drop_down.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingScreenViewModel? model;
  bool isSwitchedFT = true;
  bool? valueTheme;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSwitchValues();
  }

  getSwitchValues() async {
    isSwitchedFT = (await getSwitchState())!;
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("switchState", value);
  }

  Future<bool?> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitchedFT = prefs.getBool("switchState");
    return isSwitchedFT;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
      (value) ? themeNotifier.setTheme(darkTheme) : themeNotifier.setTheme(lightTheme);
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool('darkMode', value);
    }

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return BaseView<SettingScreenViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SETTING'),
            centerTitle: true,
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
              colors: <Color>[ColorConstant.yellowLight, ColorConstant.greenLight],
            ))),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_outlined)),
          ),
          body: Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Change Theme', style: TextStyleConstant.settingTheme),
                    const Spacer(),
                    Switch(
                        activeColor: Colors.blue,
                        value: valueTheme ?? false,
                        onChanged: (bool? value) {
                          valueTheme = value!;
                          setState(() {});
                          onThemeChanged(value, themeNotifier);
                        })
                  ],
                ),
                const Divider(),
                Row(children: [
                  const Text('Show me', style: TextStyleConstant.settingGender),
                  const Spacer(),
                  dropDownWidget(
                    context: context,
                    topHeight: 0,
                    decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                    icon: const Icon(Icons.arrow_forward_ios, size: 20),
                    width: MediaQuery.of(context).size.width * 0.27,
                    height: MediaQuery.of(context).size.height * 0.056,
                    categoryList: model.dropDnwList,
                    hintText: model.genderGet ?? 'All',
                    dropDownValue: model.selectValue,
                    onChanged: (value) {
                      model.selectValue = value;
                      model.setDate();
                      setState(() {});
                    },
                  ),
                ]),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Row(
                    children: [
                      const Text('Age range', style: TextStyleConstant.settingAgeRange),
                      const Spacer(),
                      Text('${model.ageValue ?? model.ageValueGet}', style: const TextStyle(fontSize: 18))
                    ],
                  ),
                ),
                RangeSlider(
                  activeColor: Colors.blue,
                  values: RangeValues(model.ageRange.start, model.ageRange.end),
                  max: 100,
                  divisions: 20,
                  labels: RangeLabels(model.ageRange.start.round().toString(), model.ageRange.end.round().toString()),
                  onChanged: (RangeValues values) async {
                    setState(() {
                      model.ageRange = values;
                      model.ageValue =
                          model.ageRange.toString().split('(')[1].split(')')[0].replaceAll(RegExp(r','), ' -');
                      print('AGEEE :- ${model.ageValue}');
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('ageRange', model.ageValue.toString());
                    prefs.setStringList(
                        'sliderGain', [model.ageRange.start.round().toString(), model.ageRange.end.round().toString()]);
                  },
                ),
                const Divider(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(.05), borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("Show me on Tinder", style: TextStyleConstant.settingShowTinder),
                            const Spacer(),
                            Switch(
                              activeColor: Colors.blue,
                              value: isSwitchedFT,
                              onChanged: (value) {
                                isSwitchedFT = value;
                                saveSwitchState(value);
                                model.showMeOnTinder(model.loginId!);
                                print('isSwitchedFT  :: > $isSwitchedFT');
                                setState(() {});
                              },
                            )
                          ],
                        ),
                        const Text(
                            'while turned off, you will not be shown in the card Stack. you can stil see your matches and chat with them.')
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const Divider(),
                IconButton(
                    onPressed: () async {
                      /// LOG OUT
                      Navigator.pushNamed(context, Routes.loginScreen);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('seen', false);
                    },
                    icon: const Icon(Icons.logout, size: 28)),
                const SizedBox(height: 2),
              ],
            ),
          ),
        );
      },
      onModelReady: (model) {
        model.getDate();
        this.model = model;
      },
    );
  }
}
