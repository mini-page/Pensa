import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/expense_local_datasource.dart';
import '../../data/models/expense_model.dart';
import '../../data/repositories/hive_expense_repository.dart';
import '../../domain/repositories/expense_repository.dart';

final expenseLocalDatasourceProvider = Provider<ExpenseLocalDatasource>((ref) {
  return ExpenseLocalDatasource();
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return HiveExpenseRepository(ref.watch(expenseLocalDatasourceProvider));
});

final expenseListProvider =
    AsyncNotifierProvider<ExpenseListNotifier, List<ExpenseModel>>(
  ExpenseListNotifier.new,
);

final expenseControllerProvider = Provider<ExpenseController>((ref) {
  return ExpenseController(ref);
});

final statsProvider = Provider<ExpenseStats>((ref) {
  final expenses =
      ref.watch(expenseListProvider).valueOrNull ?? const <ExpenseModel>[];
  return ExpenseStats.fromExpenses(expenses);
});

class ExpenseListNotifier extends AsyncNotifier<List<ExpenseModel>> {
  ExpenseRepository get _repository => ref.read(expenseRepositoryProvider);

  @override
  Future<List<ExpenseModel>> build() async {
    try {
      return _repository.getAllExpenses();
    } catch (_) {
      return <ExpenseModel>[];
    }
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final currentExpenses = state.valueOrNull ?? const <ExpenseModel>[];
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.addExpense(expense);
      return <ExpenseModel>[expense, ...currentExpenses]
        ..sort((left, right) => right.date.compareTo(left.date));
    });
  }

  Future<void> deleteExpense(String id) async {
    final currentExpenses = state.valueOrNull ?? const <ExpenseModel>[];
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteExpense(id);
      return currentExpenses
          .where((expense) => expense.id != id)
          .toList(growable: false);
    });
  }
}

class ExpenseController {
  ExpenseController(this._ref);

  final Ref _ref;

  Future<void> addExpense({
    required double amount,
    required String category,
    required DateTime date,
    required String note,
  }) async {
    final expense = ExpenseModel.create(
      amount: amount,
      category: category,
      date: date,
      note: note.isEmpty ? 'Manual Entry' : note,
    );
    await _ref.read(expenseListProvider.notifier).addExpense(expense);
  }

  Future<void> deleteExpense(String id) async {
    await _ref.read(expenseListProvider.notifier).deleteExpense(id);
  }
}

class ExpenseStats {
  const ExpenseStats({
    required this.monthTotal,
    required this.todayTotal,
    required this.transactionCount,
    required this.categoryTotals,
  });

  factory ExpenseStats.fromExpenses(List<ExpenseModel> expenses) {
    final now = DateTime.now().toUtc();
    final monthExpenses = expenses.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).toList(growable: false);

    final todayExpenses = monthExpenses.where((expense) {
      return expense.date.day == now.day;
    }).toList(growable: false);

    final totals = <String, double>{};
    for (final expense in monthExpenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    final sortedEntries = totals.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value));

    return ExpenseStats(
      monthTotal: monthExpenses.fold(0, (sum, expense) => sum + expense.amount),
      todayTotal: todayExpenses.fold(0, (sum, expense) => sum + expense.amount),
      transactionCount: monthExpenses.length,
      categoryTotals: Map<String, double>.fromEntries(sortedEntries),
    );
  }

  final double monthTotal;
  final double todayTotal;
  final int transactionCount;
  final Map<String, double> categoryTotals;
}
