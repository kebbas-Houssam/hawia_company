import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/app_theme.dart';
import '../utils/app_localizations.dart';
import '../../shared/widgets/notification_icon_button.dart';


class MainLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/orders');
        break;
      case 2:
        context.go('/drivers');
        break;
      case 3:
        context.go('/containers');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.appName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: NotificationIconButton(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent),
            onPressed: () => context.push('/support'),
            tooltip: loc.technicalSupport,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
            tooltip: loc.profile,
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.iconSecondary,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_rounded),
            label: loc.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_rounded),
            label: loc.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_shipping_rounded),
            label: loc.drivers,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory_2_rounded),
            label: loc.containers,
          ),
        ],
      ),
    );
  }
}
