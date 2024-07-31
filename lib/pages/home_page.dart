import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rupeebyte/bloc/expense_bloc.dart';
import 'package:rupeebyte/bloc/expense_events.dart';
import 'package:rupeebyte/bloc/expense_states.dart';
import 'package:rupeebyte/constants/app_contants.dart';
import 'package:rupeebyte/constants/dark_theme_manager/dark_theme.dart';
import 'package:rupeebyte/constants/date_time_utils/date_time_utils.dart';
import '../models/date_wise_expense_model.dart';
import '../models/expense_model.dart';
import 'add_expense.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<DateWiseExpenseModel> dateWiseExpense = [];

//  var dateFormat = DateFormat.yMMMEd(); //my choice DateFormat.yMMMEd();

  @override
  void initState() {
    super.initState();
    // fetch all expense in home page before add new
    BlocProvider.of<ExpenseBloc>(context).add(FetchAllExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    // var mWidth = mq.size.width;
    // var mHeight = mq.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Expense"),
        actions: [
          Switch(
            value: context.watch<ThemeProvider>().themeValue,
            onChanged: (value) {
              context.read<ThemeProvider>().themeValue = value;
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddExpensePage(),
              ));
        },
      ),
      body: SafeArea(
        child: BlocBuilder<ExpenseBloc, ExpenseStates>(
          builder: (context, state) {
            if (state is ExpenseLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ExpenseLoadedState) {
              // state.mData.forEach((element) {
              //   log(element.toMap().toString());
              //   log("printing in log all Expense data for example");
              // },);

              filterDayWiseExpenses(state.mData);
              return mq.orientation == Orientation.landscape
                  ? landscapLay()
                  : portraitLay();
            }

            if (state is ExpenseErrorState) {
              return Center(
                child: Text(state.errorMsg),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  // portrait layout UI
  Widget portraitLay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
              child: Container(
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your balance", style: TextStyle(fontSize: 20)),
                  Text(
                    "0.0000",
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              ),
            ),
          )),
          Expanded(flex: 2, child: mainLay()),
        ],
      ),
    );
  }

  // lanscape layout UI
  Widget landscapLay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Your balance", style: TextStyle(fontSize: 20)),
                      Text(
                        "0.0000",
                        style: TextStyle(fontSize: 28),
                      ),
                    ],
                  ),
                ),
              )),
          Expanded(
            flex: 3,
            child: mainLay(),
          ),
        ],
      ),
    );
  }

// main layout UI
  Widget mainLay() {
    return ListView.builder(
      itemCount: dateWiseExpense.length,
      itemBuilder: (context, parentIndex) {
        var eachItem = dateWiseExpense[parentIndex];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(eachItem.date), Text(eachItem.totalAmt)],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: eachItem.allTransactions.length,
                itemBuilder: (context, childIndex) {
                  var eachTrans = eachItem.allTransactions[childIndex];

                  return ListTile(
                    leading: Image.asset(
                        height: 30,
                        AppContants
                            .mCategories[eachTrans.expCatType].catImgPath),
                    title: Text(eachTrans.expTitle),
                    subtitle: Text(eachTrans.expDesc),
                    trailing: Column(
                      children: [
                        Text(eachTrans.expAmount.toString()),
                        // main balance will added here
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void filterDayWiseExpenses(List<ExpenseModel> allExpenses) {
    dateWiseExpense.clear(); // clear jo is page me jo sabse upar list hai

    var listUniqueDates =
        []; // find each Dates all Expenses like today ke 5 expenses

    for (ExpenseModel eachExp in allExpenses) {
      // var eachDate =
      //     DateTime.fromMillisecondsSinceEpoch(int.parse(eachExp.expTimeStamp));
      // var mDate = dateFormat.format(eachDate);
      // log(mDate);

      var mDate = DateTimeUtils.getFormatedDateFromMili(
          int.parse(eachExp.expTimeStamp));
      log(mDate);

      if (!listUniqueDates.contains(mDate)) {
        // mDate list me nahi h to mDate ko add karo
        listUniqueDates.add(mDate);
      }
    }
    // log(listUniqueDates);

    // listUniqueDates me jo unique dates h usme se eachDate k expenses find kar raha hu

    for (String date in listUniqueDates) {
      List<ExpenseModel> eachDateExp = [];
      var totalAmt = 0.0;

      log(' this is date $date');
      log(' this is date $listUniqueDates');

      for (ExpenseModel eachExp in allExpenses) {
        // var eachDate = DateTime.fromMillisecondsSinceEpoch(
        //     int.parse(eachExp.expTimeStamp));
        // var mDate = dateFormat.format(eachDate);

        var mDate = DateTimeUtils.getFormatedDateFromMili(
            int.parse(eachExp.expTimeStamp));

        if (date == mDate) {
          eachDateExp.add(eachExp);
          log("this is each date ${eachDateExp.toString()}");

          if (eachExp.expType == 0) {
            // Debit
            totalAmt -= eachExp.expAmount;
          } else {
            // Credit
            totalAmt += eachExp.expAmount;
          }
        } else {
          log('else');
        }
      }

      // creating for Today yesterday
      // var todayDate = DateTime.now();
      // var formattedTodayDate = dateFormat.format(todayDate);

      var formattedTodayDate =
          DateTimeUtils.getFormatedDateFromDateTime(DateTime.now());

      if (formattedTodayDate == date) {
        date = "Today";
      }

      // creating for yesterday
      // var yesterdayDate = DateTime.now().subtract(const Duration(days: 1));
      // var formattedyesterdayDate = dateFormat.format(yesterdayDate);

      var formattedyesterdayDate = DateTimeUtils.getFormatedDateFromDateTime(
          DateTime.now().subtract(const Duration(days: 1)));

      if (formattedyesterdayDate == date) {
        date = "yesterday";
      }

      dateWiseExpense.add(DateWiseExpenseModel(
          allTransactions: eachDateExp,
          date: date,
          totalAmt: totalAmt.toString()));
    }

    // log(dateWiseExpense.toString());
    //   log("This is date wise expense ${dateWiseExpense[0].allTransactions.toString()}");
  }
}
