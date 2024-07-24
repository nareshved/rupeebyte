import 'expense_model.dart';

class DateWiseExpenseModel {

  String date;
  String totalAmt;
  List<ExpenseModel> allTransactions;
  
  DateWiseExpenseModel({required this.allTransactions, required this.date, required this.totalAmt});
  
}