import 'package:flutter/material.dart';
import '../../../core/config/app_theme.dart';
import '../../../core/utils/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).manageOrders,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context).viewAndManageOrders,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
