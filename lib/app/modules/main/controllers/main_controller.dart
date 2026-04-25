import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController with GetSingleTickerProviderStateMixin {
  // Tab controller for switching tabs
  late TabController tabController;

  // Reactive variable to track the current page index
  var currentPage = 0.obs;

  // Example variable for other functions
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      currentPage.value = tabController.index;
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Any code you want to run once the controller is ready
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // Example function you had before
  void increment() => count.value++;
}
