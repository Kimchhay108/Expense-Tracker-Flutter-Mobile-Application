import 'package:expense_tracker/app/modules/home/views/home_view.dart';
import 'package:expense_tracker/app/modules/setting/views/setting_view.dart';
import 'package:expense_tracker/app/modules/statistic/views/statistic_view.dart';
import 'package:expense_tracker/app/modules/wallet/views/wallet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:get_cli/common/utils/json_serialize/json_ast/error.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
    ];

    final unselectedColor = Colors.grey;

    return Scaffold(
      body: Obx(() => BottomBar(
            
            fit: StackFit.expand,
            borderRadius: BorderRadius.circular(500),
            duration: const Duration(milliseconds: 800),
            curve: Curves.decelerate,
            showIcon: true,
            width: MediaQuery.of(context).size.width * 0.8,
            barColor:
                Color(Colors.white.value),
            start: 2,
            end: 0,
            offset: 10,
            barAlignment: Alignment.bottomCenter,
            iconHeight: 35,
            iconWidth: 35,
            reverse: false,
            
            barDecoration: BoxDecoration(
              color: colors[controller.currentPage.value],
              borderRadius: BorderRadius.circular(500),
              
            ),
            iconDecoration: BoxDecoration(
              color: colors[controller.currentPage.value],
              borderRadius: BorderRadius.circular(500),
            ),
            hideOnScroll: true,
            scrollOpposite: false,
            onBottomBarHidden: () {},
            onBottomBarShown: () {},

            // screens
            body: (context, _) => TabBarView(
              controller: controller.tabController,
              physics: const BouncingScrollPhysics(),
              children: const [
                const HomeView(),
                const StatisticView(),
                const WalletView(),
                const SettingView()
              ],
            ),

            // bottom tabs
            child: TabBar(
              controller: controller.tabController,
              tabs: const [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.wallet)),
                Tab(icon: Icon(Icons.bar_chart)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          )),
    );
  }
}
