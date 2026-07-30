import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/views/home_view.dart';
import '../../statistic/views/statistic_view.dart';
import '../../wallet/views/wallet_view.dart';
import '../../setting/views/setting_view.dart';
import '../../transaction/views/add_transaction_view.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: controller.tabController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe for direct tabs
        children: const [
          HomeView(),
          StatisticView(),
          WalletView(),
          SettingView(),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 20), // Slight offset downward to sit in the notch nicely
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => const AddTransactionView());
          },
          backgroundColor: const Color(0xFF438883),
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() => BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            elevation: 10,
            shadowColor: Colors.black.withValues(alpha: 0.3),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Tab 0: Home
                  _buildTabIcon(0, Icons.home_rounded, Icons.home_outlined),
                  // Tab 1: Statistics
                  _buildTabIcon(1, Icons.bar_chart_rounded, Icons.bar_chart_rounded),
                  const SizedBox(width: 48), // Gap for FAB
                  // Tab 2: Wallet
                  _buildTabIcon(2, Icons.account_balance_wallet_rounded, Icons.account_balance_wallet_outlined),
                  // Tab 3: Profile/Settings
                  _buildTabIcon(3, Icons.person_rounded, Icons.person_outline_rounded),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildTabIcon(int index, IconData activeIcon, IconData inactiveIcon) {
    final isSelected = controller.currentPage.value == index;
    return IconButton(
      icon: Icon(
        isSelected ? activeIcon : inactiveIcon,
        color: isSelected ? const Color(0xFF438883) : const Color(0xFFC5C5C5),
        size: 28,
      ),
      onPressed: () {
        controller.tabController.animateTo(index);
        controller.currentPage.value = index;
      },
    );
  }
}
