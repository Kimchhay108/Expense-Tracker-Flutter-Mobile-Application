import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../transaction/views/add_transaction_view.dart';
import '../controllers/wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF438883), // Top header color fallback
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background Color for Bottom Area
            Positioned.fill(
              top: 150,
              child: Container(
                color: Colors.white,
              ),
            ),
            // Top Teal Curved Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 170,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF429690), Color(0xFF2E7E78)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background Circles
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Opacity(
                        opacity: 0.1,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -40,
                      top: 50,
                      child: Opacity(
                        opacity: 0.1,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Header Bar Content
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                              onPressed: () => Get.back(),
                            ),
                            const Text(
                              'Wallet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Notification Bell (simulated)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Scrollable White Sheet Area
            Positioned.fill(
              top: 140, // Overlay card top
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      children: [
                        const Text(
                          'Total Balance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Amount Display
                        Obx(() => Text(
                              '\$ ${controller.totalBalance.toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF222222),
                                fontSize: 30,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.0,
                              ),
                            )),
                        const SizedBox(height: 24),
                        // Actions Row (Add, Pay, Send)
                        _buildActionsRow(context),
                        const SizedBox(height: 32),
                        // Segmented selector (Transactions vs Upcoming Bills)
                        _buildSegmentedControl(),
                        const SizedBox(height: 20),
                        // List details based on active tab
                        Obx(() {
                          if (controller.activeTabIndex.value == 0) {
                            return _buildTransactionsList();
                          } else {
                            return _buildUpcomingBillsList(context);
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          label: 'Add',
          icon: Icons.add_rounded,
          onTap: () => Get.to(() => const AddTransactionView(initialIsIncome: true)),
        ),
        _buildActionButton(
          label: 'Pay',
          icon: Icons.qr_code_scanner_rounded,
          onTap: () => _showQRScanBottomSheet(context),
        ),
        _buildActionButton(
          label: 'Send',
          icon: Icons.arrow_outward_rounded,
          onTap: () => Get.to(() => const AddTransactionView(initialIsIncome: false)),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF549994), width: 1.2),
            ),
            child: Icon(icon, color: const Color(0xFF549994), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF222222),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F6),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          // Transactions Tab
          Expanded(
            child: Obx(() {
              final isActive = controller.activeTabIndex.value == 0;
              return GestureDetector(
                onTap: () => controller.selectTab(0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Text(
                    'Transactions',
                    style: TextStyle(
                      color: isActive ? const Color(0xFF222222) : const Color(0xFF666666),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }),
          ),
          // Upcoming Bills Tab
          Expanded(
            child: Obx(() {
              final isActive = controller.activeTabIndex.value == 1;
              return GestureDetector(
                onTap: () => controller.selectTab(1),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Text(
                    'Upcoming Bills',
                    style: TextStyle(
                      color: isActive ? const Color(0xFF222222) : const Color(0xFF666666),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    final list = controller.transactions;
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            'No transactions recorded yet',
            style: TextStyle(color: Color(0xFF666666)),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: item.iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: item.iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Title & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(item.dateTime),
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount
              Text(
                '${item.isIncome ? '+' : '-'} \$ ${item.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: item.isIncome ? const Color(0xFF24A869) : const Color(0xFFF95B51),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpcomingBillsList(BuildContext context) {
    final list = controller.upcomingBills;
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            'All bills are paid! 🎉',
            style: TextStyle(color: Color(0xFF666666), fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: InkWell(
            onTap: () => _showBillPayBottomSheet(context, item),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: item.category == 'Subscription' ? const Color(0xFFEEE5FF) : const Color(0xFFFFF2E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.category == 'Subscription' ? Icons.subscriptions_rounded : Icons.lightbulb_outline_rounded,
                      color: item.category == 'Subscription' ? const Color(0xFF7E3DFF) : const Color(0xFFFF9800),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title & Due Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Due: ${_formatDate(item.dueDate)}',
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Amount
                  Text(
                    '\$ ${item.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBillPayBottomSheet(BuildContext context, BillModel bill) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.event_note_rounded, size: 60, color: Color(0xFF549994)),
            const SizedBox(height: 16),
            Text(
              'Pay Bill',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Confirm payment for "${bill.title}"',
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount Due', style: TextStyle(color: Color(0xFF666666))),
                Text(
                  '\$${bill.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF222222)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Due Date', style: TextStyle(color: Color(0xFF666666))),
                Text(
                  _formatDate(bill.dueDate),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.totalBalance < bill.amount) {
                    Get.back();
                    Get.snackbar(
                      'Insufficient Funds',
                      'You do not have enough wallet balance to pay this bill',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: const Color(0xFFF95B51),
                      colorText: Colors.white,
                    );
                    return;
                  }
                  await controller.payUpcomingBill(bill.id);
                  Get.back();
                  _showSuccessDialog('Bill Payment', bill.amount, 'Paid "${bill.title}" successfully.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF438883),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showQRScanBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: 350,
        decoration: const BoxDecoration(
          color: Color(0xFF222222),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Scan Merchant QR',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF438883), width: 3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const _QRLaserAnimator(),
              ),
            ),
          ],
        ),
      ),
    );

    // Simulate scanning time (1.5 seconds)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (Get.isBottomSheetOpen ?? false) {
        Get.back(); // close scanner sheet
        _showQRVerifyBottomSheet();
      }
    });
  }

  void _showQRVerifyBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.qr_code_2_rounded, size: 60, color: Color(0xFF438883)),
            const SizedBox(height: 16),
            const Text(
              'Verify QR Code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Simulated merchant scanned',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Merchant Name', style: TextStyle(color: Color(0xFF666666))),
                Text(
                  'McDonald\'s Resto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount', style: TextStyle(color: Color(0xFF666666))),
                Text(
                  '\$18.45',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF222222)),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.totalBalance < 18.45) {
                    Get.back();
                    Get.snackbar(
                      'Insufficient Funds',
                      'You do not have enough wallet balance to complete this transaction',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: const Color(0xFFF95B51),
                      colorText: Colors.white,
                    );
                    return;
                  }
                  controller.addSimulatedQRPayment('McDonald\'s Store', 18.45, 'Food');
                  Get.back();
                  _showSuccessDialog('Merchant Pay', 18.45, 'Paid McDonald\'s successfully.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF438883),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Confirm Payment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(String title, double amount, String subtitle) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE2F6F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF24A869),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF438883),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class _QRLaserAnimator extends StatefulWidget {
  const _QRLaserAnimator();

  @override
  State<_QRLaserAnimator> createState() => _QRLaserAnimatorState();
}

class _QRLaserAnimatorState extends State<_QRLaserAnimator> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.05, end: 0.95).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 180 * _animation.value,
              left: 10,
              right: 10,
              child: Container(
                height: 3,
                decoration: const BoxDecoration(
                  color: Color(0xFF00FFCC),
                  boxShadow: [
                    BoxShadow(color: Color(0xFF00FFCC), blurRadius: 8, spreadRadius: 1),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}