import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/Auth/logIn_screen.dart';
import 'package:yumfood/main.dart';
import 'package:yumfood/resources.dart/images/food_colors.dart';
import 'package:yumfood/resources.dart/images/foodimages.dart';
import 'package:yumfood/resources.dart/strings.dart';
import 'package:yumfood/resources.dart/widgets.dart';

class FoodSignIn extends StatefulWidget {
  static String tag = '/FoodSignIn';

  @override
  FoodSignInState createState() => FoodSignInState();
}

class FoodSignInState extends State<FoodSignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: "18163915577-bnf0qkac9ngkaeai9sus6ln55sr30fnl.apps.googleusercontent.com",
  );

  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return; // User canceled sign-in

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _auth.signInWithCredential(credential);
    print("Google User: ${userCredential.user?.displayName}");
  } catch (e) {
    print("Error during Google Sign-In: $e");
  }
}

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        print("Facebook User: ${userCredential.user?.displayName}");
      } else {
        print("Facebook Sign-In Failed: ${result.message}");
      }
    } catch (e) {
      print("Error during Facebook Sign-In: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget mOption(Color color, String icon, String value, Color iconColor, Color valueColor, Function() onTap) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: 16),
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: SvgPicture.asset(icon, color: iconColor, width: 18, height: 18),
                  ),
                ),
                TextSpan(text: value, style: primaryTextStyle(size: 16, color: valueColor)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          CachedNetworkImage(
            placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
            imageUrl: food_ic_login,
            height: width * 0.6,
            fit: BoxFit.cover,
            width: width,
          ),
          Container(
            margin: EdgeInsets.only(top: width * 0.5),
            child: Stack(
              children: <Widget>[
                Arc(
                  arcType: ArcType.CONVEX,
                  edge: Edge.TOP,
                  height: (MediaQuery.of(context).size.width) / 10,
                  child: Container(
                    height: (MediaQuery.of(context).size.height),
                    width: MediaQuery.of(context).size.width,
                    color: food_color_green,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: appStore.isDarkModeOn ? scaffoldDarkColor : food_white),
                    width: width * 0.13,
                    height: width * 0.13,
                    child: Icon(Icons.arrow_forward, color: appStore.isDarkModeOn ? white : food_textColorPrimary),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: width * 0.1),
                      Text(food_app_name, style: boldTextStyle(color: food_white, size: 30)),
                      SizedBox(height: width * 0.12),
                      mOption(
                        appStore.isDarkModeOn ? black : food_white,
                        food_ic_google_fill,
                        food_lbl_google,
                        appStore.isDarkModeOn ? white : food_color_red,
                        appStore.isDarkModeOn ? white : food_textColorPrimary,
                        signInWithGoogle,
                      ),
                      mOption(
                        food_colorPrimary,
                        food_ic_fb,
                        food_lbl_facebook,
                        food_white,
                        food_white,
                        signInWithFacebook,
                      ),
                      SizedBox(height: width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(height: 0.5, color: food_white, width: width * 0.07, margin: EdgeInsets.only(right: 4)),
                          Text(food_lbl_or_use_your_mobile_email.toUpperCase(), style: primaryTextStyle(color: food_white, size: 14)),
                          Container(height: 0.5, color: food_white, width: width * 0.07, margin: EdgeInsets.only(left: 4)),
                        ],
                      ),
                      SizedBox(height: width * 0.07),
                      GestureDetector(
                        onTap: () {
                          FoodCreateAccount().launch(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(color: food_color_green, border: Border.all(color: white), borderRadius: BorderRadius.circular(50)),
                          width: width,
                          padding: EdgeInsets.all(10),
                          child: Text(food_lbl_continue_with_email_mobile, style: primaryTextStyle(color: food_white)).center(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
