import 'package:flutter/material.dart';
import 'package:rupeebyte/pages/home_page.dart';
import '../../pages/add_expense.dart';
import '../../pages/settings_page.dart';

class ExpenseBottomNavbarHome extends StatefulWidget {
  const ExpenseBottomNavbarHome({super.key});

  @override
  State<ExpenseBottomNavbarHome> createState() =>
      _ExpenseBottomNavbarHomeState();
}

class _ExpenseBottomNavbarHomeState extends State<ExpenseBottomNavbarHome> {

  List<Widget> navBottomPages = [
    const HomePage(),
    AddExpensePage(balance: HomePageState.lastBalance,),
    const SettingsPage(),
  ];

  var mSelectedIndex = 0;
 // var mSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(

      selectedIndex: mSelectedIndex,
        onDestinationSelected: (index) {
          mSelectedIndex = index;
          setState(() {

          });
        },

        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_filled), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.edit), label: "Add Expense"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),

      body: navBottomPages[mSelectedIndex],
    );
  }
}
