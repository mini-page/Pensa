import 'package:hive_flutter/hive_flutter.dart';

import '../../features/expense/data/datasource/expense_local_datasource.dart';
import '../../features/expense/data/models/expense_model.dart';

abstract final class HiveBootstrap {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(ExpenseModelAdapter.typeIdValue)) {
      Hive.registerAdapter(ExpenseModelAdapter());
    }

    if (!Hive.isBoxOpen(ExpenseLocalDatasource.boxName)) {
      await Hive.openBox<ExpenseModel>(ExpenseLocalDatasource.boxName);
    }
  }
}
