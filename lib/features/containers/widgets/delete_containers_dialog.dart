import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/container_models.dart' as models;
import '../providers/containers_provider.dart';
import '../services/containers_api_service.dart';
import '../../../core/utils/app_localizations.dart';

class DeleteContainersDialog extends ConsumerStatefulWidget {
  final String type;
  final String size;
  final int availableCount;

  const DeleteContainersDialog({
    super.key,
    required this.type,
    required this.size,
    required this.availableCount,
  });

  @override
  ConsumerState<DeleteContainersDialog> createState() =>
      _DeleteContainersDialogState();
}

class _DeleteContainersDialogState
    extends ConsumerState<DeleteContainersDialog> {
  int quantity = 1;
  bool isSubmitting = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.delete, color: Colors.red[700]),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context).deleteContainers,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context).typeLabel}: ${widget.type}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppLocalizations.of(context).sizeLabel}: ${widget.size}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppLocalizations.of(context).availableForDeletion}: ${widget.availableCount}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quantity input or no available message
            if (widget.availableCount == 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).noContainersAvailableForDeletion,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              Text(
                AppLocalizations.of(context).howManyToDelete,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: quantity.toString(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  helperText: '${AppLocalizations.of(context).maxLimit}: ${widget.availableCount}',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null &&
                      parsed >= 1 &&
                      parsed <= widget.availableCount) {
                    setState(() => quantity = parsed);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Warning box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  border: Border.all(color: Colors.orange[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange[700]),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context).importantWarning,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• ${AppLocalizations.of(context).onlyAvailableDeleted}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      '• ${AppLocalizations.of(context).cannotUndoAction}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],

            // Error message
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(AppLocalizations.of(context).cancel, style: const TextStyle(fontSize: 16)),
              ),
            ),
            if (widget.availableCount > 0) ...[
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _deleteContainers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      isSubmitting
                          ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            '${AppLocalizations.of(context).delete} $quantity',
                            style: const TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _deleteContainers() async {
    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    try {
      final request = models.BulkDeleteContainersRequest.byTypeSize(
        type: widget.type,
        size: widget.size,
        quantity: quantity,
      );

      final apiService = ref.read(containersApiServiceProvider);
      await apiService.bulkDeleteContainers(request);

      await ref.read(containersProvider.notifier).fetchSummary();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).containersDeletedSuccess)));
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
