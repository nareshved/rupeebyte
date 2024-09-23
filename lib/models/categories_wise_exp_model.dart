import 'expense_model.dart';

class CatWiseExpenseModel {
  String catName;
  String totalAmt;
  List<ExpenseModel> allTransactions;

  CatWiseExpenseModel(
      {required this.allTransactions,
      required this.catName,
      required this.totalAmt});
}
