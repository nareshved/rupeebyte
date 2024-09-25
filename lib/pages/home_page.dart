import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rupeebyte/bloc/expense_bloc.dart';
import 'package:rupeebyte/bloc/expense_events.dart';
import 'package:rupeebyte/bloc/expense_states.dart';
import 'package:rupeebyte/constants/app_constants.dart';
import 'package:rupeebyte/constants/date_time_utils/date_time_utils.dart';
import '../models/date_wise_expense_model.dart';
import '../models/expense_model.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<DateWiseExpenseModel> dateWiseExpense = [];
  List<ExpenseModel> allExpenses =
      []; // for passing data to stats graphs page to filterCatWiseData
  // List<MonthWiseExpenseModel> monthWiseExpensenK = [];

//  var dateFormat = DateFormat.yMMMEd(); //my choice DateFormat.yMMMEd();

  static num lastBalance = 0.0;

  @override
  void initState() {
    super.initState();
    // fetch all expense in home page before add new
    BlocProvider.of<ExpenseBloc>(context).add(FetchAllExpenseEvent());
    // filterExpenseMonthWise(allExpenses: list);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    // var mWidth = mq.size.width;
    // var mHeight = mq.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StatsPage(
                    mData: allExpenses,
                  )));
        },
        child: const Icon(Icons.bar_chart),
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

              if (state.mData.isNotEmpty) {
                // lastBalance declare var above in the class
                // lastBalance = state.mData.last.expBalance.toDouble();

                updateBalance(state.mData); // updating balance

                /// sir mont hwise Expense ...................
                //  filterExpenseMonthWise(allExpenses: state.mData);
                // return MainlayMonthWiseExpenses(
                //   monthWiseExpensenK: monthWiseExpensenK,
                // );

                // filterMonthWiseExpenses(state.mData);

                filterDayWiseExpenses(state.mData);
                allExpenses = state.mData; // saved to catWiseData to pass
                return mq.orientation == Orientation.landscape
                    ? landscapLay()
                    : portraitLay();
              } else {
                return const Center(
                  child: Text(
                    "NO Expenses Found!",
                    style: TextStyle(fontSize: 17),
                  ),
                );
              }
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

  void updateBalance(List<ExpenseModel> mData) {
    //  finding last balance beacause issue i am ordering change of databsase column orderBy expBal
    var lastTransactionId = -1;

    for (ExpenseModel exp in mData) {
      if (exp.expId > lastTransactionId) {
        lastTransactionId = exp.expId;
      }
    }

    // var lastExpBalance = mData
    //     .firstWhere(
    //       (element) => element.expId == lastTransactionId,
    //     ).expBalance;        // is same like lastExpBalance.where jab ek hi var uthana ho

    var lastExpBalance = mData
        .where(
          (element) => element.expId == lastTransactionId,
        )
        .toList()[0]
        .expBalance;

    lastBalance = lastExpBalance;

    //
  }

  // portrait layout UI
  Widget portraitLay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(child: balanceHander()),
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
          // ElevatedButton(
          //     onPressed: () {
          //       saveName();
          //     },
          //     child: const Text('presssed')),
          Expanded(flex: 3, child: balanceHander()),
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

                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                          height: 30,
                          AppContants
                              .mCategories[eachTrans.expCatType].catImgPath),
                      title: Text(eachTrans.expTitle),
                      subtitle: Text(eachTrans.expDesc),
                      trailing: Column(
                        children: [
                          Text(eachTrans.expAmount.toString()),
                          Text(eachTrans.expBalance.toString()),
                          // main balance will added here
                        ],
                      ),
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

// balance showing widget in homePage
  Widget balanceHander() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Your balance", style: TextStyle(fontSize: 20)),
          Text(
            "$lastBalance",
            style: const TextStyle(fontSize: 28),
          ),
        ],
      ),
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
      // log(mDate);

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

      // log(' this is date $date');
      // log(' this is date $listUniqueDates');

      for (ExpenseModel eachExp in allExpenses) {
        // var eachDate = DateTime.fromMillisecondsSinceEpoch(
        //     int.parse(eachExp.expTimeStamp));
        // var mDate = dateFormat.format(eachDate);

        var mDate = DateTimeUtils.getFormatedDateFromMili(
            int.parse(eachExp.expTimeStamp));

        if (date == mDate) {
          eachDateExp.add(eachExp);
          //   log("this is each date ${eachDateExp.toString()}");

          if (eachExp.expType == 0) {
            // Debit
            totalAmt -= eachExp.expAmount;
          } else {
            // Credit
            totalAmt += eachExp.expAmount;
          }
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

      var formattedYesterdayDate = DateTimeUtils.getFormatedDateFromDateTime(
          DateTime.now().subtract(const Duration(days: 1)));

      if (formattedYesterdayDate == date) {
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

  // List<MonthWiseExpenseModel> filterMonthWiseExpenses(
  //   List<ExpenseModel> allExpenses,
  // ) {
  //   List<MonthWiseExpenseModel> monthWiseExpenses = [];

  //   var listUniqueMonths =
  //       []; // find each Dates all Expenses like today ke 5 expenses

  //   for (int i =0; i < allExpenses  .length; i++) {
  //     var createdAt = allExpenses[i].expTimeStamp;

  //     var mMonth = DateTimeUtils.getFormatedMonthFromMili(
  //         int.parse(eachExp.expTimeStamp));
  //     // log(mMonth);

  //     if (!listUniqueMonths.contains(mMonth)) {
  //       // mDate list me nahi h to mDate ko add karo
  //       listUniqueMonths.add(mMonth);
  //     }
  //   }
  //   // log(listUniqueDates);
  //   log(listUniqueMonths.toString());

  //   for (String month in listUniqueMonths) {
  //     List<ExpenseModel> thisMonthExpenses = [];
  //     num thisMonthBal = 0.0;

  //     for (ExpenseModel eachExp in allExpenses) {
  //       var mMonth = DateTimeUtils.getFormatedMonthFromMili(
  //           int.parse(eachExp.expTimeStamp));

  //       if (month == mMonth) {
  //         thisMonthExpenses.add(eachExp);
  //         //   log("this is each date ${eachDateExp.toString()}");

  //         if (eachExp.expType == 0) {
  //           // Debit
  //           thisMonthBal -= eachExp.expAmount;
  //         } else {
  //           // Credit
  //           thisMonthBal += eachExp.expAmount;
  //         }
  //       }
  //     }

  //     monthWiseExpenses.add(MonthWiseExpenseModel(
  //         allTransactions: thisMonthExpenses,
  //         month: month,
  //         totalAmt: thisMonthBal.toString()));

  //     monthWiseExpensenK.add(MonthWiseExpenseModel(
  //         allTransactions: thisMonthExpenses,
  //         month: month,
  //         totalAmt: thisMonthBal.toString()));
  //   }

  //   return monthWiseExpenses;
  // }

  // void filterExpenseMonthWise({required List<ExpenseModel> allExpenses}) {
  //   // listFilterExpModel.clear();
  //   /// find the unique dates
  //   List<String> uniqueMonths = [];
  //   for (int i = 0; i < allExpenses.length; i++) {
  //     var createdAt = allExpenses[i].expTimeStamp;
  //     var mDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(createdAt));
  //     var eachExpenseMonth = DateTimeUtils.monthDateFormate.format(mDateTime);
  //     var eachExpenseYear = DateTimeUtils.yearFormat.format(mDateTime);
  //     print("$eachExpenseMonth-$eachExpenseYear");
  //     var eachExpenseMonthYear = "$eachExpenseMonth-$eachExpenseYear";
  //     if (!uniqueMonths.contains(eachExpenseMonthYear)) {
  //       uniqueMonths.add(eachExpenseMonthYear);
  //     }
  //     print(uniqueMonths);
  //   }
  //   for (String eachMonth in uniqueMonths) {
  //     num totalExpAmt = 0.0;
  //     List<ExpenseModel> eachMonthExpenses = [];
  //     for (ExpenseModel eachExpense in allExpenses) {
  //       var createdAt = eachExpense.expTimeStamp;
  //       var mDateTime =
  //           DateTime.fromMillisecondsSinceEpoch(int.parse(createdAt));
  //       var eachExpenseMonth = DateTimeUtils.monthFormat;
  //       var eachExpenseYear = DateTimeUtils.yearFormat.format(mDateTime);
  //       var eachExpenseMonthYear = "$eachExpenseMonth-$eachExpenseYear";
  //       if (eachExpenseMonthYear == eachMonth) {
  //         eachMonthExpenses.add(eachExpense);
  //         if (eachExpense.expCatType == "Debit") {
  //           totalExpAmt -= eachExpense.expAmount;
  //         } else {
  //           totalExpAmt += eachExpense.expAmount;
  //         }
  //       }
  //     }
  //     monthWiseExpensenK.add(MonthWiseExpenseModel(
  //         month: eachMonth,
  //         totalAmt: totalExpAmt.toString(),
  //         allTransactions: eachMonthExpenses));
  //   }
  //   print("this is month wise ${monthWiseExpensenK.length}");
  // }
}
