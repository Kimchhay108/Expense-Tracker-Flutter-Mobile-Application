import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/transaction_service.dart';

class SettingOption {
  final String title;
  final IconData icon;
  final bool isInvite;

  SettingOption({
    required this.title,
    required this.icon,
    this.isInvite = false,
  });
}

class SettingController extends GetxController {
  final _service = Get.find<TransactionService>();

  RxString get userName => _service.userName;
  RxString get userHandle => _service.userHandle;
  RxString get avatarUrl => _service.avatarUrl;

  final options = <SettingOption>[
    SettingOption(
      title: 'Invite Friends',
      icon: Icons.people_outline_rounded,
      isInvite: true,
    ),
    SettingOption(
      title: 'Account info',
      icon: Icons.account_circle_outlined,
    ),
    SettingOption(
      title: 'Personal profile',
      icon: Icons.person_outline_rounded,
    ),
    SettingOption(
      title: 'Message center',
      icon: Icons.chat_bubble_outline_rounded,
    ),
    SettingOption(
      title: 'Login and security',
      icon: Icons.security_rounded,
    ),
    SettingOption(
      title: 'Data and privacy',
      icon: Icons.privacy_tip_outlined,
    ),
  ].obs;

  void updateProfile(String name, String handle, String avatar) {
    _service.updateProfile(name, handle, avatar);
  }
}
