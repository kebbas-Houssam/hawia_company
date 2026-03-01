import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_localizations.dart';
import '../models/order_models.dart' as models;
import '../providers/orders_provider.dart';
import '../widgets/order_details_modal.dart';

class CompletedOrdersScreen extends ConsumerStatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  ConsumerState<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends ConsumerState<CompletedOrdersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(completedOrdersProvider.notifier).loadMoreOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(completedOrdersProvider);
    final hasActiveFilters = ordersState.containerTypeFilter != null || 
                            ordersState.cityFilter != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).completedOrders),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(context, ref),
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(completedOrdersProvider.notifier).fetchOrders();
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
                              .read(completedOrdersProvider.notifier)
                              .fetchOrders(),
                          child: Text(AppLocalizations.of(context).retry),
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
                              AppLocalizations.of(context).noCompletedOrders,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          // Active Filters Display
                          if (hasActiveFilters)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              color: Colors.blue[50],
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (ordersState.containerTypeFilter != null)
                                    Chip(
                                      label: Text(ordersState.containerTypeFilter!),
                                      deleteIcon: const Icon(Icons.close, size: 18),
                                      onDeleted: () {
                                        ref.read(completedOrdersProvider.notifier).applyFilters(
                                          containerType: null,
                                          city: ordersState.cityFilter,
                                        );
                                        ref.read(completedOrdersProvider.notifier).fetchOrders();
                                      },
                                    ),
                                  if (ordersState.cityFilter != null)
                                    Chip(
                                      label: Text(_getCityNameInArabic(ordersState.cityFilter!)),
                                      deleteIcon: const Icon(Icons.close, size: 18),
                                      onDeleted: () {
                                        ref.read(completedOrdersProvider.notifier).applyFilters(
                                          containerType: ordersState.containerTypeFilter,
                                          city: null,
                                        );
                                        ref.read(completedOrdersProvider.notifier).fetchOrders();
                                      },
                                    ),
                                ],
                              ),
                            ),
                          if (ordersState.pagination != null)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                '${AppLocalizations.of(context).showingXOfY} ${ordersState.orders.length} ${AppLocalizations.of(context).ofWord} ${ordersState.pagination!.totalOrders} ${AppLocalizations.of(context).orderWord}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: ordersState.orders.length + (ordersState.hasMorePages ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == ordersState.orders.length) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: ordersState.isLoadingMore
                                          ? const CircularProgressIndicator()
                                          : const SizedBox.shrink(),
                                    ),
                                  );
                                }
                                return _OrderCard(order: ordersState.orders[index]);
                              },
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }

  String _getCityNameInArabic(String cityEnglish) {
    const cityMap = {
      'Riyadh': 'الرياض',
      'Jeddah': 'جدة',
      'Mecca': 'مكة',
      'Medina': 'المدينة',
      'Dammam': 'الدمام',
      'Khobar': 'الخبر',
      'Dhahran': 'الظهران',
      'Tabuk': 'تبوك',
      'Abha': 'أبها',
      'Najran': 'نجران',
      'Khamis Mushait': 'خميس مشيط',
      'Hail': 'حائل',
      'Buraydah': 'بريدة',
      'Qassim': 'القصيم',
      'Taif': 'الطائف',
      'Jubail': 'الجبيل',
      'Yanbu': 'ينبع',
      'Arar': 'عرعر',
      'Sakaka': 'سكاكا',
      'Jizan': 'جازان',
      'Al-Ahsa': 'الأحساء',
      'Hofuf': 'الهفوف',
    };
    return cityMap[cityEnglish] ?? cityEnglish;
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    final ordersState = ref.read(completedOrdersProvider);
    final availableFilters = ordersState.availableFilters;

    if (availableFilters == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).noFiltersAvailable)),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _FilterDialog(
        availableFilters: availableFilters,
        currentContainerTypeFilter: ordersState.containerTypeFilter,
        currentCityFilter: ordersState.cityFilter,
      ),
    );
  }
}

class _FilterDialog extends ConsumerStatefulWidget {
  final models.AvailableFilters availableFilters;
  final String? currentContainerTypeFilter;
  final String? currentCityFilter;

