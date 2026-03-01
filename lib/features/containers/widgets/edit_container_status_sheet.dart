import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/container_models.dart' as models;
import '../providers/containers_provider.dart';
import '../services/containers_api_service.dart';
import '../../../core/utils/app_localizations.dart';

class EditContainerStatusSheet extends ConsumerStatefulWidget {
  final String type;
  final String size;

  const EditContainerStatusSheet({
    super.key,
    required this.type,
    required this.size,
  });

  @override
  ConsumerState<EditContainerStatusSheet> createState() =>
      _EditContainerStatusSheetState();
}

class _EditContainerStatusSheetState
    extends ConsumerState<EditContainerStatusSheet> {
  String activeTab = 'all';
  Set<String> selectedIds = {};
  String? newStatus;
  bool isSubmitting = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(containerDetailsProvider.notifier)
        .fetchDetails(type: widget.type, size: widget.size));
  }

  @override
  Widget build(BuildContext context) {
    final detailsState = ref.watch(containerDetailsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context).manageContainersSheet,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.type} - ${widget.size} • ${detailsState.details?.total ?? 0} حاوية',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              if (detailsState.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (detailsState.error != null)
                Expanded(
                  child: Center(
                    child: Text(
                      detailsState.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              else if (detailsState.details != null)
                Expanded(
                  child: Column(
                    children: [
                      // Tabs
                      _buildTabs(detailsState.details!),
                      const Divider(height: 1),

                      // Selection info and actions
                      if (selectedIds.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          color: Colors.blue[50],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                '${AppLocalizations.of(context).selectedXOfY} ${selectedIds.length} ${AppLocalizations.of(context).ofWord} ${_getFilteredContainers(detailsState.details!).length} ${AppLocalizations.of(context).containerWord}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: _selectAll,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    child: Text(AppLocalizations.of(context).selectAll),
                                  ),
                                  TextButton(
                                    onPressed: _deselectAll,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    child: Text(AppLocalizations.of(context).cancel),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      // Error message
                      if (errorMessage != null)
                        Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            border: Border.all(color: Colors.red[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  errorMessage!,
                                  style: TextStyle(color: Colors.red[700], fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Container grid
                      Expanded(
                        child: _buildContainerGrid(
                          detailsState.details!,
                          scrollController,
                        ),
                      ),

                      // Bottom actions
                      SafeArea(
                        top: false,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                value: newStatus,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).selectNewStatus,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  isDense: true,
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'available',
                                    child: Text(AppLocalizations.of(context).available),
                                  ),
                                  DropdownMenuItem(
                                    value: 'rented',
                                    child: Text(AppLocalizations.of(context).rented),
                                  ),
                                  DropdownMenuItem(
                                    value: 'maintenance',
                                    child: Text(AppLocalizations.of(context).maintenance),
                                  ),
                                ],
                                onChanged: (value) =>
                                    setState(() => newStatus = value),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: selectedIds.isEmpty ||
                                          newStatus == null ||
                                          isSubmitting
                                      ? null
                                      : _updateStatus,
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: isSubmitting
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(AppLocalizations.of(context).changeStatus),
                                ),
                              ),
                            ],
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

  Widget _buildTabs(models.ContainerDetailsResponse details) {
    final allCount = details.allContainers.length;
    final availableCount = details.containers.available.length;
    final rentedCount = details.containers.rented.length;
    final maintenanceCount = details.containers.maintenance.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildTabChip('all', AppLocalizations.of(context).all, allCount),
            const SizedBox(width: 8),
            _buildTabChip('available', AppLocalizations.of(context).available, availableCount),
            const SizedBox(width: 8),
            _buildTabChip('rented', AppLocalizations.of(context).rented, rentedCount),
            const SizedBox(width: 8),
            _buildTabChip('maintenance', AppLocalizations.of(context).maintenance, maintenanceCount),
          ],
        ),
      ),
    );
  }

  Widget _buildTabChip(String value, String label, int count) {
    final isSelected = activeTab == value;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) => setState(() {
        activeTab = value;
        selectedIds.clear();
      }),
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildContainerGrid(
    models.ContainerDetailsResponse details,
    ScrollController scrollController,
  ) {
    final containers = _getFilteredContainers(details);

    if (containers.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context).noContainers),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive cross axis count based on width
        int crossAxisCount = 2;
        if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 400) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: containers.length,
          itemBuilder: (context, index) {
            final container = containers[index];
            final isSelected = selectedIds.contains(container.id);

            return InkWell(
              onTap: () => _toggleSelection(container.id),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => _toggleSelection(container.id),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '#${container.containerNumber ?? container.id.substring(0, 8)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color(container.statusColorValue)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              container.statusLabel,
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(container.statusColorValue),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<models.Container> _getFilteredContainers(models.ContainerDetailsResponse details) {
    switch (activeTab) {
      case 'available':
        return details.containers.available;
      case 'rented':
        return details.containers.rented;
      case 'maintenance':
        return details.containers.maintenance;
      default:
        return details.allContainers;
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  void _selectAll() {
    final details = ref.read(containerDetailsProvider).details;
    if (details != null) {
      setState(() {
        selectedIds = _getFilteredContainers(details)
            .map<String>((c) => c.id)
            .toSet();
      });
    }
  }

  void _deselectAll() {
    setState(() => selectedIds.clear());
  }

  Future<void> _updateStatus() async {
    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    try {
      final request = models.BulkUpdateStatusRequest(
        containerIds: selectedIds.toList(),
        newStatus: newStatus!,
      );

      final apiService = ref.read(containersApiServiceProvider);
      await apiService.bulkUpdateStatus(request);

      // Refresh data
      await ref.read(containersProvider.notifier).fetchSummary();
      await ref.read(containerDetailsProvider.notifier).fetchDetails(
            type: widget.type,
            size: widget.size,
          );

      setState(() {
        isSubmitting = false;
        selectedIds.clear();
        newStatus = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).changeStatus)),
        );
      }

      // Close after 1 second
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        isSubmitting = false;
        errorMessage = e.toString();
      });
    }
  }
}
