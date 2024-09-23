import '../database/app_database.dart';

class UserModel {
  int userId;
  String userName;
  String userEmail;
  String userPass;

  UserModel(
      {required this.userEmail,
      required this.userId,
      required this.userName,
      required this.userPass});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map[AppDatabase.COLUMN_USER_ID],
      userName: map[AppDatabase.COLUMN_USER_NAME],
      userEmail: map[AppDatabase.COLUMN_USER_EMAIL],
      userPass: map[AppDatabase.COLUMN_USER_PASS],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppDatabase.COLUMN_USER_ID:
          userId, // each user Id  // expCatId is Auotoincrement h isliye nahi liya
      AppDatabase.COLUMN_USER_NAME:
          userName, // each user Id  // expCatId is Auotoincrement h isliye nahi liya
      AppDatabase.COLUMN_USER_EMAIL:
          userEmail, // each user Id  // expCatId is Auotoincrement h isliye nahi liya
      AppDatabase.COLUMN_USER_PASS:
          userPass, // each user Id  // expCatId is Auotoincrement h isliye nahi liya
    };
  }
}
