
import 'package:flutter/material.dart';

Widget mTextformFeild ({required TextEditingController mController, required mHint, TextInputType? mKeyboard}) {
 return TextFormField(
  keyboardType: mKeyboard,
  controller: mController,
  decoration: InputDecoration(
    hintText: mHint,
    border: const OutlineInputBorder()
  ),
 );
}