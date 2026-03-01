import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('ar'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['ar']?[key] ??
        key;
  }

  // ─────────────── Main Layout ───────────────
  String get appName => translate('app_name');
  String get technicalSupport => translate('technical_support');
  String get profile => translate('profile');
  String get dashboard => translate('dashboard');
  String get orders => translate('orders');
  String get drivers => translate('drivers');
  String get containers => translate('containers');

  // ─────────────── Landing Screen ───────────────
  String get manageContainersEasily => translate('manage_containers_easily');
  String get signIn => translate('sign_in');
  String get createNewAccount => translate('create_new_account');

  // ─────────────── Sign In Screen ───────────────
  String get signInTitle => translate('sign_in_title');
  String get welcomeBack => translate('welcome_back');
  String get savedAccount => translate('saved_account');
  String get useAnotherAccount => translate('use_another_account');
  String get companyIdLabel => translate('company_id_label');
  String get companyIdHint => translate('company_id_hint');
  String get pleaseEnterCompanyId => translate('please_enter_company_id');
  String get adminEmailLabel => translate('admin_email_label');
  String get enterEmail => translate('enter_email');
  String get pleaseEnterEmail => translate('please_enter_email');
  String get pleaseEnterValidEmail => translate('please_enter_valid_email');
  String get adminPasswordLabel => translate('admin_password_label');
  String get enterPassword => translate('enter_password');
  String get pleaseEnterPassword => translate('please_enter_password');
  String get saveLoginInfo => translate('save_login_info');
  String get iAgreeToTerms => translate('i_agree_to');
  String get termsOfService => translate('terms_of_service');
  String get and => translate('and');
  String get privacyPolicy => translate('privacy_policy');
  String get mustAgreeToTerms => translate('must_agree_to_terms');
  String get noAccountYet => translate('no_account_yet');
  String get createNewAccountLink => translate('create_new_account_link');
  String get permanentBan => translate('permanent_ban');
  String get temporaryBan => translate('temporary_ban');
  String get banReason => translate('ban_reason');

  // ─────────────── Sign Up Screen ───────────────
  String get signUpTitle => translate('sign_up_title');
  String get step1CompanyData => translate('step1_company_data');
  String get companyName => translate('company_name');
  String get enterCompanyName => translate('enter_company_name');
  String get required => translate('required');
  String get commercialRegNumber => translate('commercial_reg_number');
  String get mustBe10Digits => translate('must_be_10_digits');
  String get taxNumber => translate('tax_number');
  String get enterTaxNumber => translate('enter_tax_number');
  String get companyPhone => translate('company_phone');
  String get phoneNumberTooShort => translate('phone_number_too_short');
  String get regionAndCity => translate('region_and_city');
  String get region => translate('region');
  String get city => translate('city');
  String get pleaseSelectRegion => translate('please_select_region');
  String get pleaseSelectCity => translate('please_select_city');
  String get companyLogo => translate('company_logo');
  String get selectCompanyLogo => translate('select_company_logo');
  String get logoSelected => translate('logo_selected');
  String get imageSizeLimit => translate('image_size_limit');
  String get companyLocation => translate('company_location');
  String get myCurrentLocation => translate('my_current_location');
  String get latitude => translate('latitude');
  String get longitude => translate('longitude');
  String get invalidValue => translate('invalid_value');
  String get bankInfo => translate('bank_info');
  String get bankName => translate('bank_name');
  String get enterBankName => translate('enter_bank_name');
  String get bankAccountNumber => translate('bank_account_number');
  String get enterAccountNumber => translate('enter_account_number');
  String get ibanNumber => translate('iban_number');
  String get accountHolderName => translate('account_holder_name');
  String get enterAccountHolderName => translate('enter_account_holder_name');
  String get adminAccount => translate('admin_account');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get reEnterPassword => translate('re_enter_password');
  String get passwordsDoNotMatch => translate('passwords_do_not_match');
  String get mustBe6Chars => translate('must_be_6_chars');
  String get invalidEmail => translate('invalid_email');
  String get sendVerificationCode => translate('send_verification_code');
  String get alreadyHaveAccount => translate('already_have_account');
  String get failedLoadData => translate('failed_load_data');
  String get pleaseEnableLocation => translate('please_enable_location');
  String get locationPermissionDenied => translate('location_permission_denied');
  String get locationPermissionRequired => translate('location_permission_required');
  String get allowLocationAccess => translate('allow_location_access');
  String get cancel => translate('cancel');
  String get openSettings => translate('open_settings');
  String get locationSetSuccess => translate('location_set_success');
  String get failedGetLocation => translate('failed_get_location');
  String get pleaseSelectLogo => translate('please_select_logo');
  String get pleaseSelectCityMsg => translate('please_select_city_msg');

  // ─────────────── Sign Up - Verification ───────────────
  String get emailVerification => translate('email_verification');
  String get step2VerificationCode => translate('step2_verification_code');
  String get verificationCode => translate('verification_code');
  String get confirmRegistration => translate('confirm_registration');

  // ─────────────── Sign Up - Pending ───────────────
  String get requestSentSuccess => translate('request_sent_success');
  String get requestUnderReview => translate('request_under_review');
  String get backToSignIn => translate('back_to_sign_in');

  // ─────────────── Orders - Main ───────────────
  String get newOrders => translate('new_orders');
  String get acceptedOrders => translate('accepted_orders');
  String get subOrders => translate('sub_orders');
  String get completedOrders => translate('completed_orders');
  String get cancelledOrders => translate('cancelled_orders');

  // ─────────────── Orders - Pending ───────────────
  String get availableOrders => translate('available_orders');
  String get retry => translate('retry');
  String get noAvailableOrdersNow => translate('no_available_orders_now');
  String get filterOrders => translate('filter_orders');
  String get containerType => translate('container_type');
  String get size => translate('size');
  String get all => translate('all');
  String get reset => translate('reset');
  String get apply => translate('apply');
  String get sortByDistance => translate('sort_by_distance');
  String get sortByDate => translate('sort_by_date');
  String get sortByType => translate('sort_by_type');
  String get rentalType => translate('rental_type');
  String get deliveryDate => translate('delivery_date');
  String get address => translate('address');
  String get unspecified => translate('unspecified');
  String get distance => translate('distance');
  String get customer => translate('customer');
  String get phone => translate('phone');
  String get submitOffer => translate('submit_offer');
  String get offerSubmitted => translate('offer_submitted');
  String get offerSubmittedForOrder => translate('offer_submitted_for_order');
  String get km => translate('km');

  // ─────────────── Orders - Accepted ───────────────
  String get withoutDriver => translate('without_driver');
  String get withDriver => translate('with_driver');
  String get allOrdersHaveDrivers => translate('all_orders_have_drivers');
  String get noOrdersWithDrivers => translate('no_orders_with_drivers');
  String get assignDriver => translate('assign_driver');
  String get containerNumber => translate('container_number');
  String get licenseLabel => translate('license_label');
  String get vehicleLabel => translate('vehicle_label');
  String get trackingComingSoon => translate('tracking_coming_soon');
  String get track => translate('track');
  String get orderPrefix => translate('order_prefix');

  // ─────────────── Orders - Sub Orders ───────────────
  String get subOrdersTitle => translate('sub_orders_title');
  String get unload => translate('unload');
  String get returnOrder => translate('return_order');
  String get noUnloadOrders => translate('no_unload_orders');
  String get noReturnOrders => translate('no_return_orders');
  String get changeDriver => translate('change_driver');
  String get deliveryDateLabel => translate('delivery_date_label');
  String get assign => translate('assign');

  // ─────────────── Orders - Completed ───────────────
  String get noCompletedOrders => translate('no_completed_orders');
  String get noFiltersAvailable => translate('no_filters_available');
  String get showingXOfY => translate('showing_x_of_y');
  String get ofWord => translate('of_word');
  String get orderWord => translate('order_word');
  String get cityLabel => translate('city_label');

  // ─────────────── Orders - Cancelled ───────────────
  String get noCancelledOrders => translate('no_cancelled_orders');
  String get cancelled => translate('cancelled');
  String get cancellationDate => translate('cancellation_date');
  String get cancellationReason => translate('cancellation_reason');

  // ─────────────── Orders - Details Modal ───────────────
  String get status => translate('status');
  String get completionDate => translate('completion_date');
  String get totalPrice => translate('total_price');
  String get totalLabel => translate('total_label');
  String get sar => translate('sar');
  String get assignedDriver => translate('assigned_driver');
  String get driverName => translate('driver_name');
  String get licenseNumber => translate('license_number');

  // ─────────────── Submit Offer Dialog ───────────────
  String get submitOfferTitle => translate('submit_offer_title');
  String get delivery => translate('delivery');
  String get basePriceSAR => translate('base_price_sar');
  String get pleaseEnterPrice => translate('please_enter_price');
  String get pleaseEnterValidPrice => translate('please_enter_valid_price');
  String get rentalDurationDays => translate('rental_duration_days');
  String get requiredForOnce => translate('required_for_once');
  String get pleaseEnterDuration => translate('please_enter_duration');
  String get durationRange => translate('duration_range');
  String get submitOfferBtn => translate('submit_offer_btn');
  String get offerSubmittedSuccess => translate('offer_submitted_success');
  String get offerSubmitFailed => translate('offer_submit_failed');
  String get serverError => translate('server_error');
  String get invalidData => translate('invalid_data');
  String get unloadOperations => translate('unload_operations');

  // ─────────────── Drivers ───────────────
  String get manageDrivers => translate('manage_drivers');
  String get noDrivers => translate('no_drivers');
  String get noDriversDesc => translate('no_drivers_desc');
  String get aboutDriver => translate('about_driver');
  String get identityNumber => translate('identity_number');
  String get notAvailable => translate('not_available');
  String get statistics => translate('statistics');
  String get currentOrders => translate('current_orders');
  String get completedOrdersStat => translate('completed_orders_stat');
  String get totalOrders => translate('total_orders');
  String get driverOrders => translate('driver_orders');
  String get noOrdersForDriver => translate('no_orders_for_driver');
  String get errorLoadingDriverData => translate('error_loading_driver_data');
  String get driverNotFound => translate('driver_not_found');
  String get orderType => translate('order_type');
  String get edit => translate('edit');
  String get delete => translate('delete');
  String get type => translate('type');

  // ─────────────── Add Driver Dialog ───────────────
  String get addNewDriver => translate('add_new_driver');
  String get driverInfo => translate('driver_info');
  String get driverNameLabel => translate('driver_name_label');
  String get enterFullName => translate('enter_full_name');
  String get nameRequired => translate('name_required');
  String get nameMinLength => translate('name_min_length');
  String get phoneNumber => translate('phone_number');
  String get phoneRequired => translate('phone_required');
  String get identityNumberLabel => translate('identity_number_label');
  String get identityMinLength => translate('identity_min_length');
  String get driverStatus => translate('driver_status');
  String get selectDriverStatus => translate('select_driver_status');
  String get available => translate('available');
  String get onDuty => translate('on_duty');
  String get offDuty => translate('off_duty');
  String get onBreak => translate('on_break');
  String get emailOptional => translate('email_optional');
  String get emailInvalid => translate('email_invalid');
  String get passwordRequired => translate('password_required');
  String get passwordMinLength => translate('password_min_length');
  String get confirmPasswordRequired => translate('confirm_password_required');
  String get addDriver => translate('add_driver');
  String get driverAddedSuccess => translate('driver_added_success');
  String get pleaseSelectDriverStatus => translate('please_select_driver_status');

  // ─────────────── Edit Driver Dialog ───────────────
  String get editDriverData => translate('edit_driver_data');
  String get updateData => translate('update_data');
  String get driverUpdatedSuccess => translate('driver_updated_success');
  String get newPasswordOptional => translate('new_password_optional');

  // ─────────────── Delete Driver Dialog ───────────────
  String get confirmDeleteDriver => translate('confirm_delete_driver');
  String get confirmDeleteDriverMsg => translate('confirm_delete_driver_msg');
  String get cannotUndo => translate('cannot_undo');
  String get driverDeletedSuccess => translate('driver_deleted_success');
  String get driverDeleteFailed => translate('driver_delete_failed');

  // ─────────────── Containers - Summary ───────────────
  String get manageContainers => translate('manage_containers');
  String get noContainers => translate('no_containers');
  String get addContainer => translate('add_container');
  String get total => translate('total');
  String get rented => translate('rented');
  String get maintenance => translate('maintenance');

  // ─────────────── Add Container Bottom Sheet ───────────────
  String get addNewContainer => translate('add_new_container');
  String get containerTypeRequired => translate('container_type_required');
  String get selectContainerType => translate('select_container_type');
  String get containerSize => translate('container_size');
  String get selectContainerSize => translate('select_container_size');
  String get errorLoadingTypes => translate('error_loading_types');
  String get containerCount => translate('container_count');
  String get containerStatus => translate('container_status');
  String get availableForRent => translate('available_for_rent');
  String get addContainerBtn => translate('add_container_btn');
  String willAddContainers(int qty) => translate('will_add_containers').replaceAll('{qty}', qty.toString());

  // ─────────────── Delete Containers Dialog ───────────────
  String get deleteContainers => translate('delete_containers');
  String get typeLabel => translate('type_label');
  String get sizeLabel => translate('size_label');
  String get availableForDeletion => translate('available_for_deletion');
  String get noContainersAvailableForDeletion => translate('no_containers_available_for_deletion');
  String get howManyToDelete => translate('how_many_to_delete');
  String get maxLimit => translate('max_limit');
  String get importantWarning => translate('important_warning');
  String get onlyAvailableDeleted => translate('only_available_deleted');
  String get cannotUndoAction => translate('cannot_undo_action');
  String get containersDeletedSuccess => translate('containers_deleted_success');

  // ─────────────── Edit Container Status Sheet ───────────────
  String get manageContainersSheet => translate('manage_containers_sheet');
  String get selectedXOfY => translate('selected_x_of_y');
  String get containerWord => translate('container_word');
  String get selectAll => translate('select_all');
  String get deselectAll => translate('deselect_all');
  String get selectNewStatus => translate('select_new_status');
  String get changeStatus => translate('change_status');

  // ─────────────── Dashboard ───────────────
  String get dashboardTitle => translate('dashboard_title');
  String get errorLoadingData => translate('error_loading_data');
  String get containerStats => translate('container_stats');
  String get totalContainers => translate('total_containers');
  String get rentedContainers => translate('rented_containers');
  String get availableContainers => translate('available_containers');
  String get orderStats => translate('order_stats');
  String get totalOrdersStat => translate('total_orders_stat');
  String get pendingOrders => translate('pending_orders');
  String get completedStat => translate('completed_stat');
  String get driverStats => translate('driver_stats');
  String get totalDrivers => translate('total_drivers');
  String get completionRate => translate('completion_rate');
  String get monthlyStats => translate('monthly_stats');
  String get revenueThousands => translate('revenue_thousands');
  String get revenueTooltip => translate('revenue_tooltip');
  String get ordersTooltip => translate('orders_tooltip');

  // ─────────────── Notifications ───────────────
  String get notifications => translate('notifications');
  String get orderNotifications => translate('order_notifications');
  String get messagesAndRatings => translate('messages_and_ratings');
  String get noOrderNotifications => translate('no_order_notifications');
  String get noMessagesOrRatings => translate('no_messages_or_ratings');
  String get newNotificationsAppearHere => translate('new_notifications_appear_here');
  String get orderHashPrefix => translate('order_hash_prefix');

  // ─────────────── Profile Screen ───────────────
  String get profileTitle => translate('profile_title');
  String get facilityData => translate('facility_data');
  String get companyIdentifier => translate('company_identifier');
  String get contactNumber => translate('contact_number');
  String get accountManager => translate('account_manager');
  String get fullName => translate('full_name');
  String get termsAndPolicies => translate('terms_and_policies');
  String get logout => translate('logout');
  String get logoutConfirm => translate('logout_confirm');
  String get logoutBtn => translate('logout_btn');
  String get verified => translate('verified');
  String get underReview => translate('under_review');
  String get retryBtn => translate('retry_btn');
  String get language => translate('language');

  // ─────────────── Support Screen ───────────────
  String get supportTitle => translate('support_title');
  String get typeYourMessage => translate('type_your_message');
  String get failedToSendMessage => translate('failed_to_send_message');
  String get today => translate('today');
  String get yesterday => translate('yesterday');

  // ─────────────── Shared Pages ───────────────
  String get termsAndConditions => translate('terms_and_conditions');
  String get privacyPolicyTitle => translate('privacy_policy_title');

  // ─────────────── Order Management ───────────────
  String get orderManagement => translate('order_management');
  String get manageOrders => translate('manage_orders');
  String get viewAndManageOrders => translate('view_and_manage_orders');
  String get viewAndManageContainers => translate('view_and_manage_containers');
  String get viewAndManageDrivers => translate('view_and_manage_drivers');

  // ─────────────── Driver Assignment ───────────────
  String get selectDriver => translate('select_driver');
  String get noDriversAvailable => translate('no_drivers_available');
  String get driverAssignedSuccess => translate('driver_assigned_success');
  String get driverAssignFailed => translate('driver_assign_failed');

  // ─────────────── Status Labels ───────────────
  String get statusPendingOffers => translate('status_pending_offers');
  String get statusAccepted => translate('status_accepted');
  String get statusInProgress => translate('status_in_progress');
  String get statusCompleted => translate('status_completed');
  String get statusCancelled => translate('status_cancelled');
  String get statusScheduled => translate('status_scheduled');
  String get statusPickedUp => translate('status_picked_up');

  // ─────────────── Rental Type Labels ───────────────
  String get rentalOnce => translate('rental_once');
  String get rentalMonthly => translate('rental_monthly');
  String get rentalAnnual => translate('rental_annual');

  // ─────────────── Translations Map ───────────────
  static const Map<String, Map<String, String>> _localizedValues = {
    // ═══════════════ ARABIC ═══════════════
    'ar': {
      // Main Layout
      'app_name': 'حاويتكم',
      'technical_support': 'الدعم الفني',
      'profile': 'الملف الشخصي',
      'dashboard': 'لوحة التحكم',
      'orders': 'الطلبات',
      'drivers': 'السائقين',
      'containers': 'الحاويات',

      // Landing Screen
      'manage_containers_easily': 'إدارة الحاويات والطلبات بكل سهولة',
      'sign_in': 'تسجيل الدخول',
      'create_new_account': 'إنشاء حساب جديد',

      // Sign In
      'sign_in_title': 'تسجيل الدخول',
      'welcome_back': 'مرحباً بك مرة أخرى',
      'saved_account': 'حساب محفوظ',
      'use_another_account': 'استخدام حساب آخر',
      'company_id_label': 'الرقم التعريفي للشركة',
      'company_id_hint': '0123456789',
      'please_enter_company_id': 'الرجاء إدخال الرقم التعريفي',
      'admin_email_label': 'البريد الإلكتروني للمسؤول',
      'enter_email': 'أدخل البريد الإلكتروني',
      'please_enter_email': 'الرجاء إدخال البريد الإلكتروني',
      'please_enter_valid_email': 'الرجاء إدخال بريد إلكتروني صحيح',
      'admin_password_label': 'كلمة سر المسؤول',
      'enter_password': 'أدخل كلمة المرور',
      'please_enter_password': 'الرجاء إدخال كلمة المرور',
      'save_login_info': 'حفظ معلومات الدخول',
      'i_agree_to': 'أوافق على ',
      'terms_of_service': 'شروط الخدمة',
      'and': ' و ',
      'privacy_policy': 'سياسة الخصوصية',
      'must_agree_to_terms': 'يجب الموافقة على شروط الخدمة وسياسة الخصوصية',
      'no_account_yet': 'ليس لديك حساب؟ ',
      'create_new_account_link': 'إنشاء حساب جديد',
      'permanent_ban': 'حظر دائم',
      'temporary_ban': 'حظر مؤقت',
      'ban_reason': 'سبب الحظر:',

      // Sign Up
      'sign_up_title': 'إنشاء حساب جديد',
      'step1_company_data': 'الخطوة 1: بيانات الشركة',
      'company_name': 'اسم الشركة',
      'enter_company_name': 'أدخل اسم الشركة',
      'required': 'مطلوب',
      'commercial_reg_number': 'رقم السجل التجاري',
      'must_be_10_digits': 'يجب أن يكون 10 أرقام',
      'tax_number': 'الرقم الضريبي',
      'enter_tax_number': 'أدخل الرقم الضريبي',
      'company_phone': 'رقم هاتف الشركة',
      'phone_number_too_short': 'رقم الهاتف قصير جداً',
      'region_and_city': 'المنطقة والمدينة',
      'region': 'المنطقة',
      'city': 'المدينة',
      'please_select_region': 'الرجاء اختيار المنطقة',
      'please_select_city': 'الرجاء اختيار المدينة',
      'company_logo': 'شعار الشركة',
      'select_company_logo': 'اختر شعار الشركة',
      'logo_selected': 'تم اختيار الشعار',
      'image_size_limit': 'حجم الصورة يجب أن يكون أقل من 2 ميجا',
      'company_location': 'موقع الشركة',
      'my_current_location': 'موقعي الحالي',
      'latitude': 'خط العرض',
      'longitude': 'خط الطول',
      'invalid_value': 'قيمة غير صالحة',
      'bank_info': 'معلومات البنك',
      'bank_name': 'اسم البنك',
      'enter_bank_name': 'أدخل اسم البنك',
      'bank_account_number': 'رقم الحساب البنكي',
      'enter_account_number': 'أدخل رقم الحساب',
      'iban_number': 'رقم الآيبان (IBAN)',
      'account_holder_name': 'اسم صاحب الحساب',
      'enter_account_holder_name': 'أدخل اسم صاحب الحساب',
      'admin_account': 'حساب المسؤول',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      're_enter_password': 'أعد إدخال كلمة المرور',
      'passwords_do_not_match': 'كلمات المرور غير متطابقة',
      'must_be_6_chars': 'يجب أن تكون 6 أحرف على الأقل',
      'invalid_email': 'بريد إلكتروني غير صالح',
      'send_verification_code': 'إرسال رمز التحقق',
      'already_have_account': 'لديك حساب بالفعل؟ ',
      'failed_load_data': 'فشل تحميل البيانات',
      'please_enable_location': 'الرجاء تفعيل خدمة الموقع من الإعدادات',
      'location_permission_denied': 'تم رفض إذن الموقع',
      'location_permission_required': 'إذن الموقع مطلوب',
      'allow_location_access': 'الرجاء السماح بالوصول للموقع من إعدادات التطبيق',
      'cancel': 'إلغاء',
      'open_settings': 'فتح الإعدادات',
      'location_set_success': 'تم تحديد موقعك بنجاح',
      'failed_get_location': 'فشل الحصول على الموقع',
      'please_select_logo': 'الرجاء اختيار شعار الشركة',
      'please_select_city_msg': 'الرجاء اختيار المدينة',

      // Sign Up - Verification
      'email_verification': 'التحقق من البريد الإلكتروني',
      'step2_verification_code': 'الخطوة 2: أدخل رمز التحقق المرسل إلى بريدك',
      'verification_code': 'رمز التحقق',
      'confirm_registration': 'تأكيد التسجيل',

      // Sign Up - Pending
      'request_sent_success': 'تم إرسال طلبك بنجاح!',
      'request_under_review': 'طلبك قيد المراجعة. سوف تتلقى بريدًا إلكترونيًا برقم تعريفي مكون من 10 أرقام لتسجيل الدخول بعد الموافقة.',
      'back_to_sign_in': 'العودة لتسجيل الدخول',

      // Orders - Main Tabs
      'new_orders': 'الجديدة',
      'accepted_orders': 'المقبولة',
      'sub_orders': 'الفرعية',
      'completed_orders': 'المكتملة',
      'cancelled_orders': 'الملغية',

      // Pending Orders
      'available_orders': 'الطلبات المتاحة',
      'retry': 'إعادة المحاولة',
      'no_available_orders_now': 'لا توجد طلبات متاحة حالياً',
      'filter_orders': 'تصفية الطلبات',
      'container_type': 'نوع الحاوية',
      'size': 'الحجم',
      'all': 'الكل',
      'reset': 'إعادة تعيين',
      'apply': 'تطبيق',
      'sort_by_distance': 'ترتيب حسب المسافة',
      'sort_by_date': 'ترتيب حسب التاريخ',
      'sort_by_type': 'ترتيب حسب النوع',
      'rental_type': 'نوع الإيجار',
      'delivery_date': 'تاريخ التوصيل',
      'address': 'العنوان',
      'unspecified': 'غير محدد',
      'distance': 'المسافة',
      'customer': 'العميل',
      'phone': 'الهاتف',
      'submit_offer': 'تقديم عرض',
      'offer_submitted': 'مقدم عرض',
      'offer_submitted_for_order': 'تم تقديم عرض لهذا الطلب',
      'km': 'كم',

      // Accepted Orders
      'without_driver': 'بدون سائق',
      'with_driver': 'مع سائق',
      'all_orders_have_drivers': 'جميع الطلبات لديها سائقين معينين',
      'no_orders_with_drivers': 'لا توجد طلبات مع سائقين',
      'assign_driver': 'تعيين سائق',
      'container_number': 'حاوية رقم',
      'license_label': 'رخصة',
      'vehicle_label': 'مركبة',
      'tracking_coming_soon': 'ميزة التتبع قريباً',
      'track': 'تتبع',
      'order_prefix': 'الطلب',

      // Sub Orders
      'sub_orders_title': 'الطلبات الفرعية',
      'unload': 'تفريغ 🗑️',
      'return_order': 'إرجاع ↩️',
      'no_unload_orders': 'لا توجد طلبات تفريغ',
      'no_return_orders': 'لا توجد طلبات إرجاع',
      'change_driver': 'تغيير السائق',
      'delivery_date_label': 'تاريخ التسليم',
      'assign': 'تعيين',

      // Completed Orders
      'no_completed_orders': 'لا توجد طلبات مكتملة',
      'no_filters_available': 'لا توجد مرشحات متاحة',
      'showing_x_of_y': 'عرض',
      'of_word': 'من',
      'order_word': 'طلب',
      'city_label': 'المدينة',

      // Cancelled Orders
      'no_cancelled_orders': 'لا توجد طلبات ملغية',
      'cancelled': 'ملغي',
      'cancellation_date': 'تاريخ الإلغاء',
      'cancellation_reason': 'سبب الإلغاء',

      // Order Details Modal
      'status': 'الحالة',
      'completion_date': 'تاريخ الإكمال',
      'total_price': 'السعر الإجمالي',
      'total_label': 'الإجمالي:',
      'sar': 'ريال',
      'assigned_driver': 'السائق المعين',
      'driver_name': 'الاسم',
      'license_number': 'رقم الرخصة',

      // Submit Offer Dialog
      'submit_offer_title': 'تقديم عرض',
      'delivery': 'التوصيل',
      'base_price_sar': 'السعر الأساسي (ريال)',
      'please_enter_price': 'الرجاء إدخال السعر',
      'please_enter_valid_price': 'الرجاء إدخال سعر صحيح',
      'rental_duration_days': 'مدة الإيجار (أيام)',
      'required_for_once': 'مطلوب لنوع "لمرة واحدة"',
      'please_enter_duration': 'الرجاء إدخال مدة الإيجار',
      'duration_range': 'المدة يجب أن تكون بين 1 و 365 يوم',
      'submit_offer_btn': 'تقديم العرض',
      'offer_submitted_success': '✅ تم تقديم العرض بنجاح',
      'offer_submit_failed': 'فشل تقديم العرض',
      'server_error': 'خطأ في الخادم. الرجاء المحاولة لاحقاً',
      'invalid_data': 'بيانات غير صحيحة. تحقق من المدخلات',
      'unload_operations': 'عملية تفريغ',

      // Drivers
      'manage_drivers': 'إدارة السائقين',
      'no_drivers': 'لا يوجد سائقين',
      'no_drivers_desc': 'لم يتم إضافة أي سائقين بعد. ابدأ بإضافة سائق جديد لإدارة فريق السائقين.',
      'about_driver': 'حول السائق',
      'identity_number': 'رقم الهوية',
      'not_available': 'غير متوفر',
      'statistics': 'الإحصائيات',
      'current_orders': 'الطلبات الحالية',
      'completed_orders_stat': 'الطلبات المكتملة',
      'total_orders': 'إجمالي الطلبات',
      'driver_orders': 'الطلبات الخاصة بالسائق',
      'no_orders_for_driver': 'لا توجد طلبات مخصصة لهذا السائق',
      'error_loading_driver_data': 'خطأ في تحميل بيانات السائق',
      'driver_not_found': 'لم يتم العثور على بيانات السائق',
      'order_type': 'نوع الطلب',
      'edit': 'تعديل',
      'delete': 'حذف',
      'type': 'النوع',

      // Add Driver
      'add_new_driver': 'إضافة سائق جديد',
      'driver_info': 'معلومات السائق',
      'driver_name_label': 'اسم السائق',
      'enter_full_name': 'أدخل الاسم الكامل',
      'name_required': 'الاسم مطلوب',
      'name_min_length': 'الاسم يجب أن يكون على الأقل حرفين',
      'phone_number': 'رقم الهاتف',
      'phone_required': 'رقم الهاتف مطلوب',
      'identity_number_label': 'رقم الهوية',
      'identity_min_length': 'رقم الهوية يجب أن يكون على الأقل 5 أرقام',
      'driver_status': 'حالة السائق',
      'select_driver_status': 'اختر حالة السائق',
      'available': 'متاح',
      'on_duty': 'في الخدمة',
      'off_duty': 'خارج الخدمة',
      'on_break': 'في استراحة',
      'email_optional': 'البريد الإلكتروني (اختياري)',
      'email_invalid': 'البريد الإلكتروني غير صالح',
      'password_required': 'كلمة المرور مطلوبة',
      'password_min_length': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      'confirm_password_required': 'تأكيد كلمة المرور مطلوب',
      'add_driver': 'إضافة السائق',
      'driver_added_success': 'تمت إضافة السائق بنجاح',
      'please_select_driver_status': 'يرجى اختيار حالة السائق',

      // Edit Driver
      'edit_driver_data': 'تعديل بيانات السائق',
      'update_data': 'تحديث البيانات',
      'driver_updated_success': 'تم تحديث بيانات السائق بنجاح',
      'new_password_optional': 'كلمة المرور الجديدة (اتركها فارغة إذا لم ترد تغييرها)',

      // Delete Driver
      'confirm_delete_driver': 'تأكيد حذف السائق',
      'confirm_delete_driver_msg': 'هل أنت متأكد من حذف السائق: ',
      'cannot_undo': 'لا يمكن التراجع عن هذا الإجراء.',
      'driver_deleted_success': 'تم حذف السائق بنجاح',
      'driver_delete_failed': 'فشل حذف السائق',

      // Containers - Summary
      'manage_containers': 'إدارة الحاويات',
      'no_containers': 'لا توجد حاويات',
      'add_container': 'إضافة حاوية',
      'total': 'إجمالي',
      'rented': 'مؤجرة',
      'maintenance': 'صيانة',

      // Add Container
      'add_new_container': 'إضافة حاوية جديدة',
      'container_type_required': 'نوع الحاوية *',
      'select_container_type': 'اختر نوع الحاوية',
      'container_size': 'حجم الحاوية *',
      'select_container_size': 'اختر حجم الحاوية',
      'error_loading_types': 'خطأ في تحميل الأنواع',
      'container_count': 'عدد الحاويات *',
      'container_status': 'حالة الحاوية',
      'available_for_rent': 'متاح للتأجير',
      'add_container_btn': 'إضافة الحاوية',
      'will_add_containers': 'سيتم إضافة {qty} حاوية من نفس النوع والحجم',

      // Delete Containers
      'delete_containers': 'حذف حاويات',
      'type_label': 'النوع',
      'size_label': 'الحجم',
      'available_for_deletion': 'عدد الحاويات المتاحة للحذف',
      'no_containers_available_for_deletion': 'لا توجد حاويات متاحة للحذف. جميع الحاويات مؤجرة أو في الصيانة.',
      'how_many_to_delete': 'كم حاوية تريد حذفها؟',
      'max_limit': 'الحد الأقصى',
      'important_warning': 'تنبيه مهم',
      'only_available_deleted': '• سيتم حذف فقط الحاويات المتاحة (غير المؤجرة)',
      'cannot_undo_action': '• لا يمكن التراجع عن هذا الإجراء',
      'containers_deleted_success': 'تم حذف الحاويات بنجاح!',

      // Edit Container Status
      'manage_containers_sheet': 'إدارة الحاويات',
      'selected_x_of_y': 'تم تحديد',
      'container_word': 'حاوية',
      'select_all': 'تحديد الكل',
      'deselect_all': 'إلغاء',
      'select_new_status': 'اختر الحالة الجديدة',
      'change_status': 'تغيير الحالة',

      // Dashboard
      'dashboard_title': 'لوحة التحكم',
      'error_loading_data': 'خطأ في تحميل البيانات',
      'container_stats': 'إحصائيات الحاويات',
      'total_containers': 'الإجمالي',
      'rented_containers': 'المؤجرة',
      'available_containers': 'المتوفرة',
      'order_stats': 'إحصائيات الطلبات',
      'total_orders_stat': 'الإجمالي',
      'pending_orders': 'قيد المعالجة',
      'completed_stat': 'مكتملة',
      'driver_stats': 'إحصائيات السائقين',
      'total_drivers': 'عدد السائقين',
      'completion_rate': 'نسبة الإنجاز',
      'monthly_stats': 'الإحصائيات الشهرية للطلبات والإيرادات',
      'revenue_thousands': 'الإيرادات (بالآلاف)',
      'revenue_tooltip': 'الإيرادات',
      'orders_tooltip': 'الطلبات',

      // Notifications
      'notifications': 'الإشعارات',
      'order_notifications': 'الطلبات',
      'messages_and_ratings': 'الرسائل والتقييمات',
      'no_order_notifications': 'لا توجد إشعارات طلبات',
      'no_messages_or_ratings': 'لا توجد رسائل أو تقييمات',
      'new_notifications_appear_here': 'ستظهر الإشعارات الجديدة هنا',
      'order_hash_prefix': 'طلب #',

      // Profile
      'profile_title': 'الملف الشخصي',
      'facility_data': 'بيانات المنشأة',
      'company_identifier': 'معرف الشركة',
      'contact_number': 'رقم التواصل',
      'account_manager': 'المسؤول عن الحساب',
      'full_name': 'الاسم الكامل',
      'terms_and_policies': 'الشروط والسياسات',
      'logout': 'تسجيل الخروج',
      'logout_confirm': 'هل أنت متأكد من تسجيل الخروج؟',
      'logout_btn': 'خروج',
      'verified': 'موثق',
      'under_review': 'تحت المراجعة',
      'retry_btn': 'إعادة المحاولة',
      'language': 'اللغة',

      // Support
      'support_title': 'الدعم الفني',
      'type_your_message': 'اكتب رسالتك...',
      'failed_to_send_message': 'تعذر إرسال الرسالة',
      'today': 'اليوم',
      'yesterday': 'أمس',

      // Shared Pages
      'terms_and_conditions': 'الشروط والأحكام',
      'privacy_policy_title': 'سياسة الخصوصية',

      // Order Management Screen
      'order_management': 'إدارة الطلبات',
      'manage_orders': 'إدارة الطلبات',
      'view_and_manage_orders': 'عرض وإدارة جميع الطلبات',
      'view_and_manage_containers': 'عرض وإدارة جميع الحاويات',
      'view_and_manage_drivers': 'عرض وإدارة جميع السائقين',

      // Driver Assignment
      'select_driver': 'اختر سائق',
      'no_drivers_available': 'لا يوجد سائقين متاحين',
      'driver_assigned_success': 'تم تعيين السائق بنجاح',
      'driver_assign_failed': 'فشل تعيين السائق',

      // Status Labels
      'status_pending_offers': 'بانتظار العروض',
      'status_accepted': 'مقبول',
      'status_in_progress': 'جاري التنفيذ',
      'status_completed': 'مكتمل',
      'status_cancelled': 'ملغي',
      'status_scheduled': 'مجدول',
      'status_picked_up': 'تم الاستلام',

      // Rental Type Labels
      'rental_once': 'لمرة واحدة',
      'rental_monthly': 'شهري',
      'rental_annual': 'سنوي',
    },

    // ═══════════════ ENGLISH ═══════════════
    'en': {
      // Main Layout
      'app_name': 'Hawiyatkom',
      'technical_support': 'Technical Support',
      'profile': 'Profile',
      'dashboard': 'Dashboard',
      'orders': 'Orders',
      'drivers': 'Drivers',
      'containers': 'Containers',

      // Landing Screen
      'manage_containers_easily': 'Manage containers and orders easily',
      'sign_in': 'Sign In',
      'create_new_account': 'Create New Account',

      // Sign In
      'sign_in_title': 'Sign In',
      'welcome_back': 'Welcome back',
      'saved_account': 'Saved Account',
      'use_another_account': 'Use another account',
      'company_id_label': 'Company ID Number',
      'company_id_hint': '0123456789',
      'please_enter_company_id': 'Please enter company ID',
      'admin_email_label': 'Admin Email',
      'enter_email': 'Enter email',
      'please_enter_email': 'Please enter email',
      'please_enter_valid_email': 'Please enter a valid email',
      'admin_password_label': 'Admin Password',
      'enter_password': 'Enter password',
      'please_enter_password': 'Please enter password',
      'save_login_info': 'Save login info',
      'i_agree_to': 'I agree to ',
      'terms_of_service': 'Terms of Service',
      'and': ' and ',
      'privacy_policy': 'Privacy Policy',
      'must_agree_to_terms': 'You must agree to the Terms of Service and Privacy Policy',
      'no_account_yet': "Don't have an account? ",
      'create_new_account_link': 'Create new account',
      'permanent_ban': 'Permanent Ban',
      'temporary_ban': 'Temporary Ban',
      'ban_reason': 'Ban Reason:',

      // Sign Up
      'sign_up_title': 'Create New Account',
      'step1_company_data': 'Step 1: Company Data',
      'company_name': 'Company Name',
      'enter_company_name': 'Enter company name',
      'required': 'Required',
      'commercial_reg_number': 'Commercial Registration Number',
      'must_be_10_digits': 'Must be 10 digits',
      'tax_number': 'Tax Number',
      'enter_tax_number': 'Enter tax number',
      'company_phone': 'Company Phone',
      'phone_number_too_short': 'Phone number is too short',
      'region_and_city': 'Region & City',
      'region': 'Region',
      'city': 'City',
      'please_select_region': 'Please select region',
      'please_select_city': 'Please select city',
      'company_logo': 'Company Logo',
      'select_company_logo': 'Select company logo',
      'logo_selected': 'Logo selected',
      'image_size_limit': 'Image size must be less than 2 MB',
      'company_location': 'Company Location',
      'my_current_location': 'My Current Location',
      'latitude': 'Latitude',
      'longitude': 'Longitude',
      'invalid_value': 'Invalid value',
      'bank_info': 'Bank Information',
      'bank_name': 'Bank Name',
      'enter_bank_name': 'Enter bank name',
      'bank_account_number': 'Bank Account Number',
      'enter_account_number': 'Enter account number',
      'iban_number': 'IBAN Number',
      'account_holder_name': 'Account Holder Name',
      'enter_account_holder_name': 'Enter account holder name',
      'admin_account': 'Admin Account',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      're_enter_password': 'Re-enter password',
      'passwords_do_not_match': 'Passwords do not match',
      'must_be_6_chars': 'Must be at least 6 characters',
      'invalid_email': 'Invalid email',
      'send_verification_code': 'Send Verification Code',
      'already_have_account': 'Already have an account? ',
      'failed_load_data': 'Failed to load data',
      'please_enable_location': 'Please enable location service from settings',
      'location_permission_denied': 'Location permission denied',
      'location_permission_required': 'Location permission required',
      'allow_location_access': 'Please allow location access from app settings',
      'cancel': 'Cancel',
      'open_settings': 'Open Settings',
      'location_set_success': 'Location set successfully',
      'failed_get_location': 'Failed to get location',
      'please_select_logo': 'Please select company logo',
      'please_select_city_msg': 'Please select city',

      // Sign Up - Verification
      'email_verification': 'Email Verification',
      'step2_verification_code': 'Step 2: Enter the verification code sent to your email',
      'verification_code': 'Verification Code',
      'confirm_registration': 'Confirm Registration',

      // Sign Up - Pending
      'request_sent_success': 'Request sent successfully!',
      'request_under_review': 'Your request is under review. You will receive an email with a 10-digit ID for login after approval.',
      'back_to_sign_in': 'Back to Sign In',

      // Orders - Main Tabs
      'new_orders': 'New',
      'accepted_orders': 'Accepted',
      'sub_orders': 'Sub-orders',
      'completed_orders': 'Completed',
      'cancelled_orders': 'Cancelled',

      // Pending Orders
      'available_orders': 'Available Orders',
      'retry': 'Retry',
      'no_available_orders_now': 'No available orders at the moment',
      'filter_orders': 'Filter Orders',
      'container_type': 'Container Type',
      'size': 'Size',
      'all': 'All',
      'reset': 'Reset',
      'apply': 'Apply',
      'sort_by_distance': 'Sort by Distance',
      'sort_by_date': 'Sort by Date',
      'sort_by_type': 'Sort by Type',
      'rental_type': 'Rental Type',
      'delivery_date': 'Delivery Date',
      'address': 'Address',
      'unspecified': 'Unspecified',
      'distance': 'Distance',
      'customer': 'Customer',
      'phone': 'Phone',
      'submit_offer': 'Submit Offer',
      'offer_submitted': 'Offer Submitted',
      'offer_submitted_for_order': 'Offer already submitted for this order',
      'km': 'km',

      // Accepted Orders
      'without_driver': 'Without Driver',
      'with_driver': 'With Driver',
      'all_orders_have_drivers': 'All orders have assigned drivers',
      'no_orders_with_drivers': 'No orders with drivers',
      'assign_driver': 'Assign Driver',
      'container_number': 'Container No.',
      'license_label': 'License',
      'vehicle_label': 'Vehicle',
      'tracking_coming_soon': 'Tracking feature coming soon',
      'track': 'Track',
      'order_prefix': 'Order',

      // Sub Orders
      'sub_orders_title': 'Sub Orders',
      'unload': 'Unload 🗑️',
      'return_order': 'Return ↩️',
      'no_unload_orders': 'No unload orders',
      'no_return_orders': 'No return orders',
      'change_driver': 'Change Driver',
      'delivery_date_label': 'Delivery Date',
      'assign': 'Assign',

      // Completed Orders
      'no_completed_orders': 'No completed orders',
      'no_filters_available': 'No filters available',
      'showing_x_of_y': 'Showing',
      'of_word': 'of',
      'order_word': 'orders',
      'city_label': 'City',

      // Cancelled Orders
      'cancelled': 'Cancelled',
      'cancellation_date': 'Cancellation Date',
      'cancellation_reason': 'Cancellation Reason',

      // Order Details Modal
      'status': 'Status',
      'completion_date': 'Completion Date',
      'total_price': 'Total Price',
      'total_label': 'Total:',
      'sar': 'SAR',
      'assigned_driver': 'Assigned Driver',
      'driver_name': 'Name',
      'license_number': 'License Number',

      // Submit Offer Dialog
      'submit_offer_title': 'Submit Offer',
      'delivery': 'Delivery',
      'base_price_sar': 'Base Price (SAR)',
      'please_enter_price': 'Please enter price',
      'please_enter_valid_price': 'Please enter a valid price',
      'rental_duration_days': 'Rental Duration (days)',
      'required_for_once': 'Required for "one-time" type',
      'please_enter_duration': 'Please enter rental duration',
      'duration_range': 'Duration must be between 1 and 365 days',
      'submit_offer_btn': 'Submit Offer',
      'offer_submitted_success': '✅ Offer submitted successfully',
      'offer_submit_failed': 'Failed to submit offer',
      'server_error': 'Server error. Please try again later',
      'invalid_data': 'Invalid data. Check your inputs',
      'unload_operations': 'unload operation(s)',

      // Drivers
      'manage_drivers': 'Manage Drivers',
      'no_drivers': 'No Drivers',
      'no_drivers_desc': 'No drivers have been added yet. Start by adding a new driver to manage your driver team.',
      'about_driver': 'About Driver',
      'identity_number': 'Identity Number',
      'not_available': 'Not available',
      'statistics': 'Statistics',
      'current_orders': 'Current Orders',
      'completed_orders_stat': 'Completed Orders',
      'total_orders': 'Total Orders',
      'driver_orders': 'Driver Orders',
      'no_orders_for_driver': 'No orders assigned to this driver',
      'error_loading_driver_data': 'Error loading driver data',
      'driver_not_found': 'Driver data not found',
      'order_type': 'Order Type',
      'edit': 'Edit',
      'delete': 'Delete',
      'type': 'Type',

      // Add Driver
      'add_new_driver': 'Add New Driver',
      'driver_info': 'Driver Information',
      'driver_name_label': 'Driver Name',
      'enter_full_name': 'Enter full name',
      'name_required': 'Name is required',
      'name_min_length': 'Name must be at least 2 characters',
      'phone_number': 'Phone Number',
      'phone_required': 'Phone number is required',
      'identity_number_label': 'Identity Number',
      'identity_min_length': 'Identity number must be at least 5 digits',
      'driver_status': 'Driver Status',
      'select_driver_status': 'Select driver status',
      'available': 'Available',
      'on_duty': 'On Duty',
      'off_duty': 'Off Duty',
      'on_break': 'On Break',
      'email_optional': 'Email (optional)',
      'email_invalid': 'Invalid email',
      'password_required': 'Password is required',
      'password_min_length': 'Password must be at least 6 characters',
      'confirm_password_required': 'Password confirmation is required',
      'add_driver': 'Add Driver',
      'driver_added_success': 'Driver added successfully',
      'please_select_driver_status': 'Please select driver status',

      // Edit Driver
      'edit_driver_data': 'Edit Driver Data',
      'update_data': 'Update Data',
      'driver_updated_success': 'Driver data updated successfully',
      'new_password_optional': 'New password (leave empty if not changing)',

      // Delete Driver
      'confirm_delete_driver': 'Confirm Delete Driver',
      'confirm_delete_driver_msg': 'Are you sure you want to delete driver: ',
      'cannot_undo': 'This action cannot be undone.',
      'driver_deleted_success': 'Driver deleted successfully',
      'driver_delete_failed': 'Failed to delete driver',

      // Containers - Summary
      'manage_containers': 'Manage Containers',
      'no_containers': 'No Containers',
      'add_container': 'Add Container',
      'total': 'Total',
      'rented': 'Rented',
      'maintenance': 'Maintenance',

      // Add Container
      'add_new_container': 'Add New Container',
      'container_type_required': 'Container Type *',
      'select_container_type': 'Select container type',
      'container_size': 'Container Size *',
      'select_container_size': 'Select container size',
      'error_loading_types': 'Error loading types',
      'container_count': 'Number of Containers *',
      'container_status': 'Container Status',
      'available_for_rent': 'Available for Rent',
      'add_container_btn': 'Add Container',
      'will_add_containers': '{qty} containers of the same type and size will be added',

      // Delete Containers
      'delete_containers': 'Delete Containers',
      'type_label': 'Type',
      'size_label': 'Size',
      'available_for_deletion': 'Containers available for deletion',
      'no_containers_available_for_deletion': 'No containers available for deletion. All containers are rented or in maintenance.',
      'how_many_to_delete': 'How many containers to delete?',
      'max_limit': 'Maximum',
      'important_warning': 'Important Warning',
      'only_available_deleted': '• Only available (not rented) containers will be deleted',
      'cannot_undo_action': '• This action cannot be undone',
      'containers_deleted_success': 'Containers deleted successfully!',

      // Edit Container Status
      'manage_containers_sheet': 'Manage Containers',
      'selected_x_of_y': 'Selected',
      'container_word': 'containers',
      'select_all': 'Select All',
      'deselect_all': 'Deselect',
      'select_new_status': 'Select new status',
      'change_status': 'Change Status',

      // Dashboard
      'dashboard_title': 'Dashboard',
      'error_loading_data': 'Error loading data',
      'container_stats': 'Container Statistics',
      'total_containers': 'Total',
      'rented_containers': 'Rented',
      'available_containers': 'Available',
      'order_stats': 'Order Statistics',
      'total_orders_stat': 'Total',
      'pending_orders': 'Pending',
      'completed_stat': 'Completed',
      'driver_stats': 'Driver Statistics',
      'total_drivers': 'Total Drivers',
      'completion_rate': 'Completion Rate',
      'monthly_stats': 'Monthly Orders & Revenue Statistics',
      'revenue_thousands': 'Revenue (thousands)',
      'revenue_tooltip': 'Revenue',
      'orders_tooltip': 'Orders',

      // Notifications
      'notifications': 'Notifications',
      'order_notifications': 'Orders',
      'messages_and_ratings': 'Messages & Ratings',
      'no_order_notifications': 'No order notifications',
      'no_messages_or_ratings': 'No messages or ratings',
      'new_notifications_appear_here': 'New notifications will appear here',
      'order_hash_prefix': 'Order #',

      // Profile
      'facility_data': 'Facility Data',
      'company_identifier': 'Company Identifier',
      'contact_number': 'Contact Number',
      'account_manager': 'Account Manager',
      'full_name': 'Full Name',
      'terms_and_policies': 'Terms & Policies',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to logout?',
      'logout_btn': 'Logout',
      'verified': 'Verified',
      'under_review': 'Under Review',
      'retry_btn': 'Retry',
      'language': 'Language',

      // Support
      'support_title': 'Technical Support',
      'type_your_message': 'Type your message...',
      'failed_to_send_message': 'Failed to send message',
      'today': 'Today',
      'yesterday': 'Yesterday',

      // Shared Pages
      'terms_and_conditions': 'Terms & Conditions',
      'privacy_policy_title': 'Privacy Policy',

      // Order Management Screen
      'order_management': 'Order Management',
      'manage_orders': 'Manage Orders',
      'view_and_manage_orders': 'View and manage all orders',
      'view_and_manage_containers': 'View and manage all containers',
      'view_and_manage_drivers': 'View and manage all drivers',

      // Driver Assignment
      'select_driver': 'Select Driver',
      'no_drivers_available': 'No drivers available',
      'driver_assigned_success': 'Driver assigned successfully',
      'driver_assign_failed': 'Failed to assign driver',

      // Status Labels
      'status_pending_offers': 'Pending Offers',
      'status_accepted': 'Accepted',
      'status_in_progress': 'In Progress',
      'status_completed': 'Completed',
      'status_cancelled': 'Cancelled',
      'status_scheduled': 'Scheduled',
      'status_picked_up': 'Picked Up',

      // Rental Type Labels
      'rental_once': 'One-time',
      'rental_monthly': 'Monthly',
      'rental_annual': 'Annual',
    },

    // ═══════════════ URDU ═══════════════
    'ur': {
      // Main Layout
      'app_name': 'حاویتکم',
      'technical_support': 'تکنیکی مدد',
      'profile': 'پروفائل',
      'dashboard': 'ڈیش بورڈ',
      'orders': 'آرڈرز',
      'drivers': 'ڈرائیورز',
      'containers': 'کنٹینرز',

      // Landing Screen
      'manage_containers_easily': 'کنٹینرز اور آرڈرز کو آسانی سے منظم کریں',
      'sign_in': 'سائن ان',
      'create_new_account': 'نیا اکاؤنٹ بنائیں',

      // Sign In
      'sign_in_title': 'سائن ان',
      'welcome_back': 'خوش آمدید واپسی',
      'saved_account': 'محفوظ اکاؤنٹ',
      'use_another_account': 'دوسرا اکاؤنٹ استعمال کریں',
      'company_id_label': 'کمپنی شناختی نمبر',
      'company_id_hint': '0123456789',
      'please_enter_company_id': 'براہ کرم کمپنی شناختی نمبر درج کریں',
      'admin_email_label': 'ایڈمن ای میل',
      'enter_email': 'ای میل درج کریں',
      'please_enter_email': 'براہ کرم ای میل درج کریں',
      'please_enter_valid_email': 'براہ کرم درست ای میل درج کریں',
      'admin_password_label': 'ایڈمن پاسورڈ',
      'enter_password': 'پاسورڈ درج کریں',
      'please_enter_password': 'براہ کرم پاسورڈ درج کریں',
      'save_login_info': 'لاگ ان معلومات محفوظ کریں',
      'i_agree_to': 'میں متفق ہوں ',
      'terms_of_service': 'سروس کی شرائط',
      'and': ' اور ',
      'privacy_policy': 'پرائیویسی پالیسی',
      'must_agree_to_terms': 'آپ کو سروس کی شرائط اور پرائیویسی پالیسی سے متفق ہونا ضروری ہے',
      'no_account_yet': 'اکاؤنٹ نہیں ہے؟ ',
      'create_new_account_link': 'نیا اکاؤنٹ بنائیں',
      'permanent_ban': 'مستقل پابندی',
      'temporary_ban': 'عارضی پابندی',
      'ban_reason': 'پابندی کی وجہ:',

      // Sign Up
      'sign_up_title': 'نیا اکاؤنٹ بنائیں',
      'step1_company_data': 'مرحلہ 1: کمپنی ڈیٹا',
      'company_name': 'کمپنی کا نام',
      'enter_company_name': 'کمپنی کا نام درج کریں',
      'required': 'ضروری ہے',
      'commercial_reg_number': 'تجارتی رجسٹریشن نمبر',
      'must_be_10_digits': '10 ہندسے ہونے چاہئیں',
      'tax_number': 'ٹیکس نمبر',
      'enter_tax_number': 'ٹیکس نمبر درج کریں',
      'company_phone': 'کمپنی فون',
      'phone_number_too_short': 'فون نمبر بہت چھوٹا ہے',
      'region_and_city': 'علاقہ اور شہر',
      'region': 'علاقہ',
      'city': 'شہر',
      'please_select_region': 'براہ کرم علاقہ منتخب کریں',
      'please_select_city': 'براہ کرم شہر منتخب کریں',
      'company_logo': 'کمپنی لوگو',
      'select_company_logo': 'کمپنی لوگو منتخب کریں',
      'logo_selected': 'لوگو منتخب ہوگیا',
      'image_size_limit': 'تصویر کا سائز 2 ایم بی سے کم ہونا چاہیے',
      'company_location': 'کمپنی مقام',
      'my_current_location': 'میرا موجودہ مقام',
      'latitude': 'عرض البلد',
      'longitude': 'طول البلد',
      'invalid_value': 'غلط قدر',
      'bank_info': 'بینک معلومات',
      'bank_name': 'بینک کا نام',
      'enter_bank_name': 'بینک کا نام درج کریں',
      'bank_account_number': 'بینک اکاؤنٹ نمبر',
      'enter_account_number': 'اکاؤنٹ نمبر درج کریں',
      'iban_number': 'آئی بی اے این نمبر',
      'account_holder_name': 'اکاؤنٹ ہولڈر کا نام',
      'enter_account_holder_name': 'اکاؤنٹ ہولڈر کا نام درج کریں',
      'admin_account': 'ایڈمن اکاؤنٹ',
      'email': 'ای میل',
      'password': 'پاسورڈ',
      'confirm_password': 'پاسورڈ کی تصدیق',
      're_enter_password': 'پاسورڈ دوبارہ درج کریں',
      'passwords_do_not_match': 'پاسورڈ مماثل نہیں ہیں',
      'must_be_6_chars': 'کم از کم 6 حروف ہونے چاہئیں',
      'invalid_email': 'غلط ای میل',
      'send_verification_code': 'تصدیقی کوڈ بھیجیں',
      'already_have_account': 'پہلے سے اکاؤنٹ ہے؟ ',
      'failed_load_data': 'ڈیٹا لوڈ ہونے میں ناکامی',
      'please_enable_location': 'براہ کرم سیٹنگز سے لوکیشن سروس فعال کریں',
      'location_permission_denied': 'لوکیشن کی اجازت مسترد ہوگئی',
      'location_permission_required': 'لوکیشن کی اجازت ضروری ہے',
      'allow_location_access': 'براہ کرم ایپ سیٹنگز سے لوکیشن تک رسائی کی اجازت دیں',
      'cancel': 'منسوخ',
      'open_settings': 'سیٹنگز کھولیں',
      'location_set_success': 'مقام کامیابی سے سیٹ ہوگیا',
      'failed_get_location': 'مقام حاصل کرنے میں ناکامی',
      'please_select_logo': 'براہ کرم کمپنی لوگو منتخب کریں',
      'please_select_city_msg': 'براہ کرم شہر منتخب کریں',

      // Verification
      'email_verification': 'ای میل تصدیق',
      'step2_verification_code': 'مرحلہ 2: اپنے ای میل پر بھیجا گیا تصدیقی کوڈ درج کریں',
      'verification_code': 'تصدیقی کوڈ',
      'confirm_registration': 'رجسٹریشن کی تصدیق',

      // Pending
      'request_sent_success': 'درخواست کامیابی سے بھیج دی گئی!',
      'request_under_review': 'آپ کی درخواست زیر جائزہ ہے۔ منظوری کے بعد آپ کو 10 ہندسوں کا ID نمبر ای میل پر ملے گا۔',
      'back_to_sign_in': 'سائن ان پر واپسی',

      // Orders - Main Tabs
      'new_orders': 'نئے',
      'accepted_orders': 'قبول شدہ',
      'sub_orders': 'ذیلی',
      'completed_orders': 'مکمل',
      'cancelled_orders': 'منسوخ',

      // Pending Orders
      'available_orders': 'دستیاب آرڈرز',
      'retry': 'دوبارہ کوشش',
      'no_available_orders_now': 'فی الحال کوئی دستیاب آرڈر نہیں',
      'filter_orders': 'آرڈرز فلٹر کریں',
      'container_type': 'کنٹینر کی قسم',
      'size': 'سائز',
      'all': 'سب',
      'reset': 'ری سیٹ',
      'apply': 'لاگو کریں',
      'sort_by_distance': 'فاصلے کے مطابق ترتیب',
      'sort_by_date': 'تاریخ کے مطابق ترتیب',
      'sort_by_type': 'قسم کے مطابق ترتیب',
      'rental_type': 'کرائے کی قسم',
      'delivery_date': 'ترسیل کی تاریخ',
      'address': 'پتہ',
      'unspecified': 'غیر متعین',
      'distance': 'فاصلہ',
      'customer': 'صارف',
      'phone': 'فون',
      'submit_offer': 'پیشکش جمع کرائیں',
      'offer_submitted': 'پیشکش جمع ہوئی',
      'offer_submitted_for_order': 'اس آرڈر کے لیے پیشکش جمع ہو چکی ہے',
      'km': 'کلومیٹر',

      // Accepted Orders
      'without_driver': 'ڈرائیور کے بغیر',
      'with_driver': 'ڈرائیور کے ساتھ',
      'all_orders_have_drivers': 'تمام آرڈرز کے ڈرائیور مقرر ہیں',
      'no_orders_with_drivers': 'ڈرائیور والے کوئی آرڈرز نہیں',
      'assign_driver': 'ڈرائیور مقرر کریں',
      'container_number': 'کنٹینر نمبر',
      'license_label': 'لائسنس',
      'vehicle_label': 'گاڑی',
      'tracking_coming_soon': 'ٹریکنگ کی سہولت جلد آرہی ہے',
      'track': 'ٹریک',
      'order_prefix': 'آرڈر',

      // Sub Orders
      'sub_orders_title': 'ذیلی آرڈرز',
      'unload': 'ان لوڈ 🗑️',
      'return_order': 'واپسی ↩️',
      'no_unload_orders': 'ان لوڈ آرڈرز نہیں ہیں',
      'no_return_orders': 'واپسی آرڈرز نہیں ہیں',
      'change_driver': 'ڈرائیور تبدیل کریں',
      'delivery_date_label': 'ترسیل کی تاریخ',
      'assign': 'تفویض',

      // Completed Orders
      'no_completed_orders': 'مکمل آرڈرز نہیں ہیں',
      'no_filters_available': 'فلٹرز دستیاب نہیں ہیں',
      'showing_x_of_y': 'دکھا رہا ہے',
      'of_word': 'میں سے',
      'order_word': 'آرڈر',
      'city_label': 'شہر',

      // Cancelled Orders
      'no_cancelled_orders': 'منسوخ آرڈرز نہیں ہیں',
      'cancelled': 'منسوخ',
      'cancellation_date': 'منسوخی کی تاریخ',
      'cancellation_reason': 'منسوخی کی وجہ',

      // Order Details Modal
      'status': 'حالت',
      'completion_date': 'تکمیل کی تاریخ',
      'total_price': 'کل قیمت',
      'total_label': 'کل:',
      'sar': 'ریال',
      'assigned_driver': 'مقررہ ڈرائیور',
      'driver_name': 'نام',
      'license_number': 'لائسنس نمبر',

      // Submit Offer Dialog
      'submit_offer_title': 'پیشکش جمع کرائیں',
      'delivery': 'ترسیل',
      'base_price_sar': 'بنیادی قیمت (ریال)',
      'please_enter_price': 'براہ کرم قیمت درج کریں',
      'please_enter_valid_price': 'براہ کرم درست قیمت درج کریں',
      'rental_duration_days': 'کرائے کی مدت (دن)',
      'required_for_once': '"ایک بار" قسم کے لیے ضروری',
      'please_enter_duration': 'براہ کرم کرائے کی مدت درج کریں',
      'duration_range': 'مدت 1 سے 365 دن کے درمیان ہونی چاہیے',
      'submit_offer_btn': 'پیشکش جمع کرائیں',
      'offer_submitted_success': '✅ پیشکش کامیابی سے جمع ہوگئی',
      'offer_submit_failed': 'پیشکش جمع کرانے میں ناکامی',
      'server_error': 'سرور میں خرابی۔ بعد میں دوبارہ کوشش کریں',
      'invalid_data': 'غلط ڈیٹا۔ اپنے ان پٹ چیک کریں',
      'unload_operations': 'ان لوڈ آپریشن',

      // Drivers
      'manage_drivers': 'ڈرائیورز کا انتظام',
      'no_drivers': 'کوئی ڈرائیور نہیں',
      'no_drivers_desc': 'ابھی تک کوئی ڈرائیور شامل نہیں کیا گیا۔ اپنی ڈرائیور ٹیم کے انتظام کے لیے نیا ڈرائیور شامل کریں۔',
      'about_driver': 'ڈرائیور کے بارے میں',
      'identity_number': 'شناختی نمبر',
      'not_available': 'دستیاب نہیں',
      'statistics': 'اعداد و شمار',
      'current_orders': 'موجودہ آرڈرز',
      'completed_orders_stat': 'مکمل آرڈرز',
      'total_orders': 'کل آرڈرز',
      'driver_orders': 'ڈرائیور کے آرڈرز',
      'no_orders_for_driver': 'اس ڈرائیور کو کوئی آرڈر تفویض نہیں',
      'error_loading_driver_data': 'ڈرائیور ڈیٹا لوڈ کرنے میں خرابی',
      'driver_not_found': 'ڈرائیور ڈیٹا نہیں ملا',
      'order_type': 'آرڈر کی قسم',
      'edit': 'ترمیم',
      'delete': 'حذف',
      'type': 'قسم',

      // Add Driver
      'add_new_driver': 'نیا ڈرائیور شامل کریں',
      'driver_info': 'ڈرائیور معلومات',
      'driver_name_label': 'ڈرائیور کا نام',
      'enter_full_name': 'پورا نام درج کریں',
      'name_required': 'نام ضروری ہے',
      'name_min_length': 'نام کم از کم 2 حروف کا ہونا چاہیے',
      'phone_number': 'فون نمبر',
      'phone_required': 'فون نمبر ضروری ہے',
      'identity_number_label': 'شناختی نمبر',
      'identity_min_length': 'شناختی نمبر کم از کم 5 ہندسے ہونے چاہئیں',
      'driver_status': 'ڈرائیور کی حالت',
      'select_driver_status': 'ڈرائیور کی حالت منتخب کریں',
      'available': 'دستیاب',
      'on_duty': 'ڈیوٹی پر',
      'off_duty': 'ڈیوٹی سے باہر',
      'on_break': 'بریک پر',
      'email_optional': 'ای میل (اختیاری)',
      'email_invalid': 'غلط ای میل',
      'password_required': 'پاسورڈ ضروری ہے',
      'password_min_length': 'پاسورڈ کم از کم 6 حروف کا ہونا چاہیے',
      'confirm_password_required': 'پاسورڈ کی تصدیق ضروری ہے',
      'add_driver': 'ڈرائیور شامل کریں',
      'driver_added_success': 'ڈرائیور کامیابی سے شامل ہوگیا',
      'please_select_driver_status': 'براہ کرم ڈرائیور کی حالت منتخب کریں',

      // Edit Driver
      'edit_driver_data': 'ڈرائیور ڈیٹا میں ترمیم',
      'update_data': 'ڈیٹا اپ ڈیٹ',
      'driver_updated_success': 'ڈرائیور ڈیٹا کامیابی سے اپ ڈیٹ ہوگیا',
      'new_password_optional': 'نیا پاسورڈ (تبدیل نہ کرنا ہو تو خالی چھوڑیں)',

      // Delete Driver
      'confirm_delete_driver': 'ڈرائیور حذف کرنے کی تصدیق',
      'confirm_delete_driver_msg': 'کیا آپ واقعی اس ڈرائیور کو حذف کرنا چاہتے ہیں: ',
      'cannot_undo': 'یہ عمل واپس نہیں ہو سکتا۔',
      'driver_deleted_success': 'ڈرائیور کامیابی سے حذف ہوگیا',
      'driver_delete_failed': 'ڈرائیور حذف کرنے میں ناکامی',

      // Containers
      'manage_containers': 'کنٹینرز کا انتظام',
      'no_containers': 'کوئی کنٹینر نہیں',
      'add_container': 'کنٹینر شامل کریں',
      'total': 'کل',
      'rented': 'کرائے پر',
      'maintenance': 'دیکھ بھال',

      // Add Container
      'add_new_container': 'نیا کنٹینر شامل کریں',
      'container_type_required': 'کنٹینر کی قسم *',
      'select_container_type': 'کنٹینر کی قسم منتخب کریں',
      'container_size': 'کنٹینر سائز *',
      'select_container_size': 'کنٹینر سائز منتخب کریں',
      'error_loading_types': 'اقسام لوڈ کرنے میں خرابی',
      'container_count': 'کنٹینرز کی تعداد *',
      'container_status': 'کنٹینر کی حالت',
      'available_for_rent': 'کرائے کے لیے دستیاب',
      'add_container_btn': 'کنٹینر شامل کریں',
      'will_add_containers': 'اسی قسم اور سائز کے {qty} کنٹینر شامل کیے جائیں گے',

      // Delete Containers
      'delete_containers': 'کنٹینرز حذف کریں',
      'type_label': 'قسم',
      'size_label': 'سائز',
      'available_for_deletion': 'حذف کے لیے دستیاب کنٹینرز',
      'no_containers_available_for_deletion': 'حذف کے لیے دستیاب کنٹینرز نہیں۔ تمام کنٹینرز کرائے پر ہیں یا دیکھ بھال میں۔',
      'how_many_to_delete': 'کتنے کنٹینرز حذف کرنا چاہتے ہیں؟',
      'max_limit': 'زیادہ سے زیادہ',
      'important_warning': 'اہم انتباہ',
      'only_available_deleted': '• صرف دستیاب (غیر کرائے والے) کنٹینرز حذف ہوں گے',
      'cannot_undo_action': '• یہ عمل واپس نہیں ہو سکتا',
      'containers_deleted_success': 'کنٹینرز کامیابی سے حذف ہوگئے!',

      // Edit Container Status
      'manage_containers_sheet': 'کنٹینرز کا انتظام',
      'selected_x_of_y': 'منتخب',
      'container_word': 'کنٹینر',
      'select_all': 'سب منتخب کریں',
      'deselect_all': 'منسوخ',
      'select_new_status': 'نئی حالت منتخب کریں',
      'change_status': 'حالت تبدیل کریں',

      // Dashboard
      'dashboard_title': 'ڈیش بورڈ',
      'error_loading_data': 'ڈیٹا لوڈ کرنے میں خرابی',
      'container_stats': 'کنٹینر اعداد و شمار',
      'total_containers': 'کل',
      'rented_containers': 'کرائے پر',
      'available_containers': 'دستیاب',
      'order_stats': 'آرڈر اعداد و شمار',
      'total_orders_stat': 'کل',
      'pending_orders': 'زیر کارروائی',
      'completed_stat': 'مکمل',
      'driver_stats': 'ڈرائیور اعداد و شمار',
      'total_drivers': 'کل ڈرائیورز',
      'completion_rate': 'تکمیل کی شرح',
      'monthly_stats': 'ماہانہ آرڈرز اور آمدنی کے اعداد و شمار',
      'revenue_thousands': 'آمدنی (ہزاروں میں)',
      'revenue_tooltip': 'آمدنی',
      'orders_tooltip': 'آرڈرز',

      // Notifications
      'notifications': 'اطلاعات',
      'order_notifications': 'آرڈرز',
      'messages_and_ratings': 'پیغامات اور درجہ بندی',
      'no_order_notifications': 'آرڈر اطلاعات نہیں ہیں',
      'no_messages_or_ratings': 'پیغامات یا درجہ بندی نہیں ہیں',
      'new_notifications_appear_here': 'نئی اطلاعات یہاں ظاہر ہوں گی',
      'order_hash_prefix': 'آرڈر #',

      // Profile
      'facility_data': 'ادارے کی معلومات',
      'company_identifier': 'کمپنی شناخت',
      'contact_number': 'رابطہ نمبر',
      'account_manager': 'اکاؤنٹ منیجر',
      'full_name': 'پورا نام',
      'terms_and_policies': 'شرائط اور پالیسیاں',
      'logout': 'لاگ آؤٹ',
      'logout_confirm': 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟',
      'logout_btn': 'لاگ آؤٹ',
      'verified': 'تصدیق شدہ',
      'under_review': 'زیر جائزہ',
      'retry_btn': 'دوبارہ کوشش',
      'language': 'زبان',

      // Support
      'support_title': 'تکنیکی مدد',
      'type_your_message': 'اپنا پیغام لکھیں...',
      'failed_to_send_message': 'پیغام بھیجنے میں ناکامی',
      'today': 'آج',
      'yesterday': 'کل',

      // Shared
      'terms_and_conditions': 'شرائط و ضوابط',
      'privacy_policy_title': 'پرائیویسی پالیسی',

      // Order Management
      'order_management': 'آرڈرز کا انتظام',
      'manage_orders': 'آرڈرز کا انتظام',
      'view_and_manage_orders': 'تمام آرڈرز دیکھیں اور منظم کریں',
      'view_and_manage_containers': 'تمام کنٹینرز دیکھیں اور منظم کریں',
      'view_and_manage_drivers': 'تمام ڈرائیورز دیکھیں اور منظم کریں',

      // Driver Assignment
      'select_driver': 'ڈرائیور منتخب کریں',
      'no_drivers_available': 'کوئی ڈرائیور دستیاب نہیں',
      'driver_assigned_success': 'ڈرائیور کامیابی سے مقرر ہوگیا',
      'driver_assign_failed': 'ڈرائیور مقرر کرنے میں ناکامی',

      // Status
      'status_pending_offers': 'پیشکشوں کا انتظار',
      'status_accepted': 'قبول',
      'status_in_progress': 'جاری ہے',
      'status_completed': 'مکمل',
      'status_cancelled': 'منسوخ',
      'status_scheduled': 'شیڈول',
      'status_picked_up': 'وصول ہوگیا',

      // Rental Types
      'rental_once': 'ایک بار',
      'rental_monthly': 'ماہانہ',
      'rental_annual': 'سالانہ',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en', 'ur'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
