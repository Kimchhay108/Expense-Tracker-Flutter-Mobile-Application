import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/services/transaction_service.dart';

class TransactionController extends GetxController {
  final _service = Get.find<TransactionService>();

  final isIncome = false.obs;
  late TextEditingController amountController;
  late TextEditingController titleController;
  final selectedCategory = 'Food'.obs;
  final selectedDate = DateTime.now().obs;

  final categories = [
    'Food',
    'Shopping',
    'Subscription',
    'Salary',
    'Transportation',
    'Transfer',
    'Utilities',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    amountController = TextEditingController();
    titleController = TextEditingController();
  }

  @override
  void onClose() {
    amountController.dispose();
    titleController.dispose();
    super.onClose();
  }

  void resetForm({bool typeIsIncome = false}) {
    isIncome.value = typeIsIncome;
    amountController.clear();
    titleController.clear();
    selectedCategory.value = typeIsIncome ? 'Salary' : 'Food';
    selectedDate.value = DateTime.now();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleType(bool type) {
    isIncome.value = type;
    if (type && selectedCategory.value == 'Food') {
      selectedCategory.value = 'Salary';
    } else if (!type && selectedCategory.value == 'Salary') {
      selectedCategory.value = 'Food';
    }
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  bool saveTransaction() {
    final title = titleController.text.trim();
    final amountText = amountController.text.trim();
    
    if (title.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a title or description',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF95B51),
        colorText: Colors.white,
      );
      return false;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid amount greater than 0',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF95B51),
        colorText: Colors.white,
      );
      return false;
    }

    final tx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      isIncome: isIncome.value,
      category: selectedCategory.value,
      dateTime: selectedDate.value,
    );

    _service.addTransaction(tx);
    return true;
  }

  List<TransactionModel> get allTransactions => _service.transactions;

  void deleteTransaction(String id) {
    _service.deleteTransaction(id);
  }
}
