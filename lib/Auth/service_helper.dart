import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthServiceHelper{
 
  static Future<String> createAccountWithEmail(
      String input, String password) async {
    try {

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: input, password: password);
      
      return 'Account Created';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();}
  }
      

  //login
  static Future<String> loginWithEmail(String input, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: input, password: password);
      return 'Login Successful.';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future logout()async{
    try{
      await FirebaseAuth.instance.signOut();
    }on FirebaseAuthException catch(e){
      return e.message.toString();
    }

  }
// check user

static Future<bool>isUserLoggedin()async{

var currentUser =FirebaseAuth.instance.currentUser;
return currentUser!=null ? true:false;
}
}

class Message{

  static void show({
    String message ='Done !',
    ToastGravity gravity = ToastGravity.BOTTOM,
       int timeInSecForIosWeb =1,
       Color backgroundColor= const Color.fromARGB(255, 211, 25, 180),
        Color textColor= const Color.fromARGB(255, 7, 1, 1),
        double fontSize= 16.0,

  })
  {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }

  
}