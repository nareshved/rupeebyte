import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  static const String isDarkPrefsKey = "isDark";

  bool get themeValue {
    updateThemeOnStart();
    return _isDark;
  }

  set themeValue(bool value) {
    _isDark = value;

    updateThemeInPrefs(value);
    notifyListeners();
  }

  updateThemeInPrefs(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(isDarkPrefsKey, value);
  }

  updateThemeOnStart() async {
    var prefs = await SharedPreferences.getInstance();
    var isDarkPrefs = prefs.getBool(isDarkPrefsKey);

    if (isDarkPrefs != null) {
      _isDark = isDarkPrefs;
    } else {
      _isDark = false;
    }
    notifyListeners();
  }
}
 



// // high order function

// void myFun ( Function (int, int) mfun){
//  print (myfun (5,6));
// }

// void show(){
//   print('enter a value:');
//   int a = Stdin.readlinesync()!;
  
// }

// void add(int a, int b){

//   myFun(show(10,20));
//   print(a+b);
// }

// // nested func 
// // onPressweed: (){}

// // void main (){
// //  runApp()
// //}