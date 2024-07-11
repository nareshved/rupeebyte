import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rupeebyte/bloc/expense_bloc.dart';
import 'package:rupeebyte/bloc/expense_states.dart';
import 'dart:developer';

import '../models/expense_model.dart';
import 'add_expense.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Expense"),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpensePage(),));
      },),

      body: BlocBuilder<ExpenseBloc, ExpenseStates> (
        builder: (context, state) {
          
       if(state is ExpenseLoadingState) {
        return const Center(child: CircularProgressIndicator());
       }


        if(state is ExpenseLoadedState) {

        state.mData.forEach((element) {
          log(element.toMap().toString());
          log("printing in log all Expense data for example");
        },);

       filterDayWiseExpenses(state.mData);
       return ListView.builder(
        
        itemBuilder: (context, index) {
         return Container();

       },);
       }


       if( state is ExpenseErrorState ) {
        return Center(child: Text(state.errorMsg),);
       }


          return Container();
        },
      ),
    );
  }


   void filterDayWiseExpenses (List<ExpenseModel> allExpenses) {
             
   } 

}