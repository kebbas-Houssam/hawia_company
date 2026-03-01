import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_localizations.dart';
import '../models/order_models.dart' as models;
import '../providers/orders_provider.dart';
import '../../drivers/providers/drivers_provider.dart';
import '../widgets/order_details_modal.dart';

class SubOrdersScreen extends ConsumerStatefulWidget {
  const SubOrdersScreen({super.key});

  @override
  ConsumerState<SubOrdersScreen> createState() => _SubOrdersScreenState();
}

class _SubOrdersScreenState extends ConsumerState<SubOrdersScreen>
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
    final subOrdersState = ref.watch(subOrdersProvider);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.subOrdersTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loc.unload),
                  const SizedBox(width: 4),
                  if (subOrdersState.unloadOrders.isNotEmpty)
                    _Badge(count: subOrdersState.unloadOrders.length),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loc.returnOrder),
                  const SizedBox(width: 4),
                  if (subOrdersState.returnOrders.isNotEmpty)
                    _Badge(count: subOrdersState.returnOrders.length),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(subOrdersProvider.notifier).fetchSubOrders();
        },
        child: subOrdersState.isLoading && subOrdersState.subOrders.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : subOrdersState.error != null
                ? _ErrorView(error: subOrdersState.error!)
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _SubOrdersList(
                        subOrders: subOrdersState.unloadOrders,
                        emptyMessage: loc.noUnloadOrders,
                      ),
                      _SubOrdersList(
                        subOrders: subOrdersState.returnOrders,
                        emptyMessage: loc.noReturnOrders,
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;

  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(error, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                ref.read(subOrdersProvider.notifier).fetchSubOrders(),
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }
}

class _SubOrdersList extends StatelessWidget {
  final List<models.SubOrder> subOrders;
  final String emptyMessage;

  const _SubOrdersList({
    required this.subOrders,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (subOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subOrders.length,
      itemBuilder: (context, index) => _SubOrderCard(subOrder: subOrders[index]),
    );
  }
}

class _SubOrderCard extends ConsumerWidget {
  final models.SubOrder subOrder;

  const _SubOrderCard({required this.subOrder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'ar');
    final isCompleted = subOrder.status == 'completed';
    final hasDriver = subOrder.driver != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          showOrderDetailsModal(
            context,
            orderNumber: '${subOrder.type.subOrderTypeLabel} - ${subOrder.order.container?.containerNumber ?? "غير محدد"}',
            containerType: subOrder.order.container?.type,
            containerSize: subOrder.order.container?.size,
            deliveryDate: subOrder.deliveryDate,
            deliveryLocation: subOrder.order.deliveryLocation,
            status: subOrder.status,
            driver: subOrder.driver,
            actionButton: !isCompleted
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDriverAssignmentDialog(context, ref);
                      },
                      icon: Icon(hasDriver ? Icons.swap_horiz : Icons.person_add),
                      label: Text(hasDriver ? AppLocalizations.of(context).changeDriver : AppLocalizations.of(context).assignDriver),
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
              children: [
                Text(
                  subOrder.type.subOrderTypeIcon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${subOrder.type.subOrderTypeLabel} - ${subOrder.order.container?.containerNumber ?? AppLocalizations.of(context).unspecified}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(subOrder.status.statusColorValue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    subOrder.status.statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(subOrder.status.statusColorValue),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (subOrder.order.container != null)
              _InfoRow(
                icon: Icons.inbox,
                text:
                    '${subOrder.order.container!.type} - ${subOrder.order.container!.size}',
              ),
            _InfoRow(
              icon: Icons.location_on,
              text: subOrder.order.deliveryLocation.address ?? AppLocalizations.of(context).unspecified,
            ),
            _InfoRow(
              icon: Icons.calendar_today,
              text: '${AppLocalizations.of(context).deliveryDateLabel}: ${dateFormat.format(subOrder.deliveryDate)}',
            ),
            if (subOrder.driver != null) ...[
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
                      child: Text(
                        subOrder.driver!.user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (!isCompleted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showDriverAssignmentDialog(context, ref),
                  icon: Icon(hasDriver ? Icons.swap_horiz : Icons.person_add),
                  label: Text(hasDriver ? AppLocalizations.of(context).changeDriver : AppLocalizations.of(context).assignDriver),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
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

  void _showDriverAssignmentDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _DriverSelectionDialog(
        subOrderId: subOrder.id,
        subOrderLabel: '${subOrder.type.subOrderTypeLabel} - ${subOrder.order.container?.containerNumber ?? "غير محدد"}',
        deliveryDate: subOrder.deliveryDate,
      ),
    );
  }
}

class _DriverSelectionDialog extends ConsumerStatefulWidget {
  final String subOrderId;
  final String subOrderLabel;
  final DateTime deliveryDate;

  const _DriverSelectionDialog({
    required this.subOrderId,
    required this.subOrderLabel,
    required this.deliveryDate,
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
    final drivers = driversState.drivers
        .where((d) => d.availability == 'available')
        .toList();

    return AlertDialog(
      title: Text(AppLocalizations.of(context).assignDriver),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context).orderPrefix}: ${widget.subOrderLabel}',
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
              : Text(AppLocalizations.of(context).assign),
        ),
      ],
    );
  }

  Future<void> _assignDriver() async {
    setState(() => _isAssigning = true);

    final success =
        await ref.read(subOrdersProvider.notifier).assignDriver(
              subOrderId: widget.subOrderId,
              driverId: _selectedDriverId!,
              deliveryDate: widget.deliveryDate,
            );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم تعيين السائق بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() => _isAssigning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ فشل تعيين السائق'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
