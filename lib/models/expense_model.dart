import 'package:rupeebyte/database/app_database.dart';

class ExpenseModel {
  int expId;
  int uId; // userId ye expense kis user ka hai
  String expTitle;
  String expDesc;
  String expTimeStamp;
  num expAmount;
  num expBalance;
  int expType; // 0 for debit or 1 for credit
  int expCatType; // exp category type like petrol or salon

  ExpenseModel(
      {required this.uId,
      required this.expType,
      required this.expTitle,
      required this.expTimeStamp,
      required this.expId,
      required this.expDesc,
      required this.expCatType,
      required this.expBalance,
      required this.expAmount});

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      expId: map[AppDatabase.COLUMN_EXPENSE_ID],
      uId: map[AppDatabase.COLUMN_USER_ID],
      expType: map[AppDatabase.COLUMN_EXPENSE_TYPE],
      expTitle: map[AppDatabase.COLUMN_EXPENSE_TITLE],
      expTimeStamp: map[AppDatabase.COLUMN_EXPENSE_TIMESTAMP],
      expDesc: map[AppDatabase.COLUMN_EXPENSE_DESC],
      expCatType: map[AppDatabase.COLUMN_EXPENSE_CAT_TYPE],
      expBalance: map[AppDatabase.COLUMN_EXPENSE_BALANCE],
      expAmount: map[AppDatabase.COLUMN_EXPENSE_AMOUNT],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppDatabase.COLUMN_USER_ID:
          uId, // each user Id  // expCatId is Autoincrement h isliye nahi liya
      AppDatabase.COLUMN_EXPENSE_TITLE: expTitle,
      AppDatabase.COLUMN_EXPENSE_DESC: expDesc,
      AppDatabase.COLUMN_EXPENSE_TIMESTAMP: expTimeStamp,
      AppDatabase.COLUMN_EXPENSE_AMOUNT: expAmount,
      AppDatabase.COLUMN_EXPENSE_BALANCE: expBalance,
      AppDatabase.COLUMN_EXPENSE_CAT_TYPE: expCatType,
      AppDatabase.COLUMN_EXPENSE_TYPE: expType, // 0 for debit or 1 for credit
    };
  }
}
