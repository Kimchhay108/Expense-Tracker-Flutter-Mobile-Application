import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF438883), // Top header fallback
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Bottom area background
            Positioned.fill(
              top: 150,
              child: Container(
                color: Colors.white,
              ),
            ),
            // Teal Header
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
                              'Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
            // White Sheet Area
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
                    padding: const EdgeInsets.only(top: 24, bottom: 40),
                    child: Column(
                      children: [
                        // Avatar
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            child: ClipOval(
                              child: Obx(() => Image.network(
                                    controller.avatarUrl.value,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: const Color(0xFFC4C4C4),
                                      child: const Icon(Icons.person, size: 60, color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Name & Handle
                        Obx(() => Text(
                              controller.userName.value,
                              style: const TextStyle(
                                color: Color(0xFF222222),
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        const SizedBox(height: 6),
                        Obx(() => Text(
                              controller.userHandle.value,
                              style: const TextStyle(
                                color: Color(0xFF438883),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        const SizedBox(height: 30),
                        // Options List
                        _buildOptionsList(context),
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

  Widget _buildOptionsList(BuildContext context) {
    return Column(
      children: [
        // "Invite Friends" Tile
        _buildSettingOptionTile(context, controller.options[0]),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Divider(color: Color(0xFFEEEEEE), height: 1),
        ),
        // Rest of settings options
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.options.length - 1,
          itemBuilder: (context, index) {
            // Skips the first item ("Invite Friends")
            final option = controller.options[index + 1];
            return _buildSettingOptionTile(context, option);
          },
        ),
      ],
    );
  }

  Widget _buildSettingOptionTile(BuildContext context, SettingOption option) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: InkWell(
        onTap: () {
          if (option.title == 'Personal profile' || option.title == 'Account info') {
            _showEditProfileBottomSheet(context);
          } else if (option.title == 'Invite Friends') {
            _showInviteBottomSheet();
          } else {
            _showSimulatedSettingBottomSheet(option.title);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: option.isInvite ? const Color(0xFF00B495) : const Color(0xFFF0F6F5),
                ),
                child: Icon(
                  option.icon,
                  color: option.isInvite ? Colors.white : const Color(0xFF438883),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              // Option Title
              Expanded(
                child: Text(
                  option.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Trailing Arrow
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFC5C5C5),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileBottomSheet(BuildContext context) {
    final nameController = TextEditingController(text: controller.userName.value);
    final handleController = TextEditingController(text: controller.userHandle.value);
    final avatarController = TextEditingController(text: controller.avatarUrl.value);

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Edit Profile Info',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 20),
              const Text('Full Name', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF438883), width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('User Handle', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
              const SizedBox(height: 8),
              TextField(
                controller: handleController,
                decoration: const InputDecoration(
                  hintText: 'Enter handle, e.g. @name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF438883), width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Profile Avatar URL', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
              const SizedBox(height: 8),
              TextField(
                controller: avatarController,
                decoration: const InputDecoration(
                  hintText: 'Enter image url',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF438883), width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final handle = handleController.text.trim();
                    final avatar = avatarController.text.trim();

                    if (name.isEmpty || handle.isEmpty || avatar.isEmpty) {
                      Get.snackbar(
                        'Validation Error',
                        'Please fill all the profile fields',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: const Color(0xFFF95B51),
                        colorText: Colors.white,
                      );
                      return;
                    }

                    controller.updateProfile(name, handle, avatar);
                    Get.back();
                    Get.snackbar(
                      'Profile Updated',
                      'Your settings have been saved successfully',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: const Color(0xFF24A869),
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF438883),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showInviteBottomSheet() {
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
            const Icon(Icons.people_outline_rounded, size: 60, color: Color(0xFF00B495)),
            const SizedBox(height: 16),
            const Text(
              'Invite Friends',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Share your invite code with friends to earn together!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'EXPENSE-TRACKER-2026',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF438883)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: Color(0xFF438883)),
                    onPressed: () {
                      Get.rawSnackbar(
                        messageText: const Text('Code copied to clipboard!', style: TextStyle(color: Colors.white)),
                        backgroundColor: const Color(0xFF222222),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF438883),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Close',
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

  void _showSimulatedSettingBottomSheet(String title) {
    RxBool toggleVal1 = true.obs;
    RxBool toggleVal2 = false.obs;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure settings for $title',
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 24),
            Obx(() => SwitchListTile(
                  title: const Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Get real-time updates for transactions'),
                  value: toggleVal1.value,
                  activeColor: const Color(0xFF438883),
                  onChanged: (val) => toggleVal1.value = val,
                )),
            Obx(() => SwitchListTile(
                  title: const Text('Biometric Authentication', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Secure access using fingerprint or Face ID'),
                  value: toggleVal2.value,
                  activeColor: const Color(0xFF438883),
                  onChanged: (val) => toggleVal2.value = val,
                )),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Settings Saved',
                    'Preferences for $title have been updated',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFF24A869),
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF438883),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Done',
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
}
