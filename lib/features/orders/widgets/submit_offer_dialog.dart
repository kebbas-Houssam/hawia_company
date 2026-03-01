import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/order_models.dart' as models;
import '../providers/orders_provider.dart';
import '../../../core/utils/app_localizations.dart';

class SubmitOfferDialog extends ConsumerStatefulWidget {
  final models.PendingOrder order;

  const SubmitOfferDialog({super.key, required this.order});

  @override
  ConsumerState<SubmitOfferDialog> createState() => _SubmitOfferDialogState();
}

class _SubmitOfferDialogState extends ConsumerState<SubmitOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;

  final double commissionRate = 0.10;
  final double vatRate = 0.15;

  double get basePrice => double.tryParse(_priceController.text) ?? 0.0;

  bool get needsDuration => widget.order.rentalType == 'once';

  @override
  void dispose() {
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'ar');

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420, // 👈 fixed & predictable width
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: [
                      const Icon(Icons.local_offer, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context).submitOfferTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Order info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.orderNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.order.containerType} - ${widget.order.containerSize}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${AppLocalizations.of(context).delivery}: ${dateFormat.format(widget.order.deliveryDate)}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${AppLocalizations.of(context).rentalType}: ${widget.order.rentalTypeLabel}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Show unload count for monthly/yearly rentals
                            if (widget.order.unloadCount != null && 
                                (widget.order.rentalType == 'monthly' || widget.order.rentalType == 'annual')) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.recycling,
                                      size: 14,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.order.unloadCount} ${AppLocalizations.of(context).unloadOperations}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).basePriceSAR,
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).pleaseEnterPrice;
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return AppLocalizations.of(context).pleaseEnterValidPrice;
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  // Duration
                  if (needsDuration) ...[
                    TextFormField(
                      controller: _durationController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).rentalDurationDays,
                        prefixIcon: const Icon(Icons.calendar_today),
                        helperText: AppLocalizations.of(context).requiredForOnce,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).pleaseEnterDuration;
                        }
                        final duration = int.tryParse(value);
                        if (duration == null ||
                            duration <= 0 ||
                            duration > 365) {
                          return AppLocalizations.of(context).durationRange;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Error
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _isSubmitting
                                  ? null
                                  : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context).cancel,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitOffer,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              _isSubmitting
                                  ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    AppLocalizations.of(context).submitOfferBtn,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitOffer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final request = models.SubmitOfferRequest(
        globalOrderId: widget.order.id,
        price: basePrice,
        rentalDuration:
            needsDuration ? int.tryParse(_durationController.text) : null,
      );

      final success = await ref
          .read(pendingOrdersProvider.notifier)
          .submitOffer(request);

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${AppLocalizations.of(context).offerSubmittedSuccess}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        // Extract meaningful error message
        String errorMsg = AppLocalizations.of(context).offerSubmitFailed;
        if (e.toString().contains('500')) {
          errorMsg = AppLocalizations.of(context).serverError;
        } else if (e.toString().contains('400')) {
          errorMsg = AppLocalizations.of(context).invalidData;
        } else {
          errorMsg = e.toString();
        }
        _errorMessage = errorMsg;
        _isSubmitting = false;
      });
    }
  }
}
