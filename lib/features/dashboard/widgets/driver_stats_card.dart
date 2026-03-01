import 'package:flutter/material.dart';
import '../models/dashboard_stats.dart';
import '../../../core/utils/app_localizations.dart';

class DriverStatsCard extends StatelessWidget {
  final DriverStats stats;

  const DriverStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF0E7C69).withOpacity(0.85),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  size: 32,
                  color: Colors.white,
                ),
                Text(
                  AppLocalizations.of(context).driverStats,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Row
            Row(
              children: [
                // Total Drivers
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person,
                              color: Color(0xFFF9D9B6), size: 28),
                          const SizedBox(width: 8),
                          Text(
                            stats.total.toString(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF9D9B6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context).totalDrivers,
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // Completion Rate
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Text(
                            '${stats.completionRate.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF9D9B6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context).completionRate,
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 8),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: stats.completionRate / 100,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFF9D9B6),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
