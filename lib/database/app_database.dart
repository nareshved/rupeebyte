import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rupeebyte/models/expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';

class AppDatabase {
// private constructor singleton
  AppDatabase._();

  /// private databse anyone can t aceesss directly purpose

  static final AppDatabase instance =
      AppDatabase._(); // getter return database constructor for me whole app

  Database? mydb;

  // login prefs user uid

  static const String LOGIN_UID = "uid";

  // total table names

  static const String EXP_TABLE = "expense";
  static const String USER_TABLE = "users";

  // users column

  static const String COLUMN_USER_ID = "uId";
  static const String COLUMN_USER_NAME = "uName";
  static const String COLUMN_USER_EMAIL = "uEmail";
  static const String COLUMN_USER_PASS = "uPass";

  // expense column

  static const String COLUMN_EXPENSE_ID = "expId";
  static const String COLUMN_EXPENSE_TITLE = "expTitle";
  static const String COLUMN_EXPENSE_DESC = "expDesc";
  static const String COLUMN_EXPENSE_TIMESTAMP =
      "expTimeStamp"; // exp kab add hua
  static const String COLUMN_EXPENSE_AMOUNT = "expAmount"; // kitna kharcha hua
  static const String COLUMN_EXPENSE_BALANCE = "expBalance"; // total amount
  static const String COLUMN_EXPENSE_TYPE =
      "expType"; // 0 for debit or 1 for credit
  static const String COLUMN_EXPENSE_CAT_TYPE =
      "expCatType"; // exp category type like petrol or salon

  // Database? mydb;

  Future<Database> initDB() async {
    var docDirectory = await getApplicationDocumentsDirectory();

    var dbPathPhone = join(docDirectory.path, "Rupeebyte.db");

    return openDatabase(
      dbPathPhone,
      version: 1,
      onCreate: (db, version) async {
        // create all your table are here....

        // user table
        db.execute(
            "create table $USER_TABLE ( $COLUMN_USER_ID integer primary key autoincrement, $COLUMN_USER_NAME text, $COLUMN_USER_EMAIL text, $COLUMN_USER_PASS text ) ");

        // expense table
        db.execute(
            "create table $EXP_TABLE ( $COLUMN_EXPENSE_ID integer primary key autoincrement, $COLUMN_USER_ID integer, $COLUMN_EXPENSE_TITLE text, $COLUMN_EXPENSE_DESC text, $COLUMN_EXPENSE_TIMESTAMP text, $COLUMN_EXPENSE_AMOUNT real, $COLUMN_EXPENSE_BALANCE real, $COLUMN_EXPENSE_TYPE integer, $COLUMN_EXPENSE_CAT_TYPE integer )");
      },
    );

    //  db.execute(
    //           "create table $EXP_TABLE ( $COLUMN_EXPENSE_ID integer primary key autoincrement, $COLUMN_USER_ID integer, $COLUMN_EXPENSE_TITLE text, $COLUMN_EXPENSE_DESC text, $COLUMN_EXPENSE_TIMESTAMP text, $COLUMN_EXPENSE_AMOUNT real, $COLUMN_EXPENSE_BALANCE real, $COLUMN_EXPENSE_TYPE integer, $COLUMN_EXPENSE_CAT_TYPE integer )");
    //     },
    //   );
  }

  Future<Database> getDB() async {
    if (mydb != null) {
      return mydb!;
    } else {
      mydb = await initDB();
      return mydb!;
    }
  }

  // Database functions

  Future<int> getUID() async {
    var prefs = await SharedPreferences.getInstance();
    var uid = prefs.getInt(AppDatabase.LOGIN_UID);
    return uid ?? 0;
  }

  Future<bool> createAccount(UserModel newUser) async {
    var check = await checkIfUserAlreadyExist(newUser.userEmail);

    if (!check) {
      // create user
      var db = await getDB();
      db.insert(USER_TABLE, newUser.toMap());
      return true;
    } else {
      return false; // Accoumt not created
    }
  }

  Future<bool> checkIfUserAlreadyExist(String email) async {
    var db = await getDB();

    var data = await db.query(USER_TABLE,
        where: "$COLUMN_USER_EMAIL = ? ", whereArgs: [email]);

    return data.isNotEmpty;
  }

  ///login
  Future<bool> authenticateUser(String email, String pass) async {
    var db = await getDB();

    var data = await db.query(USER_TABLE,
        where: "$COLUMN_USER_EMAIL = ? and $COLUMN_USER_PASS = ?",
        whereArgs: [email, pass]);

    if (data.isNotEmpty) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setInt(LOGIN_UID, UserModel.fromMap(data[0]).userId);
    }

    return data.isNotEmpty;
  }

  // add new Expense
  Future<bool> addExpense(ExpenseModel newExpense) async {
    var db = await getDB();

    int rowsEffected = await db.insert(EXP_TABLE, newExpense.toMap());

    return rowsEffected > 0;
  }

  // fetch all Expenses
  Future<List<ExpenseModel>> fetchAllExpense() async {
    var db = await getDB();
    var data =
        await db.query(EXP_TABLE, orderBy: "$COLUMN_EXPENSE_TIMESTAMP DESC");

    List<ExpenseModel> listExp = [];

    for (Map<String, dynamic> eachExp in data) {
      listExp.add(ExpenseModel.fromMap(eachExp));
    }

    return listExp;
  }
}  // Appdatabse class end