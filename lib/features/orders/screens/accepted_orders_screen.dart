import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_localizations.dart';
import '../models/order_models.dart' as models;
import '../providers/orders_provider.dart';
import '../../drivers/providers/drivers_provider.dart';
import '../widgets/order_details_modal.dart';

class AcceptedOrdersScreen extends ConsumerStatefulWidget {
  const AcceptedOrdersScreen({super.key});

  @override
  ConsumerState<AcceptedOrdersScreen> createState() =>
      _AcceptedOrdersScreenState();
}

class _AcceptedOrdersScreenState extends ConsumerState<AcceptedOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(acceptedOrdersProvider);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.acceptedOrders),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(acceptedOrdersProvider.notifier).fetchOrders();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loc.withoutDriver),
                  const SizedBox(width: 4),
                  if (ordersState.ordersWithoutDriver.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${ordersState.ordersWithoutDriver.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loc.withDriver),
                  const SizedBox(width: 4),
                  if (ordersState.ordersWithDriver.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${ordersState.ordersWithDriver.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(acceptedOrdersProvider.notifier).fetchOrders();
        },
        child: ordersState.isLoading && ordersState.orders.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ordersState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          ordersState.error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(acceptedOrdersProvider.notifier)
                                .fetchOrders();
                          },
                          child: Text(loc.retry),
                        ),
                      ],
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _OrdersList(
                        orders: ordersState.ordersWithoutDriver,
                        emptyMessage: loc.allOrdersHaveDrivers,
                        showAssignButton: true,
                      ),
                      _OrdersList(
                        orders: ordersState.ordersWithDriver,
                        emptyMessage: loc.noOrdersWithDrivers,
                        showAssignButton: false,
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _OrdersList extends ConsumerWidget {
  final List<models.AcceptedOrder> orders;
  final String emptyMessage;
  final bool showAssignButton;

  const _OrdersList({
    required this.orders,
    required this.emptyMessage,
    required this.showAssignButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isUrgent = order.deliveryDate
            .difference(DateTime.now())
            .inHours < 24;

        return _OrderCard(
          order: order,
          isUrgent: isUrgent,
          showAssignButton: showAssignButton,
        );
      },
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final models.AcceptedOrder order;
  final bool isUrgent;
  final bool showAssignButton;

  const _OrderCard({
    required this.order,
    required this.isUrgent,
    required this.showAssignButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'ar');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          showOrderDetailsModal(
            context,
            orderNumber: order.orderNumber,
            containerType: order.containerType,
            containerSize: order.containerSize,
            deliveryDate: order.deliveryDate,
            deliveryLocation: order.deliveryLocation,
            status: order.status,
            driver: order.driver,
            actionButton: order.driver == null
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDriverAssignmentDialog(context, order.id, order.orderNumber);
                      },
                      icon: const Icon(Icons.person_add),
                      label: Text(AppLocalizations.of(context).assignDriver),
                    ),
                  )
                : null,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (isUrgent) ...[
                        const Icon(Icons.warning, color: Colors.orange, size: 20),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(order.status.statusColorValue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.status.statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(order.status.statusColorValue),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.inbox,
              text: '${order.containerType} - ${order.containerSize}',
            ),
            _InfoRow(
              icon: Icons.inventory,
              text: '${AppLocalizations.of(context).containerNumber}: ${order.container.containerNumber ?? AppLocalizations.of(context).unspecified}',
            ),
            _InfoRow(
              icon: Icons.location_on,
              text: order.deliveryLocation.address ?? AppLocalizations.of(context).unspecified,
            ),
            _InfoRow(
              icon: Icons.calendar_today,
              text: dateFormat.format(order.deliveryDate),
            ),
            if (order.driver != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.driver!.user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (order.driver!.licenseNumber != null)
                            Text(
                              '${AppLocalizations.of(context).licenseLabel}: ${order.driver!.licenseNumber}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          if (order.driver!.vehicleType != null)
                            Text(
                              '${AppLocalizations.of(context).vehicleLabel}: ${order.driver!.vehicleType}',
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (showAssignButton)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showDriverSelectionDialog(context, ref),
                  icon: const Icon(Icons.person_add),
                  label: Text(AppLocalizations.of(context).assignDriver),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDriverSelectionDialog(context, ref),
                      icon: const Icon(Icons.swap_horiz),
                      label: Text(AppLocalizations.of(context).changeDriver),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to tracking screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppLocalizations.of(context).trackingComingSoon)),
                        );
                      },
                      icon: const Icon(Icons.map),
                      label: Text(AppLocalizations.of(context).track),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      ),
    );
  }

  void _showDriverAssignmentDialog(BuildContext context, String orderId, String orderNumber) {
    showDialog(
      context: context,
      builder: (context) => _DriverSelectionDialog(
        orderId: orderId,
        orderNumber: orderNumber,
      ),
    );
  }

  void _showDriverSelectionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _DriverSelectionDialog(
        orderId: order.id,
        orderNumber: order.orderNumber,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverSelectionDialog extends ConsumerStatefulWidget {
  final String orderId;
  final String orderNumber;

  const _DriverSelectionDialog({
    required this.orderId,
    required this.orderNumber,
  });

  @override
  ConsumerState<_DriverSelectionDialog> createState() =>
      _DriverSelectionDialogState();
}

class _DriverSelectionDialogState
    extends ConsumerState<_DriverSelectionDialog> {
  String? _selectedDriverId;
  bool _isAssigning = false;

  @override
  void initState() {
    super.initState();
    // Load drivers when dialog opens
    Future.microtask(() => ref.read(driversProvider.notifier).fetchDrivers());
  }

  @override
  Widget build(BuildContext context) {
    final driversState = ref.watch(driversProvider);
    final drivers = driversState.drivers.where((d) => d.availability == 'available').toList();

    return AlertDialog(
      title: Text(AppLocalizations.of(context).assignDriver),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context).orderPrefix}: ${widget.orderNumber}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (driversState.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (drivers.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    AppLocalizations.of(context).noDriversAvailable,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    final driverId = driver.id;

                    return RadioListTile<String>(
                      value: driverId,
                      groupValue: _selectedDriverId,
                      onChanged: (value) {
                        setState(() => _selectedDriverId = value);
                      },
                      title: Text(driver.name),
                      subtitle: Text('${AppLocalizations.of(context).identityNumber}: ${driver.identityNumber}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isAssigning ? null : () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: _selectedDriverId == null || _isAssigning
              ? null
              : _assignDriver,
          child: _isAssigning
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(AppLocalizations.of(context).assignDriver),
        ),
      ],
    );
  }

  Future<void> _assignDriver() async {
    setState(() => _isAssigning = true);

    final success = await ref.read(acceptedOrdersProvider.notifier).assignDriver(
          orderId: widget.orderId,
          driverId: _selectedDriverId!,
        );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).driverAssignedSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() => _isAssigning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).driverAssignFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
