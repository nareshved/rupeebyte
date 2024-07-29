import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rupeebyte/bloc/expense_bloc.dart';
import 'package:rupeebyte/database/app_database.dart';
import 'package:rupeebyte/pages/home_page.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => ExpenseBloc(db: AppDatabase.instance),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rupee byte',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
