import 'package:flutter/material.dart';
import '../models/dashboard_stats.dart';
import '../../../core/utils/app_localizations.dart';

class OrderStatsCard extends StatelessWidget {
  final OrderStats stats;

  const OrderStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 32,
                  color: Colors.grey[700],
                ),
                Text(
                  AppLocalizations.of(context).orderStats,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  value: stats.total.toString(),
                  label: AppLocalizations.of(context).totalOrdersStat,
                  color: Colors.grey[700]!,
                ),
                _StatItem(
                  value: stats.pending.toString(),
                  label: AppLocalizations.of(context).pendingOrders,
                  color: const Color(0xFF1DC411),
                ),
                _StatItem(
                  value: stats.completed.toString(),
                  label: AppLocalizations.of(context).completedStat,
                  color: const Color(0xFFE38214),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
