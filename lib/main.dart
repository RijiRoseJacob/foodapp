import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumfood/UI/foodWalksThrough.dart';
import 'package:yumfood/firebase_options.dart';
import 'package:yumfood/store/appstore.dart';

final AppStore appStore = AppStore();
       

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final pref = await SharedPreferences.getInstance();
  bool isDarkMode = pref.getBool('isDarkModeOn') ?? false;

  appStore.toggleDarkMode(value: isDarkMode); 

  
  runApp(const MyApp());
}
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YumFood',
      home: FoodWalkThrough(),
    );}}
      