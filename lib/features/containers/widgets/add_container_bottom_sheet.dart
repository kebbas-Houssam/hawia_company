import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/container_models.dart' as models;
import '../providers/containers_provider.dart';
import '../services/containers_api_service.dart';
import '../../../core/utils/app_localizations.dart';

class AddContainerBottomSheet extends ConsumerStatefulWidget {
  const AddContainerBottomSheet({super.key});

  @override
  ConsumerState<AddContainerBottomSheet> createState() =>
      _AddContainerBottomSheetState();
}

class _AddContainerBottomSheetState
    extends ConsumerState<AddContainerBottomSheet> {
  String? selectedType;
  String? selectedSize;
  int quantity = 1;
  String status = 'available';

  models.ContainerType? selectedTypeData;
  models.ContainerSize? selectedSizeData;

  bool isSubmitting = false;
  String? errorMessage;
  String? successMessage;

  @override
  Widget build(BuildContext context) {
    final containerTypesAsync = ref.watch(containerTypesProvider);

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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).addNewContainer,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Error/Success Message
                    if (errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          border: Border.all(color: Colors.red[300]!),
                          borderRadius: BorderRadius.circular(8),
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
                    if (successMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          border: Border.all(color: Colors.green[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: Colors.green[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                successMessage!,
                                style: TextStyle(color: Colors.green[700]),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Type Dropdown
                    containerTypesAsync.when(
                      data: (types) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.category, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${AppLocalizations.of(context).containerType} *',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedType,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            hint: Text(AppLocalizations.of(context).selectContainerType),
                            items: types.map((type) {
                              return DropdownMenuItem(
                                value: type.name,
                                child: Text(type.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedType = value;
                                selectedSize = null;
                                selectedTypeData = types.firstWhere(
                                  (t) => t.name == value,
                                );
                                selectedSizeData = null;
                              });
                            },
                          ),
                          if (selectedTypeData?.description != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                selectedTypeData!.description!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Text(
                        '${AppLocalizations.of(context).errorLoadingTypes}: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Size Dropdown
                    if (selectedTypeData != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.straighten, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${AppLocalizations.of(context).containerSize} *',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedSize,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        hint: Text(AppLocalizations.of(context).selectContainerSize),
                        items: selectedTypeData!.sizes.map((size) {
                          return DropdownMenuItem(
                            value: size.size,
                            child: Text(size.size),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSize = value;
                            selectedSizeData = selectedTypeData!.sizes
                                .firstWhere((s) => s.size == value);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Image Preview
                    if (selectedSizeData?.imageUrl != null) ...[
                      Container(
                        height: 192,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://hawiacom.com${selectedSizeData!.imageUrl}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Quantity Input
                    Row(
                      children: [
                        const Icon(Icons.numbers, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${AppLocalizations.of(context).containerCount} *',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: quantity.toString(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        helperText:
                            AppLocalizations.of(context).willAddContainers(quantity),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed != null && parsed >= 1 && parsed <= 100) {
                          setState(() => quantity = parsed);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status Dropdown
                    Row(
                      children: [
                        const Icon(Icons.settings, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context).containerStatus,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'available',
                          child: Text(AppLocalizations.of(context).availableForRent),
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
                          setState(() => status = value ?? 'available'),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isSubmitting ||
                              selectedType == null ||
                              selectedSize == null
                          ? null
                          : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                          : Text(
                              AppLocalizations.of(context).addContainerBtn,
                              style: const TextStyle(fontSize: 16),
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

  Future<void> _submitForm() async {
    setState(() {
      isSubmitting = true;
      errorMessage = null;
      successMessage = null;
    });

    try {
      final request = models.AddContainersRequest(
        type: selectedType!,
        size: selectedSize!,
        quantity: quantity,
        status: status,
      );

      final apiService = ref.read(containersApiServiceProvider);
      final response = await apiService.addContainers(request);

      setState(() {
        isSubmitting = false;
        successMessage = response.message;
      });

      // Refresh summary list
      ref.read(containersProvider.notifier).fetchSummary();

      // Close after 1.5 seconds
      await Future.delayed(const Duration(milliseconds: 1500));
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
