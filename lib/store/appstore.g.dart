// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic


mixin _$AppStore on AppStoreBase, Store {
  final _$isDarkModeOnAtom = Atom(name: 'AppStoreBase.isDarkModeOn');

  @override
  bool get isDarkModeOn {
    _$isDarkModeOnAtom.reportRead();
    return super.isDarkModeOn;
  }

  @override
  set isDarkModeOn(bool value) {
    _$isDarkModeOnAtom.reportWrite(value, super.isDarkModeOn, () {
      super.isDarkModeOn = value;
    });
  }

  final _$isHoverAtom = Atom(name: 'AppStoreBase.isHover');

  @override
  bool get isHover {
    _$isHoverAtom.reportRead();
    return super.isHover;
  }

  @override
  set isHover(bool value) {
    _$isHoverAtom.reportWrite(value, super.isHover, () {
      super.isHover = value;
    });
  }

  final _$iconColorAtom = Atom(name: 'AppStoreBase.iconColor');

  @override
  Color? get iconColor {
    _$iconColorAtom.reportRead();
    return super.iconColor;
  }

  @override
  set iconColor(Color? value) {
    _$iconColorAtom.reportWrite(value, super.iconColor, () {
      super.iconColor = value;
    });
  }

  final _$backgroundColorAtom = Atom(name: 'AppStoreBase.backgroundColor');

  @override
  Color? get backgroundColor {
    _$backgroundColorAtom.reportRead();
    return super.backgroundColor;
  }

  @override
  set backgroundColor(Color? value) {
    _$backgroundColorAtom.reportWrite(value, super.backgroundColor, () {
      super.backgroundColor = value;
    });
  }

  final _$appBarColorAtom = Atom(name: 'AppStoreBase.appBarColor');

  @override
  Color? get appBarColor {
    _$appBarColorAtom.reportRead();
    return super.appBarColor;
  }

  @override
  set appBarColor(Color? value) {
    _$appBarColorAtom.reportWrite(value, super.appBarColor, () {
      super.appBarColor = value;
    });
  }

  final _$scaffoldBackgroundAtom =
      Atom(name: 'AppStoreBase.scaffoldBackground');

  @override
  Color? get scaffoldBackground {
    _$scaffoldBackgroundAtom.reportRead();
    return super.scaffoldBackground;
  }

  @override
  set scaffoldBackground(Color? value) {
    _$scaffoldBackgroundAtom.reportWrite(value, super.scaffoldBackground, () {
      super.scaffoldBackground = value;
    });
  }

  final _$backgroundSecondaryColorAtom =
      Atom(name: 'AppStoreBase.backgroundSecondaryColor');

  @override
  Color? get backgroundSecondaryColor {
    _$backgroundSecondaryColorAtom.reportRead();
    return super.backgroundSecondaryColor;
  }

  @override
  set backgroundSecondaryColor(Color? value) {
    _$backgroundSecondaryColorAtom
        .reportWrite(value, super.backgroundSecondaryColor, () {
      super.backgroundSecondaryColor = value;
    });
  }

  final _$appColorPrimaryLightColorAtom =
      Atom(name: 'AppStoreBase.appColorPrimaryLightColor');

  @override
  Color? get appColorPrimaryLightColor {
    _$appColorPrimaryLightColorAtom.reportRead();
    return super.appColorPrimaryLightColor;
  }

  @override
  set appColorPrimaryLightColor(Color? value) {
    _$appColorPrimaryLightColorAtom
        .reportWrite(value, super.appColorPrimaryLightColor, () {
      super.appColorPrimaryLightColor = value;
    });
  }

  final _$iconSecondaryColorAtom =
      Atom(name: 'AppStoreBase.iconSecondaryColor');

  @override
  Color? get iconSecondaryColor {
    _$iconSecondaryColorAtom.reportRead();
    return super.iconSecondaryColor;
  }

  @override
  set iconSecondaryColor(Color? value) {
    _$iconSecondaryColorAtom.reportWrite(value, super.iconSecondaryColor, () {
      super.iconSecondaryColor = value;
    });
  }

  final _$textPrimaryColorAtom = Atom(name: 'AppStoreBase.textPrimaryColor');

  @override
  Color? get textPrimaryColor {
    _$textPrimaryColorAtom.reportRead();
    return super.textPrimaryColor;
  }

  @override
  set textPrimaryColor(Color? value) {
    _$textPrimaryColorAtom.reportWrite(value, super.textPrimaryColor, () {
      super.textPrimaryColor = value;
    });
  }

  final _$textSecondaryColorAtom =
      Atom(name: 'AppStoreBase.textSecondaryColor');

  @override
  Color? get textSecondaryColor {
    _$textSecondaryColorAtom.reportRead();
    return super.textSecondaryColor;
  }

  @override
  set textSecondaryColor(Color? value) {
    _$textSecondaryColorAtom.reportWrite(value, super.textSecondaryColor, () {
      super.textSecondaryColor = value;
    });
  }

  final _$toggleDarkModeAsyncAction = 
    AsyncAction('AppStoreBase.toggleDarkMode');

@override
Future<void> toggleDarkMode({bool? value}) {
  return _$toggleDarkModeAsyncAction.run(() async {
    final pref = await SharedPreferences.getInstance();
    
    isDarkModeOn = value ?? !isDarkModeOn;
    await pref.setBool('isDarkModeOn', isDarkModeOn);

    if (isDarkModeOn) {
      scaffoldBackground = appBackgroundColorDark;
      appBarColor = cardBackgroundBlackDark;
      backgroundColor = Colors.white;
      backgroundSecondaryColor = Colors.white;
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
  });
}}