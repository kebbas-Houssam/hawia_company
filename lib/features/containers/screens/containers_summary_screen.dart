import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/containers_provider.dart';
import '../models/container_models.dart' as models;
import '../widgets/add_container_bottom_sheet.dart';
import '../widgets/edit_container_status_sheet.dart';
import '../widgets/delete_containers_dialog.dart';
import '../../../core/utils/app_localizations.dart';

class ContainersSummaryScreen extends ConsumerStatefulWidget {
  const ContainersSummaryScreen({super.key});

  @override
  ConsumerState<ContainersSummaryScreen> createState() =>
      _ContainersSummaryScreenState();
}

class _ContainersSummaryScreenState
    extends ConsumerState<ContainersSummaryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(containersProvider.notifier).fetchSummary(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final containersState = ref.watch(containersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).manageContainers),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddContainerSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(containersProvider.notifier).refresh(),
        child: _buildBody(containersState),
      ),
    );
  }

  Widget _buildBody(dynamic containersState) {
    if (containersState.isLoading && containersState.summary.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (containersState.error != null && containersState.summary.isEmpty) {
      return _ErrorView(
        error: containersState.error!,
        onRetry: () => ref.read(containersProvider.notifier).fetchSummary(),
      );
    }

    if (containersState.summary.isEmpty) {
      return _EmptyView(onAdd: () => _showAddContainerSheet(context));
    }

    // Fixed: No nested SingleChildScrollViews.
    // The ListView inside _ContainerSummaryTable handles scrolling now.
    return _ContainerSummaryTable(
      summary: containersState.summary,
      onEdit: (item) => _showEditStatusSheet(context, item),
      onDelete: (item) => _showDeleteDialog(context, item),
    );
  }

  void _showAddContainerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddContainerBottomSheet(),
    );
  }

  void _showEditStatusSheet(
    BuildContext context,
    models.ContainerSummaryItem item,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) =>
              EditContainerStatusSheet(type: item.type, size: item.size),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    models.ContainerSummaryItem item,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => DeleteContainersDialog(
            type: item.type,
            size: item.size,
            availableCount: item.available,
          ),
    );
  }
}

// ==================== Container Summary List (Formerly Table) ====================

class _ContainerSummaryTable extends StatelessWidget {
  final List<models.ContainerSummaryItem> summary;
  final Function(models.ContainerSummaryItem) onEdit;
  final Function(models.ContainerSummaryItem) onDelete;

  const _ContainerSummaryTable({
    required this.summary,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: summary.length,
      itemBuilder: (context, index) {
        final item = summary[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "${item.type} - ${item.size}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: Text(
                  '${AppLocalizations.of(context).total}: ${item.total}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(context, AppLocalizations.of(context).available, item.available, Colors.green),
                    _buildStat(context, AppLocalizations.of(context).rented, item.rented, Colors.blue),
                    _buildStat(
                      context,
                      AppLocalizations.of(context).maintenance,
                      item.maintenance,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => onEdit(item),
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text(AppLocalizations.of(context).edit),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => onDelete(item),
                        icon: const Icon(
                          Icons.delete,
                          size: 18,
                          color: Colors.red,
                        ),
                        label: Text(
                          AppLocalizations.of(context).delete,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ==================== Empty View ====================

class _EmptyView extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyView({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context).noContainers, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context).addContainer),
          ),
        ],
      ),
    );
  }
}

// ==================== Error View ====================

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(error),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }
}
