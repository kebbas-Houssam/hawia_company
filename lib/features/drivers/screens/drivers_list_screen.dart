import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/app_localizations.dart';
import '../providers/drivers_provider.dart';
import '../widgets/driver_card.dart';
import '../widgets/empty_drivers_state.dart';
import '../../../core/config/app_theme.dart';
import '../dialogs/add_driver_dialog.dart';
import '../dialogs/edit_driver_dialog.dart';
import '../dialogs/delete_driver_dialog.dart';

class DriversListScreen extends ConsumerStatefulWidget {
  const DriversListScreen({super.key});

  @override
  ConsumerState<DriversListScreen> createState() => _DriversListScreenState();
}

class _DriversListScreenState extends ConsumerState<DriversListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch drivers on screen load
    Future.microtask(() => ref.read(driversProvider.notifier).fetchDrivers());
  }

  void _showAddDriverDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddDriverDialog(),
    );
  }

  void _showEditDriverDialog(String driverId) {
    final driver = ref
        .read(driversProvider)
        .drivers
        .firstWhere((d) => d.id == driverId);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditDriverDialog(driver: driver),
    );
  }

  void _showDeleteDriverDialog(String driverId) {
    final driver = ref
        .read(driversProvider)
        .drivers
        .firstWhere((d) => d.id == driverId);
    showDialog(
      context: context,
      builder: (context) => DeleteDriverDialog(driver: driver),
    );
  }

  @override
  Widget build(BuildContext context) {
    final driversState = ref.watch(driversProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).manageDrivers),
        actions: [
          IconButton(
            onPressed: _showAddDriverDialog,
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(driversProvider.notifier).fetchDrivers(),
        child: _buildBody(driversState),
      ),
    );
  }

  Widget _buildBody(DriversState state) {
    if (state.isLoading && state.drivers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.drivers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(driversProvider.notifier).fetchDrivers(),
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      );
    }

    if (state.drivers.isEmpty) {
      return const EmptyDriversState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.drivers.length,
      itemBuilder: (context, index) {
        final driver = state.drivers[index];
        return DriverCard(
          driver: driver,
          onTap: () => context.push('/drivers/${driver.id}'),
          onEdit: () => _showEditDriverDialog(driver.id),
          onDelete: () => _showDeleteDriverDialog(driver.id),
        );
      },
    );
  }
}
