import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/app_localizations.dart';
import 'pending_orders_screen.dart';
import 'accepted_orders_screen.dart';
import 'sub_orders_screen.dart';
import 'completed_orders_screen.dart';
import 'cancelled_orders_screen.dart';

class OrdersMainScreen extends ConsumerStatefulWidget {
  const OrdersMainScreen({super.key});

  @override
  ConsumerState<OrdersMainScreen> createState() => _OrdersMainScreenState();
}

class _OrdersMainScreenState extends ConsumerState<OrdersMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.orders),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(
              icon: const Icon(Icons.pending_actions),
              text: loc.newOrders,
            ),
            Tab(
              icon: const Icon(Icons.check_circle),
              text: loc.acceptedOrders,
            ),
            Tab(
              icon: const Icon(Icons.recycling),
              text: loc.subOrders,
            ),
            Tab(
              icon: const Icon(Icons.done_all),
              text: loc.completedOrders,
            ),
            Tab(
              icon: const Icon(Icons.cancel),
              text: loc.cancelledOrders,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PendingOrdersScreen(),
          AcceptedOrdersScreen(),
          SubOrdersScreen(),
          CompletedOrdersScreen(),
          CancelledOrdersScreen(),
        ],
      ),
    );
  }
}
