import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  late String title;
  late double amount;
  late String type; // 'income' ya 'expense'
  late DateTime date;
  String? note;
}
