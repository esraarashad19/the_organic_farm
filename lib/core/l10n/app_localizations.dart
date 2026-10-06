import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get isArabic => locale.languageCode == 'ar';

  String t(String key) => (_tables[locale.languageCode] ?? _en)[key] ?? key;

  String get earthData => t('earth_data_key');
  String get contracts => t('contracts_key');
  String get picturesVideos => t('pictures_videos_key');
  String get technicalOperations => t('technical_operations_key');
  String get production => t('production_key');
  String get financialAccounts => t('financial_accounts_key');
  String get communication => t('communication_key');
  String get selectLang => t('selectLang');
  String get english => t('english');
  String get arabic => t('arabic');
  String get landNumber => t('land_number_key');
  String get landSize => t('land_size_key');
  String get numberOfPits => t('number_of_pits_key');
  String get numberOfPalms => t('number_of_palms_key');
  String get cultivationCount => t('cultivation_count_key');
  String get missingCount => t('missing_count_key');
  String get contractTitle => t('contract_title');
  String get sponsorshipContract => t('sponsorship_contract');
  String get partnershipContract => t('partnership_contract');
  String get personalCard => t('personal_card');
  String get technicalOperationsTitle => t('technical_operations_title');
  String get financials => t('financial_key');
  String get contactAccounts => t('contact_accounts');
  String get contactAgriculture => t('contact_agriculture');
  String get contactCustomerService => t('contact_customer_service');
  String get settingsTitle => t('settings_title');
  String get profileButton => t('profile_button');
  String get changeLanguage => t('change_language_button');
  String get logout => t('logout_button');
  String get contactTitle => t('contact_title');
  String get landData => t('land_data');
  String get profileTitle => t('profile_title');
  String get fullNameLabel => t('full_name_label');
  String get nationalIdLabel => t('national_id_label');
  String get phoneNumberLabel => t('phone_number_label');
  String get emailLabel => t('email_label');
  String get passwordLabel => t('password_label');
  String get fullNamePlaceholder => t('full_name_placeholder');
  String get nationalIdPlaceholder => t('national_id_placeholder');
  String get phonePlaceholder => t('phone_number_placeholder');
  String get emailPlaceholder => t('email_placeholder');
  String get passwordPlaceholder => t('password_placeholder');
  String get save => t('save_button');
  String get loginTitle => t('login_title');
  String get login => t('login_button');
  String get noAccount => t('no_account_label');
  String get register => t('register_label');
  String get forgotPassword => t('forgot_password_button');
  String get loginSuccess => t('login_success_message');
  String get emailRequired => t('email_required');
  String get passwordRequired => t('password_required');
  String get loginError => t('login_error_message');
  String get idTypeLabel => t('id_label');
  String get registerButton => t('register_button');
  String get alreadyHaveAccount => t('already_have_account_label');
  String get loginLink => t('login_label');
  String get nationalId => t('national_id');
  String get passport => t('passport');
  String get registerTitle => t('register_title');
  String get forgotPasswordTitle => t('forgot_password_title');
  String get reset => t('reset_button');
  String get imagesVideos => t('images_videos');
  String get images => t('images');
  String get videos => t('videos');
  String get close => t('close');
  String get hello => t('hello');
  String get pastOperations => t('past_operations');
  String get currentOperations => t('current_operations');
  String get futureOperations => t('future_operations');
  String get pastProduction => t('past_production');
  String get currentProduction => t('current_production');
  String get done => t('done');
  String withUser(String title, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return title;
    return '$title - $trimmed';
  }

  String get translateToArabic => t('translate_to_arabic');
  String get translateToEnglish => t('translate_to_english');
  String get noNotifications => t('no_notifications');
  String get accounts => t('accounts');
  String get na => t('na');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

const _en = {
  'earth_data_key': 'Land data',
  'contracts_key': 'Contracts',
  'pictures_videos_key': 'Pictures and videos',
  'technical_operations_key': 'Technical operations',
  'production_key': 'Production',
  'financial_accounts_key': 'Financial accounts',
  'communication_key': 'Contact us',
  'selectLang': 'Select Your Language',
  'english': 'English',
  'arabic': 'Arabic',
  'land_number_key': 'Land number:',
  'land_size_key': 'Land size:',
  'number_of_pits_key': 'Number of pits:',
  'number_of_palms_key': 'Number of palms:',
  'cultivation_count_key': 'Year of planting:',
  'missing_count_key': 'Missing count:',
  'contract_title': 'Contract',
  'sponsorship_contract': 'Sponsorship contract',
  'partnership_contract': 'Partnership contract',
  'personal_card': 'Personal card',
  'technical_operations_title': 'Technical operations',
  'financial_key': 'Financials',
  'contact_accounts': 'To contact accounts:',
  'contact_agriculture': 'To contact the Agriculture Department:',
  'contact_customer_service': 'To contact customer service:',
  'settings_title': 'Settings',
  'profile_button': 'Profile',
  'change_language_button': 'Change language',
  'logout_button': 'Logout',
  'contact_title': 'Contact',
  'land_data': 'Land data',
  'profile_title': 'Profile',
  'full_name_label': 'Full Name:',
  'national_id_label': 'National ID:',
  'phone_number_label': 'Phone Number:',
  'email_label': 'Email:',
  'password_label': 'Password:',
  'full_name_placeholder': 'Enter your full name',
  'national_id_placeholder': 'Enter your national ID',
  'phone_number_placeholder': 'Enter your phone number',
  'email_placeholder': 'Enter your email',
  'password_placeholder': 'Enter your password',
  'save_button': 'Save',
  'login_title': 'Login - Organic Farm',
  'login_button': 'Login',
  'no_account_label': "Don't have an account?",
  'register_label': 'Register',
  'forgot_password_button': 'Forgot password?',
  'login_success_message': 'Login successful',
  'email_required': 'Please enter your email address',
  'password_required': 'Please enter your password',
  'login_error_message': 'An error occurred. Please try again.',
  'id_label': 'ID Type:',
  'id_number_placeholder': 'Enter your ID number',
  'register_button': 'Register',
  'already_have_account_label': 'Already have an account?',
  'login_label': 'Login',
  'national_id': 'National ID',
  'passport': 'Passport',
  'register_title': 'Create an Account',
  'forgot_password_title': 'Forgot Password',
  'reset_button': 'Reset',
  'images_videos': 'Images and videos',
  'images': 'Images',
  'videos': 'Videos',
  'close': 'Close',
  'hello': 'Hello, ',
  'past_operations': 'Past operations',
  'current_operations': 'Current operations',
  'future_operations': 'Future operations',
  'past_production': 'Past production',
  'current_production': 'Current production',
  'done': 'Done',
  'na': 'N/A',
  'translate_to_arabic': 'Translate to Arabic',
  'translate_to_english': 'Translate to English',
  'no_notifications': 'No new notifications',
  'accounts': 'Accounts',
};

