import 'package:flutter/material.dart';
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

  TextEditingController expTitleController = TextEditingController();
  TextEditingController expDescController = TextEditingController();
  TextEditingController expAmountController = TextEditingController();

  var transactionType = ["Debit", "Credit"];
  var selectedTransactionType = "Debit";
  var mCategoriesSelectedIndex = -1;    // means : no index selected

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

         mTextformFeild(mController: expTitleController, mHint: "name Expense"),
         SizedBox(height: mq.height * 0.012,),
        
         mTextformFeild(mController: expDescController, mHint: "enter Description"),
          SizedBox(height: mq.height * 0.012,),
         
         mTextformFeild(mController: expAmountController, mHint: "enter amount"),
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
            newWidget: mCategoriesSelectedIndex != -1 ? Row(children: [
              
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
            btnName: "date picker Expense",
            onTap: () {},
            ),
            SizedBox(height: mq.height * 0.012,),
            
           eElevatedBtn(
            btnName: "Add Expense",
            onTap: () {},
            ),
            
      
          
          
          
          
          
          ],
        ),
      )),
    );
  }
}