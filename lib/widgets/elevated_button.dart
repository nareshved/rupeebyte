
import 'package:flutter/material.dart';

Widget eElevatedBtn ({required VoidCallback onTap, required String btnName, Widget? newWidget}) {

  return ElevatedButton(
    
    onPressed: onTap, 
    child: newWidget ?? Text(btnName),
    );
}