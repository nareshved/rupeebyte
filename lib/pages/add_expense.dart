import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rupeebyte/bloc/expense_bloc.dart';
import 'package:rupeebyte/bloc/expense_events.dart';
import 'package:rupeebyte/models/expense_model.dart';
import 'package:rupeebyte/widgets/elevated_button.dart';
import 'package:rupeebyte/widgets/text_form_field.dart';
import 'dart:developer';

import '../constants/app_constants.dart';

// stateful because dropDownMenu is Required for value onChanged setState

// taki meri mCategoriesSelectedIndex list me se koi bhi selected Naa rahe
// var mCategoriesSelectedIndex = -1;

class AddExpensePage extends StatefulWidget {
  AddExpensePage({super.key, required this.balance});

  num balance;

  @override
  State<StatefulWidget> createState() {
    return AddExpensePageState();
  }
}

class AddExpensePageState extends State<AddExpensePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  var transactionType = ["Debit", "Credit"];
  var selectedTransactionType = "Debit";
  var mCategoriesSelectedIndex = -1; // means : no index selected

  // date
  DateTime expenseDate = DateTime.now(); // for default date today

  @override
  void initState() {
    super.initState();

    log("init state starting date jo ${expenseDate.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                mTextformFeild(
                    mController: titleController, mHint: "Expense Name"),
                SizedBox(
                  height: mq.height * 0.025,
                ),
                mTextformFeild(
                    mController: descController, mHint: "Expense Description"),
                SizedBox(
                  height: mq.height * 0.025,
                ),
                mTextformFeild(
                    mController: amountController, mHint: "Expense Amount"),
                SizedBox(
                  height: mq.height * 0.025,
                ),
                SizedBox(
                  width: mq.width,
                  child: Card(
                    child: Center(
                      child: DropdownButton(
                        value: selectedTransactionType,
                        items: transactionType
                            .map((type) =>
                                DropdownMenuItem(value: type, child: Text(type)))
                            .toList(),
                        onChanged: (value) {
                          selectedTransactionType = value!;
                          setState(() {
                            log("you selected value updated ");
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.012,
                ),
                SizedBox(
                  width: mq.width,
                  child: eElevatedBtn(
                    btnName: "Choose Expense",
                    newWidget: mCategoriesSelectedIndex != -1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppContants.mCategories[mCategoriesSelectedIndex]
                                    .catImgPath,
                                width: 20,
                                height: 20,
                              ),
                              Text(
                                  '- ${AppContants.mCategories[mCategoriesSelectedIndex].catTitle}')
                            ],
                          )
                        : null,
                    onTap: () {
                      showModalBottomSheet(
                        useSafeArea: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15))),
                        context: context,
                        builder: (context) => GridView.builder(
                          itemCount: AppContants.mCategories.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemBuilder: (context, index) {
                            var eachCat = AppContants.mCategories[index];

                            return InkWell(
                              onTap: () {
                                mCategoriesSelectedIndex = index;

                                // select id instead
                             //   eachCat.catId;   store in database

                                setState(() {
                                  log("$mCategoriesSelectedIndex  is index updated");
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Image.asset(
                                    eachCat.catImgPath,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.012,
                ),
                SizedBox(
                  width: mq.width,
                  child: eElevatedBtn(
                    btnName: DateFormat.yMMMd().format(expenseDate),
                    onTap: () {
                      selectExpDate();
                      log("on Pressed!! user not select date ${expenseDate.toString()}");
                    },
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.012,
                ),
                SizedBox(
                  width: mq.width,
                  child: eElevatedBtn(
                    btnName: "Add Expense",
                    onTap: () {
                      var mBalance = widget.balance;

                      if (selectedTransactionType == "Debit") {
                        mBalance -= int.parse(amountController.text.toString());
                      } else {
                        mBalance += int.parse(amountController.text.toString());
                      }

                      var newExpense = ExpenseModel(
                          uId: 0, //  uId: AppDatabase.LOGIN_UID, store prefs UId
                          expType: selectedTransactionType == "Debit" ? 0 : 1,
                          expTitle: titleController.text.toString(),
                          expTimeStamp:
                              expenseDate.millisecondsSinceEpoch.toString(),
                          expId: 0,
                          expDesc: descController.text.toString(),
                          expCatType: mCategoriesSelectedIndex,
                          expBalance: mBalance,
                          expAmount: int.parse(amountController.text.toString()));

                      BlocProvider.of<ExpenseBloc>(context)
                          .add(AddExpenseEvent(addExpense: newExpense));

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

// select date

  Future<void> selectExpDate() async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1, 8),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      setState(() {
        expenseDate = selectedDate;

        log("ye date jo ${expenseDate.toString()}");
      });
    }
  }

//  // get uid
//  Future<void> getUIdPrefs () async {

//   final prefs =
//  }
}
