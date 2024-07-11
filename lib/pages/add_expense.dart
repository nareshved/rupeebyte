import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rupeebyte/bloc/expense_bloc.dart';
import 'package:rupeebyte/bloc/expense_events.dart';
import 'package:rupeebyte/models/expense_model.dart';
import 'package:rupeebyte/widgets/elevated_button.dart';
import 'package:rupeebyte/widgets/text_form_field.dart';
import 'dart:developer';

import '../constants/app_contants.dart';

// stateful because dropDownMenu is Required for value onChanged setState

// taki meri mCategoriesSelectedIndex list me se koi bhi selected Naa rahe
// var mCategoriesSelectedIndex = -1;


class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

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
  var mCategoriesSelectedIndex = -1;    // means : no index selected

  // date  
  DateTime expenseDate = DateTime.now();  // for default date today

  @override
  Widget build(BuildContext context) {

    final mq = MediaQuery.of(context).size;
     
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: SafeArea(child: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

         mTextformFeild(mController: titleController, mHint: "name Expense"),
         SizedBox(height: mq.height * 0.012,),
        
         mTextformFeild(mController: descController, mHint: "enter Description"),
          SizedBox(height: mq.height * 0.012,),
         
         mTextformFeild(mController: amountController, mHint: "enter amount"),
           SizedBox(height: mq.height * 0.012,),
           
           
           DropdownButton(
            value: selectedTransactionType,
            items: transactionType.map((type) => 
            DropdownMenuItem(
              value: type,
              child: Text(type))
            ).toList(), 
            onChanged: (value) {
              selectedTransactionType = value!;
              setState(() {
                log("you selected value updated ");
              });
            },
            ), 

           SizedBox(height: mq.height * 0.012,),


           eElevatedBtn(
            btnName: "Choose Expense",
            newWidget: mCategoriesSelectedIndex != -1 ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Image.asset(AppContants.mCategories[mCategoriesSelectedIndex].catImgPath, width: 20, height: 20,),
              Text('- ${AppContants.mCategories[mCategoriesSelectedIndex].catTitle}')

            ],) : null,
            onTap: () {
             showModalBottomSheet(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
              context: context, 
              builder: (context) => GridView.builder(
                itemCount: AppContants.mCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), 
                itemBuilder: (context, index) {

                  var eachCat = AppContants.mCategories[index];

                  return InkWell(
                    onTap: () {
                      mCategoriesSelectedIndex = index;
                      setState(() {
                        log("$mCategoriesSelectedIndex  is index updated");
                      });
                      Navigator.pop(context);
                      
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(padding: const EdgeInsets.all(15), 
                      child: Image.asset(eachCat.catImgPath,),
                      ),
                    
                    ),
                  );
                },
                ),);
            },
            ),
            SizedBox(height: mq.height * 0.012,),

           eElevatedBtn(
            btnName: DateFormat.yMMMd().format(expenseDate),
            onTap: () {
            selectExpDate();

            },
            ),
            SizedBox(height: mq.height * 0.012,),

            
           eElevatedBtn(
            btnName: "Add Expense",
            onTap: () {

             var newExpense = ExpenseModel(
           
              uId: 0,   //  uId: AppDatabase.LOGIN_UID, store prefs UId
              expType: selectedTransactionType == "Debit" ? 0 : 1, 
              expTitle: titleController.text.toString(), 
              expTimeStamp: expenseDate.millisecondsSinceEpoch.toString(), 
              expId: 0, 
              expDesc: descController.text.toString(), 
              expCatType: mCategoriesSelectedIndex, 
              expBalance: 0, 
              expAmount: int.parse(amountController.text.toString()));
          
             BlocProvider.of<ExpenseBloc>(context).add(AddExpenseEvent(addExpense: newExpense));

               Navigator.pop(context);
            },


            ),
            
          
          
          ],
        ),
      )),
    );
  }




// select date 

  Future<void> selectExpDate () async {

    final DateTime? selectedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 1, 8), 
      lastDate: DateTime.now()
      );

      if(selectedDate != null) {
        setState(() {
          expenseDate = selectedDate;
        });
      }
  }
 

//  // get uid
//  Future<void> getUIdPrefs () async {

//   final prefs = 
//  }




}