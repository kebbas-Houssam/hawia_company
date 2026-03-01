import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'dart:convert';
import '../providers/registration_provider.dart';
import '../models/region_city_models.dart';
import '../widgets/custom_text_field.dart';
import '../../../shared/widgets/loading_button.dart';
import '../../../shared/widgets/phone_input_field.dart';
import '../../../shared/terms_and_conditions_page.dart';
import '../../../shared/privacy_policy_page.dart';
import '../../../core/config/app_theme.dart';
import '../../../core/utils/app_localizations.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final _companyNameController = TextEditingController();
  final _commercialNumberController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _companyPhoneNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _ibanController = TextEditingController();
  final _bankAccountNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _codeController = TextEditingController();
  final _latitudeController = TextEditingController(text: '24.7136');
  final _longitudeController = TextEditingController(text: '46.6753');

  // Location & Image
  MapController? _mapController;
  LatLng _selectedLocation = LatLng(24.7136, 46.6753);
  File? _logoFile;

  // Phone number country code
  String _countryCode = '+966';

  // Region & City
  List<Region> _regions = [];
  List<City> _allCities = [];
  Region? _selectedRegion;
  City? _selectedCity;
  bool _isLoadingData = true;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadRegionsAndCities();
  }

  Future<void> _loadRegionsAndCities() async {
    try {
      print('📍 Starting to load regions and cities...');
      final regionsJson = await rootBundle.loadString('lib/constants/regions.json');
      final citiesJson = await rootBundle.loadString('lib/constants/cities.json');

      print('📍 Parsing regions JSON...');
      final List<dynamic> regionsData = jsonDecode(regionsJson);
      print('📍 Found ${regionsData.length} regions');
      
      print('📍 Parsing cities JSON...');
      final List<dynamic> citiesData = jsonDecode(citiesJson);
      print('📍 Found ${citiesData.length} cities');

      print('📍 Converting regions to Region objects...');
      final regions = <Region>[];
      for (int i = 0; i < regionsData.length; i++) {
        try {
          print('📍 Processing region $i: ${regionsData[i]}');
          regions.add(Region.fromJson(regionsData[i]));
        } catch (e) {
          print('❌ ERROR parsing region at index $i: $e');
          print('❌ Region data: ${regionsData[i]}');
          rethrow;
        }
      }
      print('✅ Successfully parsed ${regions.length} regions');

      print('📍 Converting cities to City objects...');
      final cities = <City>[];
      for (int i = 0; i < citiesData.length; i++) {
        try {
          if (i % 5000 == 0) print('📍 Processing city $i...');
          cities.add(City.fromJson(citiesData[i]));
        } catch (e) {
          print('❌ ERROR parsing city at index $i: $e');
          print('❌ City data: ${citiesData[i]}');
          rethrow;
        }
      }
      print('✅ Successfully parsed ${cities.length} cities');

      setState(() {
        _regions = regions;
        _allCities = cities;
        _isLoadingData = false;
      });
      print('✅ Data loading complete!');
    } catch (e) {
      print('❌ FATAL ERROR in _loadRegionsAndCities: $e');
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).failedLoadData}: $e', textDirection: TextDirection.rtl),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<City> get _filteredCities {
    if (_selectedRegion == null) return [];
    return _allCities.where((city) => city.regionId == _selectedRegion!.regionId).toList();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      final bytes = await file.length();

      if (bytes > 2 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).imageSizeLimit, textDirection: TextDirection.rtl),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() => _logoFile = file);
    }
  }

  Future<void> _requestCurrentLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Ask user to enable location services - this opens system settings dialog
        bool opened = await Geolocator.openLocationSettings();
        if (!opened) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).pleaseEnableLocation, textDirection: TextDirection.rtl),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
        return;
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).locationPermissionDenied, textDirection: TextDirection.rtl),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          // Show dialog to guide user to app settings
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context).locationPermissionRequired, textDirection: TextDirection.rtl),
              content: Text(
                AppLocalizations.of(context).allowLocationAccess,
                textDirection: TextDirection.rtl,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context).cancel, textDirection: TextDirection.rtl),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Geolocator.openAppSettings();
                  },
                  child: Text(AppLocalizations.of(context).openSettings, textDirection: TextDirection.rtl),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });

      // Move map to new location
      _mapController?.move(_selectedLocation, 13);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).locationSetSuccess, textDirection: TextDirection.rtl),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).failedGetLocation}: $e', textDirection: TextDirection.rtl),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mapController?.dispose();
    _companyNameController.dispose();
    _commercialNumberController.dispose();
    _taxNumberController.dispose();
    _companyPhoneNumberController.dispose();
    _bankNameController.dispose();
    _bankAccountNumberController.dispose();
    _ibanController.dispose();
    _bankAccountNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _codeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _handleSendVerificationCode() {
    print('🟡 _handleSendVerificationCode called');
    
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).mustAgreeToTerms, textDirection: TextDirection.rtl),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_formKey.currentState!.validate()) {
      print('🟡 Form validation passed');
      if (_passwordController.text != _confirmPasswordController.text) {
        print('🟡 Passwords do not match');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).passwordsDoNotMatch, textDirection: TextDirection.rtl),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_logoFile == null) {
        print('🟡 Logo file is null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).pleaseSelectLogo, textDirection: TextDirection.rtl),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedCity == null) {
        print('🟡 Selected city is null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).pleaseSelectCityMsg, textDirection: TextDirection.rtl),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      print('🟡 All validations passed, calling sendVerificationCode...');
      print('🟡 Email: ${_emailController.text.trim()}');
      ref.read(registrationProvider.notifier).sendVerificationCode(_emailController.text.trim());
    } else {
      print('🟡 Form validation failed');
    }
  }

  void _handleVerifyAndRegister() async {
    // Combine country code with phone number
    final fullPhoneNumber = _countryCode + _companyPhoneNumberController.text.trim();
    
    final formData = FormData.fromMap({
      'companyName': _companyNameController.text.trim(),
      'commercialNumber': _commercialNumberController.text.trim(),
      'taxNumber': _taxNumberController.text.trim(),
      'companyPhoneNumber': fullPhoneNumber,
      'cityId': _selectedCity!.cityId.toString(),
      'latitude': double.parse(_latitudeController.text),
      'longitude': double.parse(_longitudeController.text),
      'logo': await MultipartFile.fromFile(_logoFile!.path),
      'bankName': _bankNameController.text.trim(),
      'bankAccountNumber': _bankAccountNumberController.text.trim(),
      'iban': _ibanController.text.trim(),
      'bankAccountName': _bankAccountNameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    });

    await ref.read(registrationProvider.notifier).verifyEmailAndRegister(
      _codeController.text.trim(),
      formData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final registrationState = ref.watch(registrationProvider);

    // Listen for step changes
    ref.listen<RegistrationState>(registrationProvider, (previous, next) {
      if (next.step == RegistrationStep.verify && previous?.step != RegistrationStep.verify) {
        _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else if (next.step == RegistrationStep.pending && previous?.step != RegistrationStep.pending) {
        _pageController.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!, textDirection: TextDirection.rtl),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next.successMessage != null && previous?.successMessage != next.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!, textDirection: TextDirection.rtl),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildFormStep(registrationState),
            _buildVerificationStep(registrationState),
            _buildPendingStep(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormStep(RegistrationState state) {
    if (_isLoadingData) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).signUpTitle,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).step1CompanyData,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 40),

            // Company Information
            CustomTextField(
              label: AppLocalizations.of(context).companyName,
              hint: AppLocalizations.of(context).enterCompanyName,
              controller: _companyNameController,
              validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: AppLocalizations.of(context).commercialRegNumber,
              hint: '1234567890',
              controller: _commercialNumberController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return AppLocalizations.of(context).required;
                if (value!.length != 10) return AppLocalizations.of(context).mustBe10Digits;
                return null;
              },
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: AppLocalizations.of(context).taxNumber,
              hint: AppLocalizations.of(context).enterTaxNumber,
              controller: _taxNumberController,
              validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
            ),
            const SizedBox(height: 20),

            PhoneInputField(
              label: AppLocalizations.of(context).companyPhone,
              controller: _companyPhoneNumberController,
              onCountryCodeChanged: (code) {
                setState(() => _countryCode = code);
              },
              validator: (value) {
                if (value?.isEmpty ?? true) return AppLocalizations.of(context).required;
                if (value!.length < 9) return AppLocalizations.of(context).phoneNumberTooShort;
                return null;
              },
            ),
            const SizedBox(height: 30),

            // Region & City Selection
            Text(
              AppLocalizations.of(context).regionAndCity,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),

            // Region Dropdown
            DropdownButtonFormField<Region>(
              value: _selectedRegion,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).region,
                border: const OutlineInputBorder(),
              ),
              items: _regions.map((region) {
                return DropdownMenuItem<Region>(
                  value: region,
                  child: Text(region.nameAr, textDirection: TextDirection.rtl),
                );
              }).toList(),
              onChanged: (region) {
                setState(() {
                  _selectedRegion = region;
                  _selectedCity = null;
                });
              },
              validator: (value) => value == null ? AppLocalizations.of(context).pleaseSelectRegion : null,
            ),
            const SizedBox(height: 20),

            // City Dropdown
            if (_selectedRegion != null)
              DropdownButtonFormField<City>(
                value: _selectedCity,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).city,
                  border: const OutlineInputBorder(),
                ),
                items: _filteredCities.map((city) {
                  return DropdownMenuItem<City>(
                    value: city,
                    child: Text(city.nameAr, textDirection: TextDirection.rtl),
                  );
                }).toList(),
                onChanged: (city) {
                  setState(() => _selectedCity = city);
                },
                validator: (value) => value == null ? AppLocalizations.of(context).pleaseSelectCity : null,
              ),
            const SizedBox(height: 30),

            // Logo Upload
            Text(
              AppLocalizations.of(context).companyLogo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickLogo,
              icon: const Icon(Icons.upload_file),
              label: Text(
                _logoFile == null ? AppLocalizations.of(context).selectCompanyLogo : AppLocalizations.of(context).logoSelected,
                textDirection: TextDirection.rtl,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _logoFile == null ? Colors.grey : Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            if (_logoFile != null) ...[
              const SizedBox(height: 10),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_logoFile!, fit: BoxFit.contain),
                ),
              ),
            ],
            const SizedBox(height: 30),

            // Location Section
            Text(
              AppLocalizations.of(context).companyLocation,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _requestCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: Text(AppLocalizations.of(context).myCurrentLocation, textDirection: TextDirection.rtl),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: AppLocalizations.of(context).latitude,
                    hint: '24.7136',
                    controller: _latitudeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return AppLocalizations.of(context).required;
                      final lat = double.tryParse(value!);
                      if (lat == null || lat < -90 || lat > 90) {
                        return AppLocalizations.of(context).invalidValue;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final lat = double.tryParse(value);
                      if (lat != null) {
                        setState(() {
                          _selectedLocation = LatLng(lat, _selectedLocation.longitude);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    label: AppLocalizations.of(context).longitude,
                    hint: '46.6753',
                    controller: _longitudeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return AppLocalizations.of(context).required;
                      final lng = double.tryParse(value!);
                      if (lng == null || lng < -180 || lng > 180) {
                        return AppLocalizations.of(context).invalidValue;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final lng = double.tryParse(value);
                      if (lng != null) {
                        setState(() {
                          _selectedLocation = LatLng(_selectedLocation.latitude, lng);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Map
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FlutterMap(
                  mapController: _mapController ?? MapController(),
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: 13,
                    onTap: (tapPosition, latLng) {
                      setState(() {
                        _selectedLocation = latLng;
                        _latitudeController.text = latLng.latitude.toString();
                        _longitudeController.text = latLng.longitude.toString();
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.hawia_app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Bank Information
            Text(
              AppLocalizations.of(context).bankInfo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: AppLocalizations.of(context).bankName,
              hint: AppLocalizations.of(context).enterBankName,
              controller: _bankNameController,
              validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: AppLocalizations.of(context).bankAccountNumber,
              hint: AppLocalizations.of(context).enterAccountNumber,
              controller: _bankAccountNumberController,
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: AppLocalizations.of(context).ibanNumber,
              hint: 'SA0000000000000000000000',
              controller: _ibanController,
              validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: AppLocalizations.of(context).accountHolderName,
              hint: AppLocalizations.of(context).enterAccountHolderName,
              controller: _bankAccountNameController,
              validator: (value) => value?.isEmpty ?? true ? AppLocalizations.of(context).required : null,
            ),
            const SizedBox(height: 30),

            // Admin Account
            Text(
              AppLocalizations.of(context).adminAccount,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: AppLocalizations.of(context).email,
              hint: 'admin@company.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return AppLocalizations.of(context).required;
                if (!value!.contains('@')) return AppLocalizations.of(context).invalidEmail;
                return null;
              },
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: AppLocalizations.of(context).password,
              hint: AppLocalizations.of(context).enterPassword,
              controller: _passwordController,
              isPassword: true,
              validator: (value) {
                if (value?.isEmpty ?? true) return AppLocalizations.of(context).required;
                if (value!.length < 6) return AppLocalizations.of(context).mustBe6Chars;
                return null;
              },
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: AppLocalizations.of(context).confirmPassword,
              hint: AppLocalizations.of(context).reEnterPassword,
              controller: _confirmPasswordController,
              isPassword: true,
              validator: (value) {
                if (value?.isEmpty ?? true) return AppLocalizations.of(context).required;
                if (value != _passwordController.text) return AppLocalizations.of(context).passwordsDoNotMatch;
                return null;
              },
            ),            const SizedBox(height: 20),
            
            // Terms and Privacy Agreement Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (value) {
                    setState(() => _agreedToTerms = value ?? false);
                  },
                  activeColor: AppColors.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontFamily: 'Tajawal',
                        ),
                        children: [
                          TextSpan(text: AppLocalizations.of(context).iAgreeToTerms),
                          TextSpan(
                            text: AppLocalizations.of(context).termsOfService,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsAndConditionsPage(),
                                  ),
                                );
                              },
                          ),
                          TextSpan(text: ' ${AppLocalizations.of(context).and} '),
                          TextSpan(
                            text: AppLocalizations.of(context).privacyPolicy,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicyPage(),
                                  ),
                                );
                              },
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),            const SizedBox(height: 40),

            LoadingButton(
              text: AppLocalizations.of(context).sendVerificationCode,
              isLoading: state.isLoading,
              onPressed: _handleSendVerificationCode,
            ),
            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: () => context.go('/signin'),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    children: [
                      TextSpan(text: AppLocalizations.of(context).alreadyHaveAccount),
                      TextSpan(
                        text: AppLocalizations.of(context).signInTitle,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationStep(RegistrationState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context).emailVerification,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).step2VerificationCode,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 40),

          CustomTextField(
            label: AppLocalizations.of(context).verificationCode,
            hint: '123456',
            controller: _codeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 40),

          LoadingButton(
            text: AppLocalizations.of(context).confirmRegistration,
            isLoading: state.isLoading,
            onPressed: _handleVerifyAndRegister,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 100),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context).requestSentSuccess,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context).requestUnderReview,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => context.go('/signin'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: Text(
              AppLocalizations.of(context).backToSignIn,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}
