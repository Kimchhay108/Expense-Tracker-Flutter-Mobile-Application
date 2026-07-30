import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/transaction_service.dart';

class SpendingItem {
  final String id;
  final String title;
  final String date;
  final double amount;
  final String logoUrl;
  final bool isHighlighted;
  final String category;

  SpendingItem({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.logoUrl,
    this.isHighlighted = false,
    required this.category,
  });

  SpendingItem copyWith({bool? isHighlighted}) {
    return SpendingItem(
      id: id,
      title: title,
      date: date,
      amount: amount,
      logoUrl: logoUrl,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      category: category,
    );
  }

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
}

class StatisticController extends GetxController {
  final _service = Get.find<TransactionService>();

  final activePeriod = 'Month'.obs; // Default to 'Month'
  final activeType = 'Expense'.obs;

  final periods = ['Day', 'Week', 'Month', 'Year'];
  final filterTypes = ['Expense', 'Income'];

  // Aggregated values
  final chartValues = <double>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].obs;
  final labels = <String>[].obs;

  final selectedPointIndex = 11.obs; // Default to newest point

  final topSpending = <SpendingItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Recompute values when inputs or data changes
    ever(_service.transactions, (_) => calculateChartAndSpending());
    ever(activePeriod, (_) => calculateChartAndSpending());
    ever(activeType, (_) => calculateChartAndSpending());

    calculateChartAndSpending();
  }

  void selectPeriod(String period) {
    activePeriod.value = period;
  }

  void selectType(String type) {
    activeType.value = type;
  }

  void selectPoint(int index) {
    if (index >= 0 && index < 12) {
      selectedPointIndex.value = index;
    }
  }

  double get chartMaxY {
    double max = 100.0;
    for (var val in chartValues) {
      if (val > max) {
        max = val;
      }
    }
    // Add 20% margin
    return max * 1.20;
  }

  void calculateChartAndSpending() {
    final now = DateTime.now();
    final isInc = activeType.value == 'Income';
    
    final newLabels = <String>[];
    final newValues = List<double>.filled(12, 0.0);
    
    if (activePeriod.value == 'Day') {
      newLabels.addAll(['02', '04', '06', '08', '10', '12', '14', '16', '18', '20', '22', '24']);
      final startOfToday = DateTime(now.year, now.month, now.day);
      final todayTxs = _service.transactions.where((t) => 
        t.isIncome == isInc && 
        t.dateTime.isAfter(startOfToday)
      );
      for (var t in todayTxs) {
        int hour = t.dateTime.hour;
        int index = (hour / 2).floor();
        if (index >= 0 && index < 12) {
          newValues[index] += t.amount;
        }
      }
    } else if (activePeriod.value == 'Week') {
      final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 11));
      const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      for (int i = 0; i < 12; i++) {
        final d = start.add(Duration(days: i));
        newLabels.add(weekDays[d.weekday - 1]);
        
        final dayStart = DateTime(d.year, d.month, d.day);
        final dayEnd = dayStart.add(const Duration(days: 1));
        
        final dayTxs = _service.transactions.where((t) => 
          t.isIncome == isInc &&
          t.dateTime.isAfter(dayStart) &&
          t.dateTime.isBefore(dayEnd)
        );
        newValues[i] = dayTxs.fold(0.0, (sum, t) => sum + t.amount);
      }
    } else if (activePeriod.value == 'Month') {
      newLabels.addAll(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']);
      final yearTxs = _service.transactions.where((t) => 
        t.isIncome == isInc && 
        t.dateTime.year == now.year
      );
      for (var t in yearTxs) {
        int monthIndex = t.dateTime.month - 1;
        if (monthIndex >= 0 && monthIndex < 12) {
          newValues[monthIndex] += t.amount;
        }
      }
    } else {
      int startYear = now.year - 11;
      for (int i = 0; i < 12; i++) {
        int y = startYear + i;
        newLabels.add(y.toString().substring(2));
        
        final yearTxs = _service.transactions.where((t) => 
          t.isIncome == isInc && 
          t.dateTime.year == y
        );
        newValues[i] = yearTxs.fold(0.0, (sum, t) => sum + t.amount);
      }
    }

    chartValues.assignAll(newValues);
    labels.assignAll(newLabels);

    if (selectedPointIndex.value >= 12) {
      selectedPointIndex.value = 11;
    }

    DateTime filterStart;
    if (activePeriod.value == 'Day') {
      filterStart = DateTime(now.year, now.month, now.day);
    } else if (activePeriod.value == 'Week') {
      filterStart = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
    } else if (activePeriod.value == 'Month') {
      filterStart = DateTime(now.year, now.month - 1, now.day);
    } else {
      filterStart = DateTime(now.year - 1, now.month, now.day);
    }

    final filteredTxs = _service.transactions.where((t) => 
      t.isIncome == isInc && 
      t.dateTime.isAfter(filterStart)
    ).toList();

    filteredTxs.sort((a, b) => b.amount.compareTo(a.amount));

    final items = filteredTxs.map((t) {
      final dateStr = _formatDate(t.dateTime);
      return SpendingItem(
        id: t.id,
        title: t.title,
        date: dateStr,
        amount: t.amount,
        logoUrl: '',
        category: t.category,
      );
    }).toList();

    final List<SpendingItem> spendingList = [];
    for (int i = 0; i < items.length; i++) {
      spendingList.add(items[i].copyWith(isHighlighted: i == 0));
    }

    topSpending.assignAll(spendingList);
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
