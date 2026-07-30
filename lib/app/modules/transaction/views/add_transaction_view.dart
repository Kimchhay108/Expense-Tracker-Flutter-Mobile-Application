import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';

class AddTransactionView extends GetView<TransactionController> {
  final bool initialIsIncome;
  const AddTransactionView({super.key, this.initialIsIncome = false});

  @override
  Widget build(BuildContext context) {
    // Reset form with initial type
    controller.resetForm(typeIsIncome: initialIsIncome);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Teal Curved Header
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF429690), Color(0xFF2E7E78)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  right: -20,
                  top: -20,
                  child: Opacity(
                    opacity: 0.1,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                              onPressed: () => Get.back(),
                            ),
                            const Text(
                              'Add Transaction',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 48), // Spacer for center alignment
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Form Card overlapping
                Container(
                  margin: const EdgeInsets.only(top: 130, left: 20, right: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toggle Button for Income / Expense
                      Center(
                        child: Obx(() => Container(
                              height: 48,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F6F6),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Row(
                                children: [
                                  _buildToggleTab('Expense', false),
                                  _buildToggleTab('Income', true),
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(height: 30),
                      // Amount Label
                      const Text(
                        'Amount',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Large Styled Amount Input
                      Obx(() => Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: const Color(0xFF666666).withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: controller.amountController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: controller.isIncome.value
                                    ? const Color(0xFF24A869)
                                    : const Color(0xFFF95B51),
                              ),
                              decoration: const InputDecoration(
                                prefixText: '\$ ',
                                hintText: '0.00',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          )),
                      const SizedBox(height: 24),
                      // Name/Title field
                      const Text(
                        'Title / Description',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.titleController,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'e.g. Starbucks, Freelance Payment',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: const Color(0xFF666666).withValues(alpha: 0.2)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF438883), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Category Dropdown
                      const Text(
                        'Category',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<String>(
                            value: controller.selectedCategory.value,
                            items: controller.categories
                                .map((cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat),
                                    ))
                                .toList(),
                            onChanged: (val) => controller.setCategory(val ?? 'Other'),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: const Color(0xFF666666).withValues(alpha: 0.2)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF438883), width: 1.5),
                              ),
                            ),
                          )),
                      const SizedBox(height: 24),
                      // Date Selector
                      const Text(
                        'Date',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Obx(() => Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color(0xFF666666).withValues(alpha: 0.2),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDate(controller.selectedDate.value),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  const Icon(Icons.calendar_today_rounded, color: Color(0xFF438883), size: 20),
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(height: 40),
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.saveTransaction()) {
                              Get.back();
                              Get.snackbar(
                                'Success',
                                'Transaction added successfully',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: const Color(0xFF24A869),
                                colorText: Colors.white,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF438883),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: const Color(0xFF438883).withValues(alpha: 0.3),
                          ),
                          child: const Text(
                            'Save Transaction',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTab(String label, bool isIncomeTab) {
    final isActive = controller.isIncome.value == isIncomeTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleType(isIncomeTab),
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
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF222222) : const Color(0xFF666666),
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF438883),
              onPrimary: Colors.white,
              onSurface: Color(0xFF222222),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.setDate(picked);
    }
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
