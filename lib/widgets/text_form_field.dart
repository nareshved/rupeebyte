
import 'package:flutter/material.dart';

Widget mTextformFeild ({required TextEditingController mController, required mHint}) {
 return TextFormField(
  controller: mController,
  decoration: InputDecoration(
    hintText: mHint,
    border: const OutlineInputBorder()
  ),
 );
}