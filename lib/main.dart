import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/config/app_theme.dart';
import 'core/services/api_service.dart';
import 'features/notifications/services/fcm_service.dart';
import 'features/notifications/services/websocket_service.dart';
import 'features/notifications/services/notification_api_service.dart';
import 'features/notifications/providers/notification_providers.dart';
import 'features/orders/providers/orders_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/models/auth_state.dart';
import 'core/services/storage_service.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase only if not already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  debugPrint('📲 Background notification received');
  debugPrint('   Title: ${message.notification?.title ?? message.data['title']}');
  debugPrint('   Data: ${message.data}');
  
  // Show notification even in background (server sends data-only messages)
  await FCMService().showLocalNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  debugPrint('\n🚀 ===== APP STARTING =====');
  
  // Initialize Firebase only if not already initialized
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('✅ Firebase initialized');
    } else {
      debugPrint('✅ Firebase already initialized (${Firebase.apps.length} app(s))');
    }
  } catch (e) {
    debugPrint('⚠️ Firebase initialization error (may already be initialized): $e');
  }
  
  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  // ⚠️ CRITICAL: Set up FCM token callback BEFORE initializing FCM
  debugPrint('🔧 Setting up FCM token callback BEFORE initialization...');
  FCMService().onTokenReceived = (token) async {
    debugPrint('\n🎯 ===== FCM TOKEN CALLBACK TRIGGERED =====');
    debugPrint('   Token (first 30 chars): ${token.substring(0, 30)}...');
    debugPrint('   Timestamp: ${DateTime.now()}');
    
    // Store token for later use
    final storedAuthToken = await StorageService.getToken();
    if (storedAuthToken != null) {
      debugPrint('   ✅ User is authenticated, sending to backend...');
      try {
        // Note: We can't use Riverpod ref here since we're in main()
        // The token will be sent again on login from auth_provider
        debugPrint('   ℹ️  Token stored, will be sent on login');
      } catch (e) {
        debugPrint('   ❌ Error: $e');
      }
    } else {
      debugPrint('   ⏳ User not authenticated yet, token will be sent on login');
    }
    debugPrint('===== END TOKEN CALLBACK =====\n');
  };
  debugPrint('✅ FCM token callback registered');
  
  // Initialize FCM Service (will now trigger callback if token is generated)
  debugPrint('🔧 Initializing FCM Service...');
  await FCMService().initialize();
  debugPrint('✅ FCM Service initialized');
  
  // Initialize WebSocket if user is logged in
  final token = await StorageService.getToken();
  if (token != null) {
    try {
      await WebsocketService.instance.connect(token);
    } catch (e) {
      debugPrint('❌ Failed to connect WebSocket on app start: $e');
    }
  }
  
  debugPrint('🚀 Starting app widget tree...\n');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    
    // Add lifecycle observer to detect when app comes to foreground
    WidgetsBinding.instance.addObserver(this);
    
    debugPrint('🎨 MyApp widget initialized');
    
    // ⚠️ CRITICAL: Connect FCM callbacks to refresh providers when notifications arrive
    FCMService().onNotificationReceived = () {
      debugPrint('🔄 FCM callback: Refreshing notification list...');
      ref.read(adminNotificationsProvider.notifier).loadNotifications();
    };
    
    FCMService().onIncrementBadge = () {
      debugPrint('🔄 FCM callback: Refreshing unread count...');
      ref.read(unreadCountProvider.notifier).refresh();
    };
    
    // Token callback is already set in main() before FCM initialization
    // We'll add another callback here for when user logs in
    final existingTokenCallback = FCMService().onTokenReceived;
    FCMService().onTokenReceived = (token) async {
      debugPrint('\n🎯 [Widget] FCM token callback triggered');
      // Call the original callback from main()
      if (existingTokenCallback != null) {
        await existingTokenCallback(token);
      }
      
      // Send to backend if user is authenticated
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated) {
        debugPrint('   [Widget] User is authenticated, sending token to backend...');
        try {
          final notificationApi = NotificationApiService(ref.read(apiServiceProvider));
          await notificationApi.updateFcmToken(token);
        } catch (e) {
          debugPrint('   ❌ [Widget] Failed to send token: $e');
        }
      } else {
        debugPrint('   [Widget] User not authenticated yet');
      }
    };
    
    // ⚠️ CRITICAL: If token already exists and user is authenticated, send it now!
    // This handles the case where user is already logged in on app start
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('\n🔍 [Post-Frame] Checking if FCM token needs to be sent...');
      
      // Wait a bit for auth state to load from storage
      await Future.delayed(const Duration(milliseconds: 500));
      
      final authState = ref.read(authProvider);
      final fcmToken = FCMService().fcmToken;
      
      debugPrint('   Auth check: isAuthenticated=${authState.isAuthenticated}');
      debugPrint('   Token check: ${fcmToken != null ? "exists (${fcmToken.substring(0, 30)}...)" : "NULL"}');
      
      if (authState.isAuthenticated && fcmToken != null) {
        debugPrint('   ✅ User is authenticated AND token exists');
        debugPrint('   📤 Sending FCM token to backend NOW...');
        try {
          final notificationApi = NotificationApiService(ref.read(apiServiceProvider));
          await notificationApi.updateFcmToken(fcmToken);
          debugPrint('   ✅ SUCCESS: Token sent to backend!');
        } catch (e) {
          debugPrint('   ❌ FAILED to send token: $e');
        }
      } else {
        debugPrint('   ℹ️  Not sending now - will be sent on next login or token refresh');
      }
      debugPrint('===== POST-FRAME CHECK COMPLETE =====\n');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      debugPrint('\n🔄 App resumed - refreshing data...');
      
      // Refresh unread count when app comes to foreground
      // This handles background notifications
      try {
        ref.read(unreadCountProvider.notifier).refresh();
        debugPrint('   ✅ Badge count refreshed');
      } catch (e) {
        debugPrint('   ❌ Failed to refresh badge: $e');
      }
      
      // Refresh pending orders (critical for companies)
      try {
        ref.read(pendingOrdersProvider.notifier).fetchOrders();
        debugPrint('   ✅ Pending orders refreshed');
      } catch (e) {
        debugPrint('   ❌ Failed to refresh pending orders: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    
    // Watch providers to ensure they initialize when authenticated
    ref.watch(adminNotificationsProvider);
    ref.watch(unreadCountProvider);

    return MaterialApp.router(
      title: 'حاويتكم',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // RTL Support
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('ar', 'SA'), // Arabic
        Locale('en', 'US'), // English
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
