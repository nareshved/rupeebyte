
import 'package:flutter/material.dart';

Widget mTextformFeild ({required TextEditingController mController, required mHint}) {
 return TextFormField(
  
  autocorrect: true,
  controller: mController,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  autofocus: true,
  spellCheckConfiguration: const SpellCheckConfiguration(misspelledSelectionColor: Colors.red),

  decoration: InputDecoration(
    hintText: mHint,
    border: const OutlineInputBorder()
  ),
 );
}