import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controllers/statistic_controller.dart';

class StatisticView extends GetView<StatisticController> {
  const StatisticView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF222222),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Color(0xFF222222),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Period Tab Selector
            _buildPeriodSelector(),
            const SizedBox(height: 16),
            // Line Chart & Dropdown
            _buildChartSection(context),
            const SizedBox(height: 32),
            // Top Spending List
            _buildTopSpendingSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            controller.periods.map((period) {
              return Obx(() {
                final isSelected = controller.activePeriod.value == period;
                return GestureDetector(
                  onTap: () => controller.selectPeriod(period),
                  child: Container(
                    width: 80,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xFF438883)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      period,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : const Color(0xFF666666),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
      ),
    );
  }

  Widget _buildChartSection(BuildContext context) {
    return Column(
      children: [
        // Dropdown selection (Expense / Income)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<String>(
              onSelected: controller.selectType,
              itemBuilder: (BuildContext context) {
                return controller.filterTypes.map((String type) {
                  return PopupMenuItem<String>(value: type, child: Text(type));
                }).toList();
              },
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF666666).withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.activeType.value,
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF666666),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Line Chart
        Container(
          height: 220,
          padding: const EdgeInsets.only(left: 10, right: 20),
          child: Obx(() {
            final spots =
                controller.chartValues.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value);
                }).toList();

            final lineBarData = LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF438883),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  if (index == controller.selectedPointIndex.value) {
                    return FlDotCirclePainter(
                      radius: 8,
                      color: const Color(0xFF438883),
                      strokeWidth: 3,
                      strokeColor: Colors.white,
                    );
                  }
                  return FlDotCirclePainter(
                    radius: 0,
                    color: Colors.transparent,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF438883).withValues(alpha: 0.3),
                    const Color(0xFF438883).withValues(alpha: 0.0),
                  ],
                ),
              ),
            );

            return LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchCallback: (
                    FlTouchEvent event,
                    LineTouchResponse? touchResponse,
                  ) {
                    if (touchResponse != null &&
                        touchResponse.lineBarSpots != null) {
                      final spot = touchResponse.lineBarSpots!.first;
                      controller.selectPoint(spot.x.toInt());
                    }
                  },
                  handleBuiltInTouches: true,
                  getTouchedSpotIndicator: (
                    LineChartBarData barData,
                    List<int> spotIndexes,
                  ) {
                    return spotIndexes.map((spotIndex) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: const Color(0xFF666666).withValues(alpha: 0.5),
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                        FlDotData(show: false),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => const Color(0xFF438883),
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '\$${barSpot.y.toInt()}',
                          const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= controller.labels.length) {
                          return const SizedBox.shrink();
                        }
                        final isSelected =
                            index == controller.selectedPointIndex.value;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.labels[index],
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? const Color(0xFF438883)
                                      : const Color(0xFF666666),
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                              fontFamily: 'Inter',
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: controller.chartMaxY,
                lineBarsData: [lineBarData],
                showingTooltipIndicators: [
                  ShowingTooltipIndicators([
                    LineBarSpot(
                      lineBarData,
                      0,
                      lineBarData.spots[controller.selectedPointIndex.value],
                    ),
                  ]),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTopSpendingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Spending',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.swap_vert_rounded,
                  color: Color(0xFF222222),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(
            () => ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.topSpending.length,
              itemBuilder: (context, index) {
                final item = controller.topSpending[index];
                final isHL = item.isHighlighted;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isHL
                            ? const Color(0xFF29756F)
                            : const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:
                        isHL
                            ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF29756F,
                                ).withValues(alpha: 0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ]
                            : null,
                  ),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              isHL
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : item.iconBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.icon,
                          color: isHL ? Colors.white : item.iconColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                color: isHL ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.date,
                              style: TextStyle(
                                color:
                                    isHL
                                        ? const Color(0xFFEEEEEE)
                                        : const Color(0xFF666666),
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
                        '${controller.activeType.value == 'Expense' ? '-' : '+'} \$ ${item.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color:
                              isHL
                                  ? Colors.white
                                  : (controller.activeType.value == 'Expense'
                                      ? const Color(0xFFF95B51)
                                      : const Color(0xFF24A869)),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
