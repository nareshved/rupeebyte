// import 'package:flutter/material.dart';
// import '../constants/app_contants.dart';
// import '../models/categories_wise_model.dart';

// class MainlayMonthWiseExpenses extends StatelessWidget {
//   MainlayMonthWiseExpenses({super.key, required this.monthWiseExpensenK});

//   List<MonthWiseExpenseModel> monthWiseExpensenK;

//   @override
//   Widget build(BuildContext context) {
//     {
//       return ListView.builder(
//         itemCount: monthWiseExpensenK.length,
//         itemBuilder: (context, parentIndex) {
//           var eachItem = monthWiseExpensenK[parentIndex];

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [Text(eachItem.month), Text(eachItem.totalAmt)],
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: eachItem.allTransactions.length,
//                   itemBuilder: (context, childIndex) {
//                     var eachTrans = eachItem.allTransactions[childIndex];

//                     return ListTile(
//                       leading: Image.asset(
//                           height: 30,
//                           AppContants
//                               .mCategories[eachTrans.expCatType].catImgPath),
//                       title: Text(eachTrans.expTitle),
//                       subtitle: Text(eachTrans.expDesc),
//                       trailing: Column(
//                         children: [
//                           Text(eachTrans.expAmount.toString()),
//                           Text(eachTrans.expBalance.toString()),
//                           // main balance will added here
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     }
//   }
// }
