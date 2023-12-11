import 'package:financial_piggy_bank/pages/home_page.dart';

class TransactionItem {
  String? description;
  DateTime? date;
  double? cost;
  ECategoryType? type;

  TransactionItem({this.description, this.date, this.cost, this.type});

  factory TransactionItem.fromJson(Map<String, dynamic> parsedJson) {
    return TransactionItem(
        description: parsedJson['description'] ?? "",
        cost: parsedJson['cost'] ?? "",
        type: ECategoryType.values.byName(parsedJson['type']),
        date: DateTime.tryParse(parsedJson['date']));
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "cost": cost,
      "type": type!.name,
      "date": date.toString()
    };
  }
}
