import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_localizations.dart';
import '../models/order_models.dart' as models;
import '../providers/orders_provider.dart';
import '../widgets/order_details_modal.dart';

class CancelledOrdersScreen extends ConsumerWidget {
  const CancelledOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(cancelledOrdersProvider);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.cancelledOrders),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(cancelledOrdersProvider.notifier).fetchOrders();
        },
        child: ordersState.isLoading && ordersState.orders.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ordersState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(ordersState.error!,
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref
                              .read(cancelledOrdersProvider.notifier)
                              .fetchOrders(),
                          child: Text(loc.retry),
                        ),
                      ],
                    ),
                  )
                : ordersState.orders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              loc.noCancelledOrders,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: ordersState.orders.length,
                        itemBuilder: (context, index) =>
                            _OrderCard(order: ordersState.orders[index]),
                      ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final models.CancelledOrder order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'ar');
    final loc = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          showOrderDetailsModal(
            context,
            orderNumber: order.orderNumber,
            containerType: order.containerType,
            containerSize: order.container?.size,
            deliveryDate: order.deliveryDate,
            deliveryLocation: order.deliveryLocation,
            status: order.status,
            totalPrice: order.totalPrice,
            cancelledAt: order.cancelledAt,
            cancellationReason: order.cancellationReason,
            driver: order.driver,
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
                  child: Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF44336).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    loc.cancelled,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFF44336),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.inbox, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('${order.containerType ?? 'غير محدد'}${order.container != null ? ' - ${order.container!.size}' : ''}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.deliveryLocation.address ?? '${order.deliveryLocation.latitude}, ${order.deliveryLocation.longitude}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(dateFormat.format(order.deliveryDate)),
              ],
            ),
            if (order.cancelledAt != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.event_busy, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${loc.cancellationDate}: ${dateFormat.format(order.cancelledAt!)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
            if (order.cancellationReason != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.red[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${loc.cancellationReason}:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.cancellationReason!,
                            style: TextStyle(fontSize: 13, color: Colors.red[900]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
