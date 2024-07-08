
import 'package:rupeebyte/models/expense_model.dart';

abstract class ExpenseEvents {}

class AddExpenseEvent extends ExpenseEvents{
  ExpenseModel addExpense;
  AddExpenseEvent({required this.addExpense});
  }

class FetchAllExpenseEvent extends ExpenseEvents{}

class UpdateExpenseEvent extends ExpenseEvents{
  ExpenseModel updateExpense;
  UpdateExpenseEvent({required this.updateExpense});
}

class DeleteExpenseEvent extends ExpenseEvents{
  int id;
  DeleteExpenseEvent({required this.id});
}