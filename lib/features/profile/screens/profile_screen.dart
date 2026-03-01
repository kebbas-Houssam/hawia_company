import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/api_config.dart';
import '../../../core/config/app_theme.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/utils/app_localizations.dart';
import '../../../shared/privacy_policy_page.dart';
import '../../../shared/terms_and_conditions_page.dart';
import '../providers/profile_providers.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        title: Text(
          loc.profileTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => _ErrorState(
              message: error.toString().replaceAll('Exception: ', ''),
              onRetry: () => ref.refresh(profileProvider),
              retryLabel: loc.retryBtn,
            ),
        data:
            (profile) => RefreshIndicator(
              onRefresh: () => ref.refresh(profileProvider.future),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // ───────────── Simple Header ─────────────
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.grey.shade50,
                              backgroundImage: NetworkImage(
                                '${ApiConfig.baseUrl}${profile.company.logoUrl}',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            profile.company.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _StatusBadge(status: profile.company.status),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ───────────── Info Sections ─────────────
                    _buildSectionTitle(loc.facilityData),
                    _InfoCard(
                      children: [
                        _InfoRow(
                          icon:
                              Icons
                                  .fingerprint_rounded, // Better icon for identifier
                          label: loc.companyIdentifier,
                          value: profile.company.domain,
                        ),
                        _Divider(),
                        _InfoRow(
                          icon: Icons.phone_android_rounded,
                          label: loc.contactNumber,
                          value: profile.company.companyPhoneNumber ?? loc.notAvailable,
                        ),
                        _Divider(),
                        _InfoRow(
                          icon: Icons.location_city_rounded,
                          label: loc.city,
                          value: profile.company.cityName ?? loc.notAvailable,
                        ),
                      ],
                    ),

                    _buildSectionTitle(loc.accountManager),
                    _InfoCard(
                      children: [
                        _InfoRow(
                          icon: Icons.person_outline_rounded,
                          label: loc.fullName,
                          value: profile.adminUser.name,
                        ),
                        _Divider(),
                        _InfoRow(
                          icon: Icons.alternate_email_rounded,
                          label: loc.email,
                          value: profile.adminUser.email,
                        ),
                      ],
                    ),

                    // ───────────── Language Switcher ─────────────
                    _buildSectionTitle(loc.language),
                    _LanguageSwitcher(),

                    _buildSectionTitle(loc.termsAndPolicies),
                    _InfoCard(
                      children: [
                        _ClickableInfoRow(
                          icon: Icons.description_outlined,
                          label: loc.termsOfService,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TermsAndConditionsPage(),
                              ),
                            );
                          },
                        ),
                        _Divider(),
                        _ClickableInfoRow(
                          icon: Icons.privacy_tip_outlined,
                          label: loc.privacyPolicy,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PrivacyPolicyPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showLogoutDialog(context, ref),
                          icon: const Icon(Icons.logout_rounded, size: 20),
                          label: Text(
                            loc.logout,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(loc.logout, textAlign: TextAlign.right),
            content: Text(
              loc.logoutConfirm,
              textAlign: TextAlign.right,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.cancel),
              ),
              TextButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  Navigator.pop(context);
                },
                child: Text(loc.logoutBtn, style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}

// ─────────────────────────────────────────────
// UI Components
// ─────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final color = status == 'approved' ? Colors.teal : Colors.orange;
    final text = status == 'approved' ? loc.verified : loc.underReview;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade400),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClickableInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ClickableInfoRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.grey.shade50, thickness: 1);
  }
}

class _LanguageSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);
    final currentLang = currentLocale.languageCode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _LanguageOption(
            flag: '🇸🇦',
            label: 'العربية',
            isSelected: currentLang == 'ar',
            onTap: () => ref.read(languageProvider.notifier).setLanguage('ar'),
          ),
          const SizedBox(width: 8),
          _LanguageOption(
            flag: '🇬🇧',
            label: 'English',
            isSelected: currentLang == 'en',
            onTap: () => ref.read(languageProvider.notifier).setLanguage('en'),
          ),
          const SizedBox(width: 8),
          _LanguageOption(
            flag: '🇵🇰',
            label: 'اردو',
            isSelected: currentLang == 'ur',
            onTap: () => ref.read(languageProvider.notifier).setLanguage('ur'),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(flag, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primary : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String retryLabel;
  const _ErrorState({required this.message, required this.onRetry, this.retryLabel = 'إعادة المحاولة'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.grey)),
          TextButton(onPressed: onRetry, child: Text(retryLabel)),
        ],
      ),
    );
  }
}
