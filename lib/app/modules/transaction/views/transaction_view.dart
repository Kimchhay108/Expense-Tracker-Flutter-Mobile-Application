import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/transaction_controller.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF222222)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          final txs = controller.allTransactions;
          if (txs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded, size: 80, color: Color(0xFFC5C5C5)),
                  SizedBox(height: 16),
                  Text(
                    'No transactions recorded yet',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final grouped = _groupTransactions(txs);

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 10),
              _ReportBanner(onPressed: () {
                // Navigate to Statistics tab in MainView
                try {
                  final mainController = Get.find<MainController>();
                  mainController.tabController.animateTo(1);
                  mainController.currentPage.value = 1;
                  Get.back();
                } catch (_) {
                  // Fallback
                  Get.back();
                }
              }),
              const SizedBox(height: 20),
              ...grouped.entries.map((entry) {
                final dateLabel = entry.key;
                final items = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 12),
                      child: Text(
                        dateLabel,
                        style: const TextStyle(
                          color: Color(0xFF0D0E0F),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Dismissible(
                            key: Key(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFD3C4A),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onDismissed: (direction) {
                              controller.deleteTransaction(item.id);
                              Get.rawSnackbar(
                                messageText: Text(
                                  '"${item.title}" deleted',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: const Color(0xFF222222),
                                duration: const Duration(seconds: 2),
                              );
                            },
                            child: _TransactionTile(item: item),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
              const SizedBox(height: 80),
            ],
          );
        }),
      ),
    );
  }

  Map<String, List<TransactionModel>> _groupTransactions(List<TransactionModel> txs) {
    final Map<String, List<TransactionModel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var tx in txs) {
      final txDate = DateTime(tx.dateTime.year, tx.dateTime.month, tx.dateTime.day);
      String key;
      if (txDate == today) {
        key = 'Today';
      } else if (txDate == yesterday) {
        key = 'Yesterday';
      } else {
        const months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        key = '${months[tx.dateTime.month - 1]} ${tx.dateTime.day}, ${tx.dateTime.year}';
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(tx);
    }
    return grouped;
  }
}

class _ReportBanner extends StatelessWidget {
  const _ReportBanner({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEEE5FF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'See your financial report',
                  style: TextStyle(
                    color: Color(0xFF7E3DFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF7E3DFF), size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel item;
  const _TransactionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final timeStr = '${item.dateTime.hour.toString().padLeft(2, '0')}:${item.dateTime.minute.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: item.iconBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF292B2D),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.category,
                  style: const TextStyle(
                    color: Color(0xFF90909F),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.isIncome ? '+' : '-'} \$${item.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: item.isIncome ? const Color(0xFF00A86B) : const Color(0xFFFD3C4A),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                timeStr,
                style: const TextStyle(
                  color: Color(0xFF90909F),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
