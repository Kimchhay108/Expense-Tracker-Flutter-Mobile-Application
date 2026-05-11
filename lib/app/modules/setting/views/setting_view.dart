import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFF5F5F5), width: 4),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFAD00FF),
                                  blurRadius: 0,
                                  offset: Offset(0, 0),
                                  spreadRadius: 6,
                                ),
                              ],
                              image: const DecorationImage(
                                image: NetworkImage('https://placehold.co/80x80'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(height: 10),
                                Text(
                                  'Username',
                                  style: TextStyle(
                                    color: Color(0xFF90909F),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Iriana Saliha',
                                  style: TextStyle(
                                    color: Color(0xFF161719),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _OutlinedActionButton(
                            icon: Icons.edit_outlined,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: const [
                          _SettingTile(
                            backgroundColor: Colors.white,
                            iconBackground: Color(0xFFEEE5FF),
                            icon: Icons.person_outline,
                            title: 'Account',
                            trailing: true,
                            topRadius: true,
                          ),
                          _SettingTile(
                            backgroundColor: Colors.white,
                            iconBackground: Color(0xFFEEE5FF),
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            trailing: false,
                          ),
                          _SettingTile(
                            backgroundColor: Colors.white,
                            iconBackground: Color(0xFFEEE5FF),
                            icon: Icons.upload_outlined,
                            title: 'Export Data',
                            trailing: false,
                          ),
                          _SettingTile(
                            backgroundColor: Colors.white,
                            iconBackground: Color(0xFFFFE2E4),
                            icon: Icons.logout,
                            title: 'Logout',
                            trailing: false,
                            bottomRadius: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFF1F1FA)),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: const Color(0xFF212224)),
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.backgroundColor,
    required this.iconBackground,
    required this.icon,
    required this.title,
    required this.trailing,
    this.topRadius = false,
    this.bottomRadius = false,
  });

  final Color backgroundColor;
  final Color iconBackground;
  final IconData icon;
  final String title;
  final bool trailing;
  final bool topRadius;
  final bool bottomRadius;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.vertical(
      top: topRadius ? const Radius.circular(24) : Radius.zero,
      bottom: bottomRadius ? const Radius.circular(24) : Radius.zero,
    );

    return Container(
      width: double.infinity,
      height: 89,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32, color: const Color(0xFF161719)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF292B2D),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing)
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFC5C5C5)),
        ],
      ),
    );
  }
}
