import 'dart:convert';

import 'package:flutter/foundation.dart';

class Transaction {
  int amount;
  String category;
  DateTime date;
  String description;
  String name;
  String photo;

  Transaction({
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
    required this.name,
    required this.photo,
  });

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        amount: json["amount"],
        category: json["category"],
        date: DateTime.parse(json["date"]),
        description: json["description"],
        name: json["name"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "category": category,
        "date": date.toIso8601String(),
        "description": description,
        "name": name,
        "photo": photo,
      };
}


