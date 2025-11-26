import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../models/dashboard_model.dart';

class OrdersLineChart extends StatelessWidget {
  final List<OrdersPerMonth> data;
  final int minPoints;

  const OrdersLineChart({
    super.key,
    required this.data,
    this.minPoints = 3,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 VALIDACIONES DINÁMICAS
    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text(
          "No hay datos disponibles",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (data.length < minPoints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          context.l10n.orders_chart_not_enough_data(
            data.length,
            minPoints,
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    // 🔥 SI HAY DATOS SUFICIENTES → RENDERIZAR GRÁFICA
    final processedData = data;

    return SizedBox(
      height: 230,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= processedData.length) {
                    return const SizedBox();
                  }

                  final monthStr = processedData[index].month;

                  return Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      _formatMonth(monthStr),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0; i < processedData.length; i++)
                  FlSpot(i.toDouble(), processedData[i].count.toDouble())
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.25),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // UTIL: Formatear yyyy-MM → Ene, Feb, Mar...
  // ---------------------------------------------------
  String _formatMonth(String isoMonth) {
    final monthNames = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];

    try {
      final month = int.parse(isoMonth.split('-')[1]);
      return monthNames[month - 1];
    } catch (_) {
      return isoMonth;
    }
  }
}