const _ar = {
  'earth_data_key': 'بيانات الأرض',
  'contracts_key': 'العقود',
  'pictures_videos_key': 'الصور والفيديوهات',
  'technical_operations_key': 'العمليات الفنية',
  'production_key': 'الإنتاج',
  'financial_accounts_key': 'الحسابات المالية',
  'communication_key': 'التواصل',
  'selectLang': 'اختر لغتك',
  'english': 'الإنجليزية',
  'arabic': 'العربية',
  'land_number_key': 'رقم الأرض:',
  'land_size_key': 'مساحة الأرض:',
  'number_of_pits_key': 'عدد الحفر:',
  'number_of_palms_key': 'عدد النخيل:',
  'cultivation_count_key': 'تاريخ الزراعة',
  'missing_count_key': 'عدد المفقودات:',
  'contract_title': 'العقد',
  'sponsorship_contract': 'عقد رعاية',
  'partnership_contract': 'عقد مشاركة',
  'personal_card': 'البطاقة الشخصية',
  'technical_operations_title': 'العمليات الفنية',
  'financial_key': 'الحسابات المالية',
  'contact_accounts': 'للتواصل مع الحسابات:',
  'contact_agriculture': 'للتواصل مع قسم الزراعة:',
  'contact_customer_service': 'للتواصل مع خدمة العملاء:',
  'settings_title': 'الإعدادات',
  'profile_button': 'الملف الشخصي',
  'change_language_button': 'تغيير اللغة',
  'logout_button': 'تسجيل الخروج',
  'contact_title': 'التواصل',
  'land_data': 'بيانات الأرض',
  'profile_title': 'الصفحة الشخصية',
  'full_name_label': 'اسم المستخدم:',
  'national_id_label': 'الرقم القومي:',
  'phone_number_label': 'رقم الموبايل:',
  'email_label': 'البريد الإلكتروني:',
  'password_label': 'كلمة المرور:',
  'full_name_placeholder': 'أدخل اسمك الكامل',
  'national_id_placeholder': 'أدخل الرقم القومي',
  'phone_number_placeholder': 'أدخل رقم الموبايل',
  'email_placeholder': 'أدخل البريد الإلكتروني',
  'password_placeholder': 'أدخل كلمة المرور',
  'save_button': 'حفظ',
  'login_title': 'تسجيل الدخول - أورجانيك فارم',
  'login_button': 'تسجيل الدخول',
  'no_account_label': 'لا تملك حساب؟',
  'register_label': 'تسجيل حساب',
  'forgot_password_button': 'هل نسيت كلمة المرور؟',
  'login_success_message': 'تم تسجيل الدخول بنجاح',
  'email_required': 'يرجى إدخال البريد الإلكتروني',
  'password_required': 'يرجى إدخال كلمة المرور',
  'login_error_message': 'حدث خطأ. يرجى المحاولة مرة أخرى.',
  'id_label': 'نوع الهوية:',
  'id_number_placeholder': 'أدخل رقم الهوية',
  'register_button': 'تسجيل',
  'already_have_account_label': 'لديك حساب بالفعل؟',
  'login_label': 'تسجيل الدخول',
  'national_id': 'الرقم القومي',
  'passport': 'جواز السفر',
  'register_title': 'إنشاء حساب',
  'forgot_password_title': 'نسيت كلمة المرور',
  'reset_button': 'إعادة تعيين',
  'images_videos': 'الصور و الفيديوهات',
  'images': 'الصور',
  'videos': 'الفيديوهات',
  'close': 'اغلاق',
  'hello': 'مرحبا، ',
  'past_operations': 'العمليات السابقة',
  'current_operations': 'العمليات الحالية',
  'future_operations': 'العمليات القادمة',
  'past_production': 'الإنتاج السابق',
  'current_production': 'الإنتاج الحالي',
  'done': 'تم',
  'na': 'غير متاح',
  'translate_to_arabic': 'ترجم إلى العربية',
  'translate_to_english': 'ترجم إلى الإنجليزية',
  'no_notifications': 'لا توجد إشعارات جديدة',
  'accounts': 'حسابات',
};

const _tables = {'en': _en, 'ar': _ar};
