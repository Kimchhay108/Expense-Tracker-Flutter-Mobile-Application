import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class TransactionService extends GetxService {
  late SharedPreferences _prefs;

  final transactions = <TransactionModel>[].obs;
  final upcomingBills = <BillModel>[].obs;

  // Profile data
  final userName = 'Enjelin Morgeana'.obs;
  final userHandle = '@enjelin_morgeana'.obs;
  final avatarUrl = 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200'.obs;

  // Computations
  double get totalBalance => totalIncome - totalExpenses;
  
  double get totalIncome => transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  Future<TransactionService> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadProfile();
    await _loadTransactions();
    await _loadBills();
    return this;
  }

  // Load transactions
  Future<void> _loadTransactions() async {
    final String? txStr = _prefs.getString('transactions_list');
    if (txStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(txStr);
        transactions.assignAll(
          decoded.map((item) => TransactionModel.fromJson(item)).toList(),
        );
        // Sort newest first
        _sortTransactions();
      } catch (e) {
        _loadDefaultTransactions();
      }
    } else {
      _loadDefaultTransactions();
    }
  }

  void _loadDefaultTransactions() {
    final now = DateTime.now();
    final list = [
      TransactionModel(
        id: 't1',
        title: 'Salary for July',
        amount: 5000.00,
        isIncome: true,
        category: 'Salary',
        dateTime: now.subtract(const Duration(days: 1, hours: 5)),
      ),
      TransactionModel(
        id: 't2',
        title: 'Upwork',
        amount: 850.00,
        isIncome: true,
        category: 'Salary',
        dateTime: now.subtract(const Duration(hours: 1)),
      ),
      TransactionModel(
        id: 't3',
        title: 'Paypal',
        amount: 1406.00,
        isIncome: true,
        category: 'Salary',
        dateTime: DateTime(now.year, now.month - 1, 30, 10, 0),
      ),
      TransactionModel(
        id: 't4',
        title: 'Shopping',
        amount: 120.00,
        isIncome: false,
        category: 'Shopping',
        dateTime: now.subtract(const Duration(hours: 4)),
      ),
      TransactionModel(
        id: 't5',
        title: 'Subscription',
        amount: 80.00,
        isIncome: false,
        category: 'Subscription',
        dateTime: now.subtract(const Duration(minutes: 30)),
      ),
      TransactionModel(
        id: 't6',
        title: 'Food',
        amount: 32.00,
        isIncome: false,
        category: 'Food',
        dateTime: now.subtract(const Duration(minutes: 5)),
      ),
      TransactionModel(
        id: 't7',
        title: 'Transportation',
        amount: 18.00,
        isIncome: false,
        category: 'Transportation',
        dateTime: now.subtract(const Duration(days: 1, hours: 1)),
      ),
      TransactionModel(
        id: 't8',
        title: 'Starbucks',
        amount: 150.00,
        isIncome: false,
        category: 'Food',
        dateTime: DateTime(now.year, now.month - 1, 12, 14, 0),
      ),
      TransactionModel(
        id: 't9',
        title: 'Transfer',
        amount: 85.00,
        isIncome: false,
        category: 'Transfer',
        dateTime: now.subtract(const Duration(days: 1, hours: 8)),
      ),
      TransactionModel(
        id: 't10',
        title: 'Youtube',
        amount: 11.99,
        isIncome: false,
        category: 'Subscription',
        dateTime: DateTime(now.year, now.month - 1, 16, 11, 0),
      ),
    ];
    transactions.assignAll(list);
    _sortTransactions();
    _saveTransactionsToStorage();
  }

  // Load upcoming bills
  Future<void> _loadBills() async {
    final String? billsStr = _prefs.getString('upcoming_bills');
    if (billsStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(billsStr);
        upcomingBills.assignAll(
          decoded.map((item) => BillModel.fromJson(item)).toList(),
        );
      } catch (e) {
        _loadDefaultBills();
      }
    } else {
      _loadDefaultBills();
    }
  }

  void _loadDefaultBills() {
    final now = DateTime.now();
    final list = [
      BillModel(
        id: 'b1',
        title: 'Figma Subscription',
        amount: 15.00,
        dueDate: DateTime(now.year, now.month, now.day + 3),
        category: 'Subscription',
      ),
      BillModel(
        id: 'b2',
        title: 'Adobe Creative Cloud',
        amount: 54.99,
        dueDate: DateTime(now.year, now.month, now.day + 6),
        category: 'Subscription',
      ),
      BillModel(
        id: 'b3',
        title: 'Office Utilities',
        amount: 120.00,
        dueDate: DateTime(now.year, now.month, now.day + 11),
        category: 'Utilities',
      ),
    ];
    upcomingBills.assignAll(list);
    _saveBillsToStorage();
  }

  // Load profile data
  Future<void> _loadProfile() async {
    userName.value = _prefs.getString('profile_name') ?? 'Enjelin Morgeana';
    userHandle.value = _prefs.getString('profile_handle') ?? '@enjelin_morgeana';
    avatarUrl.value = _prefs.getString('profile_avatar') ?? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200';
  }

  // Save actions
  Future<void> _saveTransactionsToStorage() async {
    final String encoded = jsonEncode(
      transactions.map((t) => t.toJson()).toList(),
    );
    await _prefs.setString('transactions_list', encoded);
  }

  Future<void> _saveBillsToStorage() async {
    final String encoded = jsonEncode(
      upcomingBills.map((b) => b.toJson()).toList(),
    );
    await _prefs.setString('upcoming_bills', encoded);
  }

  Future<void> updateProfile(String name, String handle, String avatar) async {
    userName.value = name;
    userHandle.value = handle;
    avatarUrl.value = avatar;
    await _prefs.setString('profile_name', name);
    await _prefs.setString('profile_handle', handle);
    await _prefs.setString('profile_avatar', avatar);
  }

  // Add a new transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    transactions.add(transaction);
    _sortTransactions();
    await _saveTransactionsToStorage();
  }

  // Delete a transaction
  Future<void> deleteTransaction(String id) async {
    transactions.removeWhere((t) => t.id == id);
    await _saveTransactionsToStorage();
  }

  // Pay a bill (mark paid and convert to expense)
  Future<void> payBill(String billId) async {
    final int index = upcomingBills.indexWhere((b) => b.id == billId);
    if (index != -1) {
      final bill = upcomingBills[index];
      // Create transaction expense
      final newTx = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Paid: ${bill.title}',
        amount: bill.amount,
        isIncome: false,
        category: bill.category,
        dateTime: DateTime.now(),
      );
      
      // Update bill state
      upcomingBills.removeAt(index);
      
      await addTransaction(newTx);
      await _saveBillsToStorage();
    }
  }

  void _sortTransactions() {
    transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }
}
