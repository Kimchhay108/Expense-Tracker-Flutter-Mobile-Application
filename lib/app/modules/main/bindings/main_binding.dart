import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../transaction/controllers/transaction_controller.dart';
import '../../wallet/controllers/wallet_controller.dart';
import '../../setting/controllers/setting_controller.dart';
import '../../statistic/controllers/statistic_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<TransactionController>(
      () => TransactionController(),
    );
    Get.lazyPut<WalletController>(
      () => WalletController(),
    );
    Get.lazyPut<SettingController>(
      () => SettingController(),
    );
    Get.lazyPut<StatisticController>(
      () => StatisticController(),
    );
  }
}
