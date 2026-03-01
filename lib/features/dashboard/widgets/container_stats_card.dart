import 'package:flutter/material.dart';
import '../models/dashboard_stats.dart';
import '../../../core/utils/app_localizations.dart';

class ContainerStatsCard extends StatelessWidget {
  final ContainerStats stats;

  const ContainerStatsCard({super.key, required this.stats});

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
                  Icons.widgets_outlined,
                  size: 32,
                  color: Colors.grey[700],
                ),
                Text(
                  AppLocalizations.of(context).containerStats,
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
                  label: AppLocalizations.of(context).totalContainers,
                  color: Colors.grey[700]!,
                ),
                _StatItem(
                  value: stats.rented.toString(),
                  label: AppLocalizations.of(context).rentedContainers,
                  color: const Color(0xFF0E7C69),
                ),
                _StatItem(
                  value: stats.available.toString(),
                  label: AppLocalizations.of(context).availableContainers,
                  color: const Color(0xFF0E7C69),
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
