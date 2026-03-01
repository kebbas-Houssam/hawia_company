import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/driver_details_provider.dart';
import '../models/driver.dart';
import '../models/driver_details.dart';
import '../../../core/config/app_theme.dart';
import '../../../core/utils/app_localizations.dart';
import '../../../shared/widgets/status_badge.dart';

class DriverDetailsScreen extends ConsumerStatefulWidget {
  final String driverId;

  const DriverDetailsScreen({
    super.key,
    required this.driverId,
  });

  @override
  ConsumerState<DriverDetailsScreen> createState() =>
      _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends ConsumerState<DriverDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(driverDetailsProvider.notifier)
        .fetchDriverDetails(widget.driverId));
  }

  @override
  void dispose() {
    ref.read(driverDetailsProvider.notifier).clear();
    super.dispose();
  }

  String _formatIdentityNumber(String? number) {
    if (number == null || number.isEmpty) return AppLocalizations.of(context).notAvailable;
    // Format: 1 2345 67890
    if (number.length == 10) {
      return '${number[0]} ${number.substring(1, 5)} ${number.substring(5)}';
    }
    return number;
  }

  @override
  Widget build(BuildContext context) {
    final detailsState = ref.watch(driverDetailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).aboutDriver),
      ),
      body: _buildBody(detailsState),
    );
  }

  Widget _buildBody(DriverDetailsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).errorLoadingDriverData,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(driverDetailsProvider.notifier)
                  .fetchDriverDetails(widget.driverId),
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      );
    }

    if (state.details == null) {
      return Center(
        child: Text(AppLocalizations.of(context).driverNotFound),
      );
    }

    final details = state.details!;
    final driver = details.driver;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                // Driver info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        AppLocalizations.of(context).identityNumber,
                        _formatIdentityNumber(driver.identityNumber),
                      ),
                      const SizedBox(height: 4),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: _buildInfoRow(AppLocalizations.of(context).phone, driver.phone),
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        AppLocalizations.of(context).email,
                        driver.email ?? AppLocalizations.of(context).unspecified,
                      ),
                      const SizedBox(height: 8),
                      StatusBadge(
                        label: driver.availabilityLabel,
                        color: driver.statusColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Statistics Section
          Text(
            AppLocalizations.of(context).statistics,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  AppLocalizations.of(context).currentOrders,
                  details.statistics.currentApplications.toString(),
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  AppLocalizations.of(context).completedOrdersStat,
                  details.statistics.completedApplications.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  AppLocalizations.of(context).totalOrders,
                  details.statistics.totalApplications.toString(),
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Orders Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context).driverOrders} (${details.orders.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (details.orders.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).noOrdersForDriver,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            _buildOrdersTable(details.orders),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTable(List<DriverOrder> orders) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        order.truck,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${AppLocalizations.of(context).containerNumber}: ${order.containerNumber?.toString() ?? AppLocalizations.of(context).unspecified}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  StatusBadge(
                    label: order.statusLabel,
                    color: order.statusColor,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              // Order Details
              _buildOrderDetailRow(
                Icons.inventory,
                AppLocalizations.of(context).type,
                order.type,
              ),
              const SizedBox(height: 8),
              _buildOrderDetailRow(
                Icons.straighten,
                AppLocalizations.of(context).size,
                order.size,
              ),
              const SizedBox(height: 8),
              _buildOrderDetailRow(
                Icons.calendar_today,
                AppLocalizations.of(context).deliveryDate,
                order.deliveryDate,
              ),
              if (order.orderType != null) ...[
                const SizedBox(height: 8),
                _buildOrderDetailRow(
                  Icons.local_shipping,
                  AppLocalizations.of(context).orderType,
                  _getOrderTypeLabel(order.orderType!),
                ),
              ],
              if (order.customerName != null) ...[
                const SizedBox(height: 8),
                _buildOrderDetailRow(
                  Icons.person,
                  AppLocalizations.of(context).customer,
                  order.customerName!,
                ),
              ],
              if (order.deliveryLocation != null) ...[
                const SizedBox(height: 8),
                _buildOrderDetailRow(
                  Icons.location_on,
                  AppLocalizations.of(context).address,
                  order.deliveryLocation!.address ?? 
                    '${order.deliveryLocation!.latitude.toStringAsFixed(4)}, ${order.deliveryLocation!.longitude.toStringAsFixed(4)}',
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _getOrderTypeLabel(String type) {
    final loc = AppLocalizations.of(context);
    switch (type) {
      case 'delivery':
        return loc.delivery;
      case 'unload':
        return loc.unload;
      case 'return':
        return loc.returnOrder;
      default:
        return type;
    }
  }
}
