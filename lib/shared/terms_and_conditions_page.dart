import 'package:flutter/material.dart';
import '../core/config/app_theme.dart';
import '../core/utils/app_localizations.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary, // Subtle grey background
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).termsAndConditions,
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
            // Top Branding Header
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
                  Icon(
                    Icons.description_outlined,
                    size: 50,
                    color: AppColors.white,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'سياسة استخدام حاويكم',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),

            // Content Container
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
                    _buildSectionTitle('وثيقة الشروط والأحكام'),
                    const SizedBox(height: 16),

                    _buildSectionHeader('1. المقدمة'),
                    _buildParagraph(
                      'تُعد هذه الوثيقة بمثابة اتفاقية قانونية ملزمة تحدد الشروط والأحكام التي تحكم استخدام العملاء لتطبيق "حاويتكم"، وهي منصة إلكترونية تتيح حجز واستئجار الحاويات والخدمات المرافقة لها ضمن أراضي المملكة العربية السعودية، وفقًا للأنظمة المعمول بها.',
                    ),
                    _buildParagraph(
                      'باستخدامك للتطبيق أو أي من خدماته، فإنك تقر بأنك قرأت هذه الشروط وفهمتها ووافقت عليها دون قيد أو شرط، وتُعتبر هذه الموافقة ملزمة قانونيًا كما لو تم توقيع اتفاقية ورقية.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('2. التعريفات'),
                    _buildSubSection('2.1 المنصة'),
                    _buildParagraph(
                      'ويقصد بها تطبيق وموقع "حاويتكم" الإلكتروني المملوك لشركة الخطوط الأرضية للخدمات اللوجستية، والذي يتيح تقديم خدمات تأجير الحاويات والخدمات اللوجستية المصاحبة.',
                    ),

                    _buildSubSection('2.2 العميل'),
                    _buildParagraph(
                      'الشخص الطبيعي أو الاعتباري الذي يستخدم المنصة لطلب خدمات تأجير الحاويات أو أي خدمات أخرى.',
                    ),

                    _buildSubSection('2.3 الشركة المؤجرة'),
                    _buildParagraph(
                      'أي شركة أو جهة معتمدة تقدم خدمات التأجير من خلال المنصة وفقاً للشروط المحددة.',
                    ),

                    _buildSubSection('2.4 الخدمة'),
                    _buildParagraph(
                      'تشمل جميع خدمات تأجير الحاويات، النقل، الرفع، أو أي خدمات إضافية مرتبطة يتم تقديمها عبر المنصة.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('3. التسجيل والاستخدام'),
                    _buildSubSection('3.1 شروط التسجيل'),
                    _buildBulletPoint(
                      'يشترط لاستخدام تطبيق "حاويتكم" التسجيل كمستخدم من خلال تعبئة البيانات المطلوبة بدقة',
                    ),
                    _buildBulletPoint(
                      'يجب أن يكون العميل قد بلغ سن الرشد القانوني (18 سنة ميلادية)',
                    ),
                    _buildBulletPoint(
                      'التسجيل في المنصة يعد موافقة صريحة على الالتزام بجميع الشروط والأحكام',
                    ),

                    _buildSubSection('3.2 صحة البيانات'),
                    _buildParagraph(
                      'يلتزم العميل بتقديم معلومات صحيحة وكاملة وحديثة أثناء التسجيل، ويتحمل كامل المسؤولية القانونية عن أي بيانات مضللة أو غير دقيقة يتم إدخالها.',
                    ),

                    _buildSubSection('3.3 إدارة الحساب'),
                    _buildParagraph(
                      'يلتزم العميل بالحفاظ على سرية بيانات الدخول الخاصة به وعدم مشاركتها مع أي طرف ثالث. أي استخدام يتم من خلال حساب العميل يعتبر صادرًا عنه.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('4. شروط الطلب والدفع'),
                    _buildSubSection('4.1 تقديم الطلب'),
                    _buildParagraph(
                      'يمكن للعميل تقديم طلب تأجير حاوية من خلال التطبيق باختيار نوع الحاوية، المدينة، مدة الإيجار، وموقع الإنزال بدقة. يجب التأكد من أن الموقع متاح وآمن لإنزال الحاوية دون عوائق.',
                    ),

                    _buildSubSection('4.2 الدفع الإلكتروني'),
                    _buildParagraph(
                      'يتم سداد قيمة الخدمة إلكترونيًا عبر وسائل الدفع المعتمدة داخل التطبيق (بطاقات مدى، بطاقات الائتمان، المحافظ الإلكترونية). المنصة لا تحتفظ ببيانات وسائل الدفع.',
                    ),

                    _buildSubSection('4.3 سياسة الاسترجاع'),
                    _buildBulletPoint(
                      'استرجاع كامل قبل تأكيد الطلب من الشركة المؤجرة',
                    ),
                    _buildBulletPoint(
                      'استرجاع بعد خصم 10% بعد التأكيد وقبل خروج الحاوية',
                    ),
                    _buildBulletPoint(
                      'استرجاع 50% فقط بعد خروج الحاوية للتوصيل',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('5. الالتزامات والمسؤوليات'),
                    _buildSubSection('5.1 التزامات العميل'),
                    _buildBulletPoint(
                      'الالتزام بكافة الأنظمة والتعليمات البلدية والبيئية',
                    ),
                    _buildBulletPoint(
                      'عدم تحميل مواد مخالفة (أشجار، أخشاب، أثاث، مواد قابلة للاشتعال)',
                    ),
                    _buildBulletPoint('عدم تجاوز الحمولة المحددة للحاوية'),
                    _buildBulletPoint(
                      'عدم زيادة الحمولة عن ارتفاع الحاوية بأكثر من 10 سم',
                    ),
                    _buildBulletPoint(
                      'توفير موقع مناسب وآمن لإنزال ورفع الحاوية',
                    ),

                    _buildSubSection('5.2 مسؤوليات العميل'),
                    _buildParagraph(
                      'العميل مسؤول عن الحاوية طوال فترة الإيجار، وأي تلف أو فقد أو ضرر يلحق بها خلال هذه الفترة يكون على عاتقه. قد تُفرض رسوم إضافية في حال التأخر في تسليم الحاوية.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('6. الاستخدام المسموح والممنوع'),
                    _buildParagraph(
                      'يُسمح باستخدام التطبيق فقط للأغراض القانونية والمشروعة ووفقًا للأنظمة السعودية ذات العلاقة.',
                    ),
                    const SizedBox(height: 8),
                    _buildParagraph('يُمنع:'),
                    _buildBulletPoint('تقديم بيانات وهمية أو مضللة'),
                    _buildBulletPoint('محاولة اختراق أو تعطيل المنصة'),
                    _buildBulletPoint(
                      'استخدام التطبيق بطريقة تضر بسمعة المنصة',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('7. سياسة الدفع والاسترجاع (مفصلة)'),
                    _buildSubSection('7.1 قبل بدء التنفيذ'),
                    _buildBulletPoint('✅ استرجاع 100% قبل تأكيد الطلب'),
                    _buildBulletPoint(
                      '✅ استرجاع 90% بعد التأكيد وقبل خروج الحاوية',
                    ),

                    _buildSubSection('7.2 بعد خروج الحاوية للتوصيل'),
                    _buildBulletPoint('⚠️ استرجاع 50% فقط من المبلغ المدفوع'),

                    _buildSubSection('7.3 في حال تقصير الشركة المؤجرة'),
                    _buildBulletPoint(
                      '💰 استرجاع كامل + تعويض لا يتجاوز ضعف قيمة الإيجار',
                    ),

                    _buildSubSection('7.4 إجراءات الاسترجاع'),
                    _buildParagraph(
                      'تتم عمليات الاسترجاع إلى نفس وسيلة الدفع الأصلية خلال مدة أقصاها 15 يومًا من تاريخ انتهاء الإيجار أو إلغاء الطلب.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('8. حدود المسؤولية والتعويض'),
                    _buildBulletPoint(
                      '📌 الحد الأقصى لأي تعويض: ضعف قيمة الإيجار المدفوع فقط',
                    ),
                    _buildBulletPoint(
                      '📌 لا مسؤولية عن الأضرار غير المباشرة أو فقد الأرباح',
                    ),
                    _buildBulletPoint(
                      '📌 العميل مسؤول عن تعويض أي ضرر يتسبب به للمنصة أو الشركة المؤجرة',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('10. الملكية الفكرية'),
                    _buildParagraph(
                      'جميع حقوق الملكية الفكرية المتعلقة بتطبيق "حاويتكم" محفوظة لشركة الخطوط الأرضية للخدمات اللوجستية (سجل تجاري: 1010641561). لا يجوز نسخ أو إعادة إنتاج أي جزء من المنصة دون إذن خطي مسبق.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('الأسئلة الشائعة'),
                    _buildSubSection('هل يمكن إلغاء الطلب بعد خروجه للتوصيل؟'),
                    _buildParagraph(
                      'نعم، لكن يتم استرجاع 50% فقط من المبلغ المدفوع.',
                    ),

                    _buildSubSection('متى يتم استرجاع المبلغ؟'),
                    _buildParagraph(
                      'خلال مدة لا تتجاوز 15 يومًا من تاريخ الإلغاء.',
                    ),

                    _buildSubSection(
                      'هل يمكن تحميل الحاوية بأي نوع من النفايات؟',
                    ),
                    _buildParagraph(
                      'لا، هناك مواد محظورة مثل الأخشاب والأثاث والأشجار والمواد الخطرة.',
                    ),

                    _buildSubSection(
                      'هل يمكن تحميل الحاوية بما يزيد عن الارتفاع؟',
                    ),
                    _buildParagraph(
                      'لا يحق لك زيادة حمولة الحاوية عن ارتفاعها بأكثر من 10 سم.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('13. الأحكام العامة'),
                    _buildParagraph(
                      'تخضع هذه الشروط والأحكام للأنظمة المعمول بها في المملكة العربية السعودية، ويكون الاختصاص القضائي لمحاكم المملكة في حال نشوء أي نزاع. يمكن للمنصة تعديل هذه الشروط من وقت لآخر مع إشعار العملاء.',
                    ),

                    const Divider(height: 32),

                    _buildSectionHeader('14. الخاتمة'),
                    _buildParagraph(
                      'إن استخدامك لتطبيق "حاويتكم" يعني موافقتك الكاملة والصريحة وغير المشروطة على جميع الشروط والأحكام الواردة في هذه الوثيقة. في حال عدم الموافقة على أي بند، يجب التوقف فورًا عن استخدام التطبيق.',
                    ),

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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        fontFamily: 'Tajawal',
      ),
    );
  }

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
      padding: const EdgeInsets.only(top: 12, bottom: 4),
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
      padding: const EdgeInsets.only(bottom: 8, right: 8),
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
                height: 1.5,
                color: AppColors.textSecondary,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
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
      child: Column(
        children: [
          const Text(
            'شركة الخطوط الأرضية للخدمات اللوجستية',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'سجل تجاري: 1010641561',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
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
