

import 'package:flutter/material.dart';

import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'appstore.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool isDarkModeOn = false;

  @observable
  bool isHover = false;

  @observable
  Color? iconColor;

  @observable
  Color? backgroundColor;

  @observable
  Color? appBarColor;

  @observable
  Color? scaffoldBackground;

  @observable
  Color? backgroundSecondaryColor;

  @observable
  Color? appColorPrimaryLightColor;

  @observable
  Color? iconSecondaryColor;

  @observable
  Color? textPrimaryColor;

  @observable
  Color? textSecondaryColor;

  @action
Future<void> toggleDarkMode({bool? value}) async {
  final pref = await SharedPreferences.getInstance();
  
  isDarkModeOn = value ?? !isDarkModeOn;
  await pref.setBool('isDarkModeOn', isDarkModeOn); // Save to storage

  if (isDarkModeOn) {
    scaffoldBackground = appBackgroundColorDark;
    appBarColor = cardBackgroundBlackDark;
    backgroundColor = Colors.black;
    backgroundSecondaryColor = Colors.blueGrey;
    appColorPrimaryLightColor = cardBackgroundBlackDark;
    
    iconColor = iconColorPrimary;
    iconSecondaryColor = iconColorSecondary;

    textPrimaryColor = whiteColor;
    textSecondaryColor = Colors.white54;

    textPrimaryColorGlobal = whiteColor;
    textSecondaryColorGlobal = Colors.white54;
    shadowColorGlobal = appShadowColorDark;
  } else {
    scaffoldBackground = scaffoldLightColor;
    appBarColor = Colors.white;
    backgroundColor = Colors.black;
    backgroundSecondaryColor = appSecondaryBackgroundColor;
    appColorPrimaryLightColor = appColorPrimaryLight;

    iconColor = iconColorPrimaryDark;
    iconSecondaryColor = iconColorSecondaryDark;

    textPrimaryColor = appTextColorPrimary;
    textSecondaryColor = appTextColorSecondary;

    textPrimaryColorGlobal = appTextColorPrimary;
    textSecondaryColorGlobal = appTextColorSecondary;
    shadowColorGlobal = appShadowColor;
  }

  setStatusBarColor(scaffoldBackground!);
}
}