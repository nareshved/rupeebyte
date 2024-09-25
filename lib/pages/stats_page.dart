import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';
import 'package:rupeebyte/constants/app_constants.dart';
import 'package:rupeebyte/models/category_model.dart';
import 'package:rupeebyte/models/expense_model.dart';
import '../models/categories_wise_exp_model.dart';

class StatsPage extends StatefulWidget {
   StatsPage({super.key, required this.mData});

  List<ExpenseModel> mData;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<CatWiseExpenseModel> catWiseData = [];

  List<OrdinalGroup> listOrdinalGrp = [] ;
  List<OrdinalData> listOrdinalData = [] ;


  @override
  void initState() {
    super.initState();
    filterCatWiseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats"),
      ),
      // body: Column(
      //   children: [Expanded(child: Container()), Expanded(child: Container())],
      // ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: DChartBarO(
                  fillColor: (group, ordinalData, index) {
                    return Colors.lightBlueAccent;

                  },
                  groupList: listOrdinalGrp,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: catWiseData.length,
                itemBuilder: (context, parentIndex) {
                  var eachItem = catWiseData[parentIndex];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(eachItem.catName), Text(eachItem.totalAmt)],
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterCatWiseData() {

    for(CategoryModel eachCat in AppContants.mCategories){
      var catName = eachCat.catTitle;
      var eachCatAmt = 0.0;
      List<ExpenseModel> catTrans = [];

      for(ExpenseModel eachExp in widget.mData) {
   //     if((eachExp.expCatType+1) == eachCat.catId) {   // replace me
        if(eachExp.expCatType == eachCat.catId) {   // replace me
          catTrans.add(eachExp);

          // for Amt / eachCatAmt
          if(eachExp.expCatType == 0){
            /// debit
            eachCatAmt -= eachExp.expAmount;
          } else{
            /// credit
            eachCatAmt += eachExp.expAmount;
          }
        }
      }

      if(catTrans.isNotEmpty) { // empty transactions amount not added to this page above list catWiseData
      catWiseData.add(CatWiseExpenseModel(allTransactions: catTrans, catName: catName, totalAmt: eachCatAmt.toString()));

      listOrdinalData.add(OrdinalData(domain: catName, measure: eachCatAmt.isNegative ? eachCatAmt*-1 : eachCatAmt)); // isNegative for eachCatAmt in minus so not show Graph is down
    }
    }
    
    listOrdinalGrp.add(OrdinalGroup(id: "1", data: listOrdinalData));
  }
}
