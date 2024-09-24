import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rupeebyte/database/app_database.dart';

import 'expense_events.dart';
import 'expense_states.dart';

class ExpenseBloc extends Bloc<ExpenseEvents, ExpenseStates> {
  AppDatabase db; // Database instance created

  ExpenseBloc({required this.db}) : super(ExpenseInitialState()) {
    on<AddExpenseEvent>(
      (event, emit) async {
        emit(ExpenseLoadingState());

        var check = await db.addExpense(event.addExpense);
        if (check) {
          var mExp = await db.fetchAllExpense();
          emit(ExpenseLoadedState(mData: mExp));
          log("expense added!! thank you");
        } else {
          emit(
              ExpenseErrorState(errorMsg: "your Expense not! added try again"));
          log("add expense error on bloc event");
        }
      },
    );

    on<FetchAllExpenseEvent>(
      (event, emit) async {
        emit(ExpenseLoadingState());
        var mExp = await db.fetchAllExpense();
        emit(ExpenseLoadedState(mData: mExp));
        log("fetched all Expenses from Database in bloc");
      },
    );
  }
}
