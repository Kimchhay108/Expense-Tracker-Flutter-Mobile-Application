import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/services/transaction_service.dart';

class WalletController extends GetxController {
  final _service = Get.find<TransactionService>();

  double get totalBalance => _service.totalBalance;
  final activeTabIndex = 0.obs; // 0: Transactions, 1: Upcoming Bills

  // Bind to service lists
  List<TransactionModel> get transactions => _service.transactions;
  List<BillModel> get upcomingBills => _service.upcomingBills;

  void selectTab(int index) {
    activeTabIndex.value = index;
  }

  Future<void> payUpcomingBill(String billId) async {
    await _service.payBill(billId);
  }

  void addSimulatedQRPayment(String merchant, double amount, String category) {
    final newTx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: merchant,
      amount: amount,
      isIncome: false,
      category: category,
      dateTime: DateTime.now(),
    );
    _service.addTransaction(newTx);
  }
}
