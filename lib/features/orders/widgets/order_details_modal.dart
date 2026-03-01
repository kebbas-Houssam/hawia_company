import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_localizations.dart';
import '../models/order_models.dart' as models;
import 'order_location_map.dart';

void showOrderDetailsModal(
  BuildContext context, {
  required String orderNumber,
  required String? containerType,
  required String? containerSize,
  required DateTime deliveryDate,
  required models.DeliveryLocation deliveryLocation,
  String? status,
  double? totalPrice,
  String? rentalType,
  double? distance,
  DateTime? completedAt,
  DateTime? cancelledAt,
  String? cancellationReason,
  models.DriverInfo? driver,
  Widget? actionButton,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        final dateFormat = DateFormat('dd/MM/yyyy', 'ar');

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                orderNumber,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Map
              OrderLocationMap(
                latitude: deliveryLocation.latitude,
                longitude: deliveryLocation.longitude,
                address: deliveryLocation.address,
              ),
              const SizedBox(height: 20),
              if (containerType != null)
                _DetailRow(
                  icon: Icons.inbox,
                  label: AppLocalizations.of(context).containerType,
                  value: containerSize != null
                      ? '$containerType - $containerSize'
                      : containerType,
                ),
              if (rentalType != null)
                _DetailRow(
                  icon: Icons.event,
                  label: AppLocalizations.of(context).rentalType,
                  value: _getRentalTypeLabel(rentalType, AppLocalizations.of(context)),
                ),
              if (status != null)
                _DetailRow(
                  icon: Icons.info_outline,
                  label: AppLocalizations.of(context).status,
                  value: _getStatusLabel(status, AppLocalizations.of(context)),
                ),
              _DetailRow(
                icon: Icons.calendar_today,
                label: AppLocalizations.of(context).deliveryDate,
                value: dateFormat.format(deliveryDate),
              ),
              if (completedAt != null)
                _DetailRow(
                  icon: Icons.check_circle,
                  label: AppLocalizations.of(context).completionDate,
                  value: dateFormat.format(completedAt),
                ),
              if (cancelledAt != null)
                _DetailRow(
                  icon: Icons.event_busy,
                  label: AppLocalizations.of(context).cancellationDate,
                  value: dateFormat.format(cancelledAt),
                ),
              _DetailRow(
                icon: Icons.location_on,
                label: AppLocalizations.of(context).address,
                value: deliveryLocation.address ?? AppLocalizations.of(context).unspecified,
              ),
              if (distance != null)
                _DetailRow(
                  icon: Icons.route,
                  label: AppLocalizations.of(context).distance,
                  value: '${distance.toStringAsFixed(1)} ${AppLocalizations.of(context).km}',
                ),
              if (totalPrice != null)
                _DetailRow(
                  icon: Icons.attach_money,
                  label: AppLocalizations.of(context).totalPrice,
                  value: '${totalPrice.toStringAsFixed(2)} ${AppLocalizations.of(context).sar}',
                ),
              if (driver != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.green[700], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context).assignedDriver,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${AppLocalizations.of(context).driverName}: ${driver.user.name}'),
                      if (driver.licenseNumber != null)
                        Text('${AppLocalizations.of(context).licenseNumber}: ${driver.licenseNumber}'),
                    ],
                  ),
                ),
              ],
              if (cancellationReason != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.red[700], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${AppLocalizations.of(context).cancellationReason}:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(cancellationReason),
                    ],
                  ),
                ),
              ],
              if (actionButton != null) ...[
                const SizedBox(height: 20),
                actionButton,
              ],
            ],
          ),
        );
      },
    ),
  );
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _getRentalTypeLabel(String type, AppLocalizations loc) {
  switch (type) {
    case 'once':
      return loc.rentalOnce;
    case 'monthly':
      return loc.rentalMonthly;
    case 'annual':
      return loc.rentalAnnual;
    default:
      return type;
  }
}

String _getStatusLabel(String status, AppLocalizations loc) {
  switch (status) {
    case 'pending_offers':
      return loc.statusPendingOffers;
    case 'accepted':
      return loc.statusAccepted;
    case 'in_progress':
      return loc.statusInProgress;
    case 'completed':
      return loc.statusCompleted;
    case 'cancelled':
      return loc.statusCancelled;
    case 'scheduled':
      return loc.statusScheduled;
    case 'picked_up':
      return loc.statusPickedUp;
    default:
      return status;
  }
}
