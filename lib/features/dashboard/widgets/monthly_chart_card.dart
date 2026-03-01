import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dashboard_stats.dart';
import '../../../core/utils/app_localizations.dart';

class MonthlyChartCard extends StatelessWidget {
  final List<MonthlyData> data;

  const MonthlyChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print('📊 MonthlyChartCard build started');
    print('  - Data length: ${data.length}');
    print('  - Data: $data');
    
    // Inspect each data item
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      print('  - Item $i:');
      print('    - month: "${item.month}" (${item.month.runtimeType})');
      print('    - revenue: ${item.revenue} (${item.revenue.runtimeType})');
      print('    - requests: ${item.requests} (${item.requests.runtimeType})');
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 32,
                  color: Colors.grey[700],
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).monthlyStats,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Chart
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          try {
                            print('🏷️ getTitlesWidget: value=$value (${value.runtimeType})');
                            final index = value.round();
                            print('  - Rounded index: $index');
                            if (index >= 0 && index < data.length) {
                              print('  - Returning month: ${data[index].month}');
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  data[index].month,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            print('  - Index out of bounds, returning empty');
                          } catch (e, stack) {
                            print('❌ Error in getTitlesWidget: $e');
                            print('Stack: $stack');
                          }
                          return const Text('');
                        },
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // Revenue line (teal with area fill)
                    LineChartBarData(
                      spots: data.asMap().entries.map((e) {
                        print('📈 Creating revenue spot: index=${e.key}, revenue=${e.value.revenue}');
                        return FlSpot(e.key.toDouble(), e.value.revenue);
                      }).toList(),
                      isCurved: true,
                      color: const Color(0xFF14B8A6),
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF14B8A6).withOpacity(0.2),
                      ),
                    ),
                    // Requests line (orange)
                    LineChartBarData(
                      spots: data.asMap().entries.map((e) {
                        print('📊 Creating requests spot: index=${e.key}, requests=${e.value.requests}');
                        return FlSpot(
                            e.key.toDouble(), e.value.requests.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: const Color(0xFFFB923C),
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => Colors.white,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          try {
                            final index = spot.x.round();
                            if (index < 0 || index >= data.length) {
                              return null;
                            }
                            final monthData = data[index];
                            final isRevenue = spot.barIndex == 0;
                            return LineTooltipItem(
                              '${monthData.month}\n',
                              const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: isRevenue
                                      ? '${AppLocalizations.of(context).revenueTooltip}: ${spot.y.toStringAsFixed(0)}k ${AppLocalizations.of(context).sar}'
                                      : '${AppLocalizations.of(context).ordersTooltip}: ${spot.y.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: isRevenue
                                        ? const Color(0xFF14B8A6)
                                        : const Color(0xFFFB923C),
                                  ),
                                ),
                              ],
                            );
                          } catch (e) {
                            return null;
                          }
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(
                  color: const Color(0xFF14B8A6),
                  label: AppLocalizations.of(context).revenueThousands,
                ),
                const SizedBox(width: 24),
                _LegendItem(
                  color: const Color(0xFFFB923C),
                  label: AppLocalizations.of(context).orders,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
