import 'package:flutter/material.dart';

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final String category;
  final DateTime dateTime;
  final String? contactName;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.dateTime,
    this.contactName,
  });

  IconData get icon {
    switch (category) {
      case 'Food':
        return Icons.restaurant_outlined;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      case 'Subscription':
        return Icons.subscriptions_outlined;
      case 'Salary':
        return Icons.payments_outlined;
      case 'Transportation':
        return Icons.directions_car_outlined;
      case 'Transfer':
        return Icons.swap_horiz_rounded;
      case 'Utilities':
        return Icons.lightbulb_outline_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  Color get iconBackground {
    switch (category) {
      case 'Food':
        return const Color(0xFFFDD4D7);
      case 'Shopping':
        return const Color(0xFFFCEED3);
      case 'Subscription':
        return const Color(0xFFEEE5FF);
      case 'Salary':
        return const Color(0xFFCFF9EA);
      case 'Transportation':
        return const Color(0xFFBCDBFF);
      case 'Transfer':
        return const Color(0xFFE2F6F1);
      case 'Utilities':
        return const Color(0xFFFFF2E0);
      default:
        return const Color(0xFFF0F6F5);
    }
  }

  Color get iconColor {
    switch (category) {
      case 'Food':
        return const Color(0xFFFD3C4A);
      case 'Shopping':
        return const Color(0xFFFCAC12);
      case 'Subscription':
        return const Color(0xFF7E3DFF);
      case 'Salary':
        return const Color(0xFF00A86B);
      case 'Transportation':
        return const Color(0xFF0077FF);
      case 'Transfer':
        return const Color(0xFF00B495);
      case 'Utilities':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF438883);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'category': category,
      'dateTime': dateTime.toIso8601String(),
      'contactName': contactName,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      isIncome: json['isIncome'] as bool,
      category: json['category'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      contactName: json['contactName'] as String?,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    bool? isIncome,
    String? category,
    DateTime? dateTime,
    String? contactName,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      contactName: contactName ?? this.contactName,
    );
  }
}

class BillModel {
  final String id;
  final String title;
  final double amount;
  final DateTime dueDate;
  final bool isPaid;
  final String category;

  BillModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'isPaid': isPaid,
      'category': category,
    };
  }

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      isPaid: json['isPaid'] as bool? ?? false,
      category: json['category'] as String? ?? 'Utilities',
    );
  }

  BillModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? dueDate,
    bool? isPaid,
    String? category,
  }) {
    return BillModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      isPaid: isPaid ?? this.isPaid,
      category: category ?? this.category,
    );
  }
}
