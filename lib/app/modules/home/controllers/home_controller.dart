import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/services/transaction_service.dart';

class ContactItem {
  final String name;
  final String imageUrl;

  ContactItem({required this.name, required this.imageUrl});
}

class HomeController extends GetxController {
  final _service = Get.find<TransactionService>();

  RxString get userName => _service.userName;
  final greetPrefix = 'Good afternoon,'.obs;

  double get totalBalance => _service.totalBalance;
  double get income => _service.totalIncome;
  double get expenses => _service.totalExpenses;

  // Recent transactions list
  List<TransactionModel> get transactions => _service.transactions;

  final contacts = <ContactItem>[
    ContactItem(name: 'Mona', imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop'),
    ContactItem(name: 'Jeff', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop'),
    ContactItem(name: 'Sarah', imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop'),
    ContactItem(name: 'David', imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop'),
    ContactItem(name: 'Elena', imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop'),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _updateGreeting();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greetPrefix.value = 'Good morning,';
    } else if (hour < 17) {
      greetPrefix.value = 'Good afternoon,';
    } else {
      greetPrefix.value = 'Good evening,';
    }
  }

  void transferToContact(ContactItem contact, double amount) {
    final newTx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Transfer to ${contact.name}',
      amount: amount,
      isIncome: false,
      category: 'Transfer',
      dateTime: DateTime.now(),
      contactName: contact.name,
    );
    _service.addTransaction(newTx);
  }
}
