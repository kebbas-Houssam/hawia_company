import 'package:flutter/material.dart';
import '../../../core/config/app_theme.dart';
import '../../../core/utils/app_localizations.dart';

class ContainersScreen extends StatelessWidget {
  const ContainersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).manageContainers,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context).viewAndManageContainers,
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