  const _FilterDialog({
    required this.availableFilters,
    this.currentContainerTypeFilter,
    this.currentCityFilter,
  });

  @override
  ConsumerState<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<_FilterDialog> {
  late String? _selectedContainerType;
  late String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedContainerType = widget.currentContainerTypeFilter;
    _selectedCity = widget.currentCityFilter;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).filterOrders),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container Type Filter
            Text(
              AppLocalizations.of(context).containerType,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(AppLocalizations.of(context).all),
                  selected: _selectedContainerType == null,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedContainerType = null);
                    }
                  },
                ),
                ...widget.availableFilters.containerTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: _selectedContainerType == type,
                    onSelected: (selected) {
                      setState(() => _selectedContainerType = selected ? type : null);
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
            
            // City Filter
            Text(
              AppLocalizations.of(context).cityLabel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(AppLocalizations.of(context).all),
                  selected: _selectedCity == null,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCity = null);
                    }
                  },
                ),
                ...widget.availableFilters.cities.map((city) {
                  return ChoiceChip(
                    label: Text(_getCityNameInArabic(city)),
                    selected: _selectedCity == city,
                    onSelected: (selected) {
                      setState(() => _selectedCity = selected ? city : null);
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(completedOrdersProvider.notifier).applyFilters(
              containerType: null,
              city: null,
            );
            ref.read(completedOrdersProvider.notifier).fetchOrders();
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context).reset),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(completedOrdersProvider.notifier).applyFilters(
              containerType: _selectedContainerType,
              city: _selectedCity,
            );
            ref.read(completedOrdersProvider.notifier).fetchOrders();
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context).apply),
        ),
      ],
    );
  }

  String _getCityNameInArabic(String cityEnglish) {
    // Map common city names to Arabic
    const cityMap = {
      'Riyadh': 'الرياض',
      'Jeddah': 'جدة',
      'Mecca': 'مكة',
      'Medina': 'المدينة',
      'Dammam': 'الدمام',
      'Khobar': 'الخبر',
      'Dhahran': 'الظهران',
      'Tabuk': 'تبوك',
      'Abha': 'أبها',
      'Najran': 'نجران',
      'Khamis Mushait': 'خميس مشيط',
      'Hail': 'حائل',
      'Buraydah': 'بريدة',
      'Qassim': 'القصيم',
      'Taif': 'الطائف',
      'Jubail': 'الجبيل',
      'Yanbu': 'ينبع',
      'Arar': 'عرعر',
      'Sakaka': 'سكاكا',
      'Jizan': 'جازان',
      'Al-Ahsa': 'الأحساء',
      'Hofuf': 'الهفوف',
    };
    
    return cityMap[cityEnglish] ?? cityEnglish;
  }
}

class _OrderCard extends StatelessWidget {
  final models.CompletedOrder order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'ar');
    final priceFormat = NumberFormat('#,##0.00', 'ar');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          showOrderDetailsModal(
            context,
            orderNumber: order.orderNumber ?? AppLocalizations.of(context).unspecified,
            containerType: order.containerType,
            containerSize: order.container?.size,
            deliveryDate: order.deliveryDate,
            deliveryLocation: order.deliveryLocation,
            status: order.status,
            totalPrice: order.totalPrice,
            completedAt: order.completedAt,
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
                    order.orderNumber ?? AppLocalizations.of(context).unspecified,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    AppLocalizations.of(context).statusCompleted,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9C27B0),
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
                Text('${order.containerType ?? AppLocalizations.of(context).unspecified}${order.container != null ? ' - ${order.container!.size}' : ''}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(dateFormat.format(order.deliveryDate)),
                if (order.completedAt != null) ...[
                  const SizedBox(width: 4),
                  const Text('←'),
                  const SizedBox(width: 4),
                  Text(dateFormat.format(order.completedAt!)),
                ],
              ],
            ),
            if (order.driver != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.local_shipping, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(order.driver!.user.name),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).totalLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${priceFormat.format(order.totalPrice)} ${AppLocalizations.of(context).sar}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
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
}
