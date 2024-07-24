/*


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rupeebyte/bloc/expense_bloc.dart';
import 'package:rupeebyte/bloc/expense_states.dart';
import 'package:rupeebyte/constants/app_contants.dart';
import 'dart:developer';
import '../models/date_wise_expense_model.dart';
import '../models/expense_model.dart';



class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<DateWiseExpenseModel> dateWiseExpense = [] ;

  var dateFormat = DateFormat.yMd();    //my choice DateFormat.yMMMEd();

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

            // state.mData.forEach((element) {
            //   log(element.toMap().toString());
            //   log("printing in log all Expense data for example");
            // },

            // );

            filterDayWiseExpenses(state.mData);

            return ListView.builder(

              itemCount: dateWiseExpense.length,
              itemBuilder: (context, parentIndex) {

                var eachItem = dateWiseExpense[parentIndex];   // call upar wali list

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(eachItem.date),
                          Text(eachItem.totalAmt),
                        ],
                      ),
                      const SizedBox(height: 5,),

                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: eachItem.allTransactions.length,
                        itemBuilder: (context, childIndex) {

                          var eachTrans = eachItem.allTransactions[childIndex];

                          return ListTile(
                            leading: Image.asset(AppContants.mCategories[eachTrans.expCatType].catImgPath,),
                            title: Text(eachTrans.expTitle),
                            subtitle: Text(eachTrans.expDesc),

                          );
                        },
                      ),
                    ],
                  ),
                );

              },);
          }


          if( state is ExpenseErrorState ) {
            return Center(child: Text(state.errorMsg),);
          }


          return const Center(child: Text("loading...."));
        },
      ),
    );
  }


  void filterDayWiseExpenses (List<ExpenseModel> allExpenses) {
    dateWiseExpense.clear();  // clear jo is page me jo sabse upar list hai

    var listUniqueDates = [] ;  // find each Dates all Expenses like today ke 5 expenses

    for(ExpenseModel eachExp in allExpenses) {
      var eachDate = DateTime.fromMicrosecondsSinceEpoch(int.parse(eachExp.expTimeStamp));
      var mDate = dateFormat.format(eachDate);
      log(mDate);

      if(!listUniqueDates.contains(mDate)) {
        // mDate list me nahi h to mDate ko add karo
        listUniqueDates.add(mDate);
      }

      log(listUniqueDates.toString());
    }


    // listUniqueDates me jo unique dates h usme se eaxhDate k expenses find kar raha hu

    for(String date in listUniqueDates) {


      List<ExpenseModel> eachDateExp = [];
      var totalAmt = 0.0;

      for (ExpenseModel eachExp in allExpenses) {
        var eachDate = DateTime.fromMillisecondsSinceEpoch(int.parse(eachExp.expTimeStamp));
        var mDate = dateFormat.format(eachDate);

        if(date == mDate) {

          eachDateExp.add(eachExp);

          if(eachExp.expType == 0) {
            // Debit
            totalAmt -= eachExp.expAmount;
          }  else {
            // Credit
            totalAmt += eachExp.expAmount;

          }
        }

      }

      dateWiseExpense.add(DateWiseExpenseModel(
          allTransactions: eachDateExp,
          date: date, totalAmt: totalAmt.toString()));
    }

    log(dateWiseExpense.toString());
    log(dateWiseExpense[0].allTransactions.toString());

  }

}*/
