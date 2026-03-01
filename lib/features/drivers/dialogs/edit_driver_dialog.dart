import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/driver.dart';
import '../models/driver_requests.dart';
import '../providers/drivers_provider.dart';
import '../../../core/config/app_theme.dart';
import '../../../core/utils/app_localizations.dart';
import '../../../shared/widgets/icon_text_form_field.dart';
import '../../../shared/widgets/loading_button.dart';

class EditDriverDialog extends ConsumerStatefulWidget {
  final Driver driver;

  const EditDriverDialog({
    super.key,
    required this.driver,
  });

  @override
  ConsumerState<EditDriverDialog> createState() => _EditDriverDialogState();
}

class _EditDriverDialogState extends ConsumerState<EditDriverDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  late final TextEditingController _identityNumberController;
  late String? _selectedAvailability;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.driver.name);
    _phoneController = TextEditingController(text: widget.driver.phone);
    _emailController = TextEditingController(text: widget.driver.email ?? '');
    _identityNumberController =
        TextEditingController(text: widget.driver.identityNumber);
    _selectedAvailability = widget.driver.availability;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _identityNumberController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final loc = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return loc.nameRequired;
    }
    if (value.trim().length < 2) {
      return loc.nameMinLength;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context).phoneRequired;
    }
    return null;
  }

  String? _validateIdentityNumber(String? value) {
    // Identity number is now optional
    if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
      return AppLocalizations.of(context).identityMinLength;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return AppLocalizations.of(context).emailInvalid;
      }
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.length < 6) {
        return AppLocalizations.of(context).passwordMinLength;
      }
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAvailability == null) {
      setState(() {
        _errorMessage = AppLocalizations.of(context).pleaseSelectDriverStatus;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = UpdateDriverRequest(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        password: _passwordController.text.trim().isEmpty
            ? null
            : _passwordController.text.trim(),
        availability: _selectedAvailability,
        identityNumber: _identityNumberController.text.trim().isEmpty
            ? null
            : _identityNumberController.text.trim(),
      );

      await ref
          .read(driversProvider.notifier)
          .updateDriver(widget.driver.id, request);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).driverUpdatedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).editDriverData,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                Text(
                  AppLocalizations.of(context).driverInfo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Name field
                IconTextFormField(
                  label: AppLocalizations.of(context).driverNameLabel,
                  icon: Icons.person,
                  controller: _nameController,
                  validator: _validateName,
                  isRequired: true,
                  hintText: AppLocalizations.of(context).enterFullName,
                ),
                const SizedBox(height: 16),

                // Phone field
                IconTextFormField(
                  label: AppLocalizations.of(context).phoneNumber,
                  icon: Icons.phone,
                  controller: _phoneController,
                  validator: _validatePhone,
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                  hintText: '+966 50 123 4567',
                ),
                const SizedBox(height: 16),

                // Identity number field
                IconTextFormField(
                  label: AppLocalizations.of(context).identityNumberLabel,
                  icon: Icons.badge,
                  controller: _identityNumberController,
                  validator: _validateIdentityNumber,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  hintText: '1234567890',
                ),
                const SizedBox(height: 16),

                // Availability dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context).driverStatus,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedAvailability,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).selectDriverStatus,
                        prefixIcon: const Icon(Icons.people),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'available',
                          child: Text(AppLocalizations.of(context).available),
                        ),
                        DropdownMenuItem(
                          value: 'on_duty',
                          child: Text(AppLocalizations.of(context).onDuty),
                        ),
                        DropdownMenuItem(
                          value: 'off_duty',
                          child: Text(AppLocalizations.of(context).offDuty),
                        ),
                        DropdownMenuItem(
                          value: 'on_break',
                          child: Text(AppLocalizations.of(context).onBreak),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAvailability = value;
                          _errorMessage = null;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email field (optional)
                IconTextFormField(
                  label: AppLocalizations.of(context).emailOptional,
                  icon: Icons.email,
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'driver@example.com',
                ),
                const SizedBox(height: 16),

                // Password field (optional)
                IconTextFormField(
                  label: AppLocalizations.of(context).newPasswordOptional,
                  icon: Icons.lock,
                  controller: _passwordController,
                  validator: _validatePassword,
                  obscureText: _obscurePassword,
                  hintText: '••••••••',
                  suffixIcon: _passwordController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        )
                      : null,
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: LoadingButton(
                        text: AppLocalizations.of(context).updateData,
                        isLoading: _isLoading,
                        onPressed: _handleSubmit,
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context).cancel),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
