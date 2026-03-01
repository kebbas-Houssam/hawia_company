import 'package:flutter/material.dart';
import '../core/config/app_theme.dart';
import '../core/utils/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary, // Modern grey background
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).privacyPolicyTitle,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Branding Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.shield_outlined, size: 50, color: AppColors.white),
                  SizedBox(height: 15),
                  Text(
                    'سياسة الخصوصية وحماية البيانات',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'نحن في "حاويتكم" نلتزم بحماية خصوصيتك وبياناتك الشخصية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('التزامنا بالخصوصية'),
                    _buildParagraph(
                      'تلتزم منصة "حاويتكم" بحماية خصوصية بيانات العملاء وفقًا للأنظمة السعودية ذات العلاقة، بما في ذلك نظام حماية البيانات الشخصية ونظام التجارة الإلكترونية. نحن نؤمن بأن خصوصيتك حق أساسي، ونعمل على ضمان حماية معلوماتك بأعلى معايير الأمان.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('البيانات التي نجمعها'),

                    _buildSubSection('📋 البيانات الأساسية'),
                    _buildParagraph(
                      'يتم جمع المعلومات اللازمة فقط لتقديم الخدمة بشكل فعال:',
                    ),
                    _buildBulletPoint('الاسم الكامل'),
                    _buildBulletPoint('رقم الهوية الوطنية أو السجل التجاري'),
                    _buildBulletPoint('رقم الجوال'),
                    _buildBulletPoint('العنوان الوطني وتفاصيل الموقع'),
                    _buildBulletPoint('البريد الإلكتروني (إن وجد)'),

                    const SizedBox(height: 12),
                    _buildSubSection('💳 بيانات الدفع'),
                    _buildParagraph(
                      'نستخدم بوابات دفع إلكترونية معتمدة ومؤمنة. المنصة لا تحتفظ ببيانات البطاقات المصرفية أو أرقام الحسابات، حيث يتم معالجة جميع المعاملات المالية من خلال مزودي خدمة الدفع المعتمدين وفقًا لأعلى معايير الأمان.',
                    ),

                    const SizedBox(height: 12),
                    _buildSubSection('📱 البيانات التقنية'),
                    _buildBulletPoint('عنوان IP'),
                    _buildBulletPoint('نوع الجهاز ونظام التشغيل'),
                    _buildBulletPoint(
                      'بيانات تصفح التطبيق (لتحسين تجربة المستخدم)',
                    ),
                    _buildBulletPoint('الموقع الجغرافي (بموافقتك)'),

                    const Divider(height: 32),

                    _buildSectionHeader('كيف نستخدم بياناتك'),
                    _buildInfoBox(
                      '🎯',
                      'تقديم الخدمة',
                      'معالجة طلبات التأجير وتنسيق التوصيل والتواصل معك',
                    ),
                    _buildInfoBox(
                      '📊',
                      'تحسين الخدمة',
                      'تحليل الأداء وتطوير المنصة وتحسين تجربة المستخدم',
                    ),
                    _buildInfoBox(
                      '🔔',
                      'الإشعارات',
                      'إرسال تحديثات الطلب والعروض والإشعارات المهمة',
                    ),
                    _buildInfoBox(
                      '⚖️',
                      'الامتثال القانوني',
                      'الالتزام بالأنظمة والتعليمات الحكومية',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('مشاركة البيانات'),
                    _buildHighlightBox('نحن لا نبيع بياناتك أبدًا!'),
                    _buildParagraph(
                      'نلتزم بعدم بيع أو مشاركة بياناتك الشخصية مع أي طرف ثالث لأغراض تجارية أو تسويقية دون موافقتك الصريحة.',
                    ),

                    _buildSubSection('✅ مشاركة محدودة وضرورية'),
                    _buildParagraph('قد نشارك بياناتك فقط مع:'),
                    _buildBulletPoint('الشركات المؤجرة المعتمدة (لتنفيذ طلبك)'),
                    _buildBulletPoint('مزودي خدمة الدفع الإلكتروني المعتمدين'),
                    _buildBulletPoint(
                      'الجهات الحكومية والأمنية (عند الطلب الرسمي وفق النظام)',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('كيف نحمي بياناتك'),
                    _buildSecurityBox(
                      '🔒',
                      'تشفير قوي',
                      'تشفير SSL/TLS لجميع البيانات',
                    ),
                    _buildSecurityBox(
                      '🛡️',
                      'خوادم آمنة',
                      'استضافة آمنة ومراقبة مستمرة',
                    ),
                    _buildSecurityBox(
                      '👥',
                      'وصول محدود',
                      'فقط الموظفون المصرح لهم',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('حقوقك'),
                    _buildParagraph('لديك الحق في:'),
                    _buildRightBox(
                      '✓',
                      'الوصول إلى بياناتك',
                      'طلب نسخة من بياناتك المخزنة لدينا',
                    ),
                    _buildRightBox(
                      '✓',
                      'تصحيح البيانات',
                      'تحديث أو تصحيح معلوماتك الشخصية',
                    ),
                    _buildRightBox(
                      '✓',
                      'حذف الحساب',
                      'طلب حذف حسابك وبياناتك (مع احتفاظنا بالبيانات الضرورية قانونيًا)',
                    ),
                    _buildRightBox(
                      '✓',
                      'الاعتراض',
                      'رفض استخدام بياناتك لأغراض تسويقية',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('مدة الاحتفاظ بالبيانات'),
                    _buildParagraph(
                      'نحتفظ بياناتك طالما كان حسابك نشطًا أو حسب الحاجة لتقديم الخدمات. بعد حذف الحساب، قد نحتفظ ببعض البيانات لأغراض قانونية أو محاسبية لمدة تصل إلى 5 سنوات وفقًا للأنظمة السعودية.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('ملفات تعريف الارتباط (Cookies)'),
                    _buildParagraph(
                      'نستخدم ملفات تعريف الارتباط لتحسين تجربتك وتذكر تفضيلاتك. يمكنك التحكم في إعدادات الكوكيز من خلال متصفحك، لكن تعطيلها قد يؤثر على بعض وظائف التطبيق.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('تحديثات السياسة'),
                    _buildParagraph(
                      'قد نقوم بتحديث سياسة الخصوصية من وقت لآخر. سيتم إشعارك بأي تغييرات جوهرية عبر التطبيق أو البريد الإلكتروني. الاستمرار في استخدام المنصة بعد التحديثات يعني موافقتك على السياسة المحدثة.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('📞 تواصل معنا'),
                    _buildParagraph(
                      'إذا كان لديك أي أسئلة أو استفسارات حول سياسة الخصوصية أو ترغب في ممارسة حقوقك:',
                    ),
                    const SizedBox(height: 8),
                    _buildContactInfo('شركة الخطوط الأرضية للخدمات اللوجستية'),
                    _buildContactInfo(
                      '📧 البريد الإلكتروني: privacy@hawiyatkom.sa',
                    ),
                    _buildContactInfo('📱 الدعم الفني: عبر التطبيق'),

                    const SizedBox(height: 32),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Styled Helper Widgets ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 25,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.7,
          color: AppColors.textSecondary,
          fontFamily: 'Tajawal',
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: CircleAvatar(radius: 3, backgroundColor: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontFamily: 'Tajawal',
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBox(String icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightBox(String icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightBox(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontFamily: 'Tajawal',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContactInfo(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
      ),
      child: const Column(
        children: [
          Text(
            'شركة الخطوط الأرضية للخدمات اللوجستية',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            'سجل تجاري: 1010641561',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            'آخر تحديث: 28 يناير 2026',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
