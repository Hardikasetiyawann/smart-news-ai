import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'LensNews'**
  String get appName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to your LensNews account'**
  String get loginSubtitle;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginNow;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during login'**
  String get loginError;

  /// No description provided for @googleLogin.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get googleLogin;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @latestNews.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get latestNews;

  /// No description provided for @dashboardTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get dashboardTrending;

  /// No description provided for @dashboardSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get dashboardSeeAll;

  /// No description provided for @dashboardCategoryFallback.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get dashboardCategoryFallback;

  /// No description provided for @dashboardPublisherFallback.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get dashboardPublisherFallback;

  /// No description provided for @dashboardViews.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String dashboardViews(Object count);

  /// No description provided for @dashboardPublishers.
  ///
  /// In en, this message translates to:
  /// **'Publishers'**
  String get dashboardPublishers;

  /// No description provided for @dashboardLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get dashboardLoading;

  /// No description provided for @dashboardLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get dashboardLatest;

  /// No description provided for @dashboardWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get dashboardWelcomeBack;

  /// No description provided for @dashboardUserFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get dashboardUserFallback;

  /// No description provided for @detailAiSummary.
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get detailAiSummary;

  /// No description provided for @dashboardEmptyNews.
  ///
  /// In en, this message translates to:
  /// **'News not available'**
  String get dashboardEmptyNews;

  /// No description provided for @dashboardAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dashboardAll;

  /// No description provided for @readingHistory.
  ///
  /// In en, this message translates to:
  /// **'Reading History'**
  String get readingHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistory;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Password & Security'**
  String get security;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change App Language'**
  String get changeLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About LensNews'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get onboardTitle1;

  /// No description provided for @onboardDesc1.
  ///
  /// In en, this message translates to:
  /// **'Stay connected with the latest news every day'**
  String get onboardDesc1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Personalized Content'**
  String get onboardTitle2;

  /// No description provided for @onboardDesc2.
  ///
  /// In en, this message translates to:
  /// **'Choose your favorite topics'**
  String get onboardDesc2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'In-depth Context'**
  String get onboardTitle3;

  /// No description provided for @onboardDesc3.
  ///
  /// In en, this message translates to:
  /// **'Insights from various sources'**
  String get onboardDesc3;

  /// No description provided for @helpIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'We are here to help you'**
  String get helpIntroTitle;

  /// No description provided for @helpIntroDesc.
  ///
  /// In en, this message translates to:
  /// **'Find answers to frequently asked questions about using the LensNews application.'**
  String get helpIntroDesc;

  /// No description provided for @faqWhatIsTitle.
  ///
  /// In en, this message translates to:
  /// **'What is LensNews?'**
  String get faqWhatIsTitle;

  /// No description provided for @faqWhatIsDesc.
  ///
  /// In en, this message translates to:
  /// **'LensNews is a digital news application that provides the latest information from various categories with trusted sources.'**
  String get faqWhatIsDesc;

  /// No description provided for @faqFreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Is LensNews free to use?'**
  String get faqFreeTitle;

  /// No description provided for @faqFreeDesc.
  ///
  /// In en, this message translates to:
  /// **'Yes, LensNews is free to use. Some additional features may be available in future versions.'**
  String get faqFreeDesc;

  /// No description provided for @faqChangeLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'How can I change the app language?'**
  String get faqChangeLanguageTitle;

  /// No description provided for @faqChangeLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'You can change the language through Settings → App Language.'**
  String get faqChangeLanguageDesc;

  /// No description provided for @faqNotificationSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'How do I enable or disable notifications?'**
  String get faqNotificationSettingTitle;

  /// No description provided for @faqNotificationSettingDesc.
  ///
  /// In en, this message translates to:
  /// **'Notification settings can be changed through Settings → Notifications.'**
  String get faqNotificationSettingDesc;

  /// No description provided for @faqNoNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Why am I not receiving news notifications?'**
  String get faqNoNotificationTitle;

  /// No description provided for @faqNoNotificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure notifications are enabled in the app settings and your device system settings.'**
  String get faqNoNotificationDesc;

  /// No description provided for @faqSaveNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'How can I save news to read later?'**
  String get faqSaveNewsTitle;

  /// No description provided for @faqSaveNewsDesc.
  ///
  /// In en, this message translates to:
  /// **'You can save news by tapping the save icon on the article page.'**
  String get faqSaveNewsDesc;

  /// No description provided for @faqShareNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Can news be shared from LensNews?'**
  String get faqShareNewsTitle;

  /// No description provided for @faqShareNewsDesc.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can share news to social media or other apps using the share button.'**
  String get faqShareNewsDesc;

  /// No description provided for @faqContactTitle.
  ///
  /// In en, this message translates to:
  /// **'How can I contact the LensNews team?'**
  String get faqContactTitle;

  /// No description provided for @faqContactDesc.
  ///
  /// In en, this message translates to:
  /// **'Please contact us via official email or through the help menu available in the app.'**
  String get faqContactDesc;

  /// No description provided for @termsHeader.
  ///
  /// In en, this message translates to:
  /// **'LENSNEWS TERMS OF SERVICE'**
  String get termsHeader;

  /// No description provided for @termsEffectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective as of: November 1, 2025'**
  String get termsEffectiveDate;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to LensNews (the \"App\"), a digital news platform that allows users to access information, read news, enjoy editorial content, comment, save articles, and use other features.'**
  String get termsIntro;

  /// No description provided for @termsSectionAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Application'**
  String get termsSectionAboutTitle;

  /// No description provided for @termsSectionAboutBody.
  ///
  /// In en, this message translates to:
  /// **'LensNews is provided by PT Lens Media Nusantara (\"LensNews\", or \"We\").'**
  String get termsSectionAboutBody;

  /// No description provided for @termsSectionAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account, Security, and Responsibility'**
  String get termsSectionAccountTitle;

  /// No description provided for @termsSectionAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Users are responsible for maintaining account security and password confidentiality.'**
  String get termsSectionAccountBody;

  /// No description provided for @termsSectionContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Content and Services'**
  String get termsSectionContentTitle;

  /// No description provided for @termsSectionContentBody.
  ///
  /// In en, this message translates to:
  /// **'LensNews content comes from internal editors and third-party partners.'**
  String get termsSectionContentBody;

  /// No description provided for @termsSectionPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'User Privacy'**
  String get termsSectionPrivacyTitle;

  /// No description provided for @termsSectionPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'LensNews respects user privacy.'**
  String get termsSectionPrivacyBody;

  /// No description provided for @termsSectionLimitationTitle.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get termsSectionLimitationTitle;

  /// No description provided for @termsSectionLimitationBody.
  ///
  /// In en, this message translates to:
  /// **'LensNews is not liable for service interruptions or content errors.'**
  String get termsSectionLimitationBody;

  /// No description provided for @termsSectionLawTitle.
  ///
  /// In en, this message translates to:
  /// **'Governing Law'**
  String get termsSectionLawTitle;

  /// No description provided for @termsSectionLawBody.
  ///
  /// In en, this message translates to:
  /// **'These terms are governed by the laws of the Republic of Indonesia.'**
  String get termsSectionLawBody;

  /// No description provided for @termsClosing.
  ///
  /// In en, this message translates to:
  /// **'By using the LensNews App, users agree to be bound by these Terms.'**
  String get termsClosing;

  /// No description provided for @aboutSectionAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Application'**
  String get aboutSectionAppTitle;

  /// No description provided for @aboutSectionAppBody1.
  ///
  /// In en, this message translates to:
  /// **'LensNews is a digital news application designed for a fast and relevant reading experience.'**
  String get aboutSectionAppBody1;

  /// No description provided for @aboutSectionAppBody2.
  ///
  /// In en, this message translates to:
  /// **'LensNews helps users access trusted news in real-time.'**
  String get aboutSectionAppBody2;

  /// No description provided for @aboutSectionVisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Vision & Mission'**
  String get aboutSectionVisionTitle;

  /// No description provided for @aboutSectionVisionBody1.
  ///
  /// In en, this message translates to:
  /// **'To become a credible digital information hub.'**
  String get aboutSectionVisionBody1;

  /// No description provided for @aboutSectionVisionBody2.
  ///
  /// In en, this message translates to:
  /// **'Supporting information literacy and a comfortable user experience.'**
  String get aboutSectionVisionBody2;

  /// No description provided for @aboutSectionFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get aboutSectionFeatureTitle;

  /// No description provided for @aboutFeature1.
  ///
  /// In en, this message translates to:
  /// **'Latest and trusted news'**
  String get aboutFeature1;

  /// No description provided for @aboutFeature2.
  ///
  /// In en, this message translates to:
  /// **'Real-time notifications'**
  String get aboutFeature2;

  /// No description provided for @aboutFeature3.
  ///
  /// In en, this message translates to:
  /// **'Save articles'**
  String get aboutFeature3;

  /// No description provided for @aboutFeature4.
  ///
  /// In en, this message translates to:
  /// **'Theme and language settings'**
  String get aboutFeature4;

  /// No description provided for @aboutFeature5.
  ///
  /// In en, this message translates to:
  /// **'Personalized categories'**
  String get aboutFeature5;

  /// No description provided for @aboutSectionCommitmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Commitment'**
  String get aboutSectionCommitmentTitle;

  /// No description provided for @aboutSectionCommitmentBody.
  ///
  /// In en, this message translates to:
  /// **'LensNews is committed to maintaining information quality and data security.'**
  String get aboutSectionCommitmentBody;

  /// No description provided for @aboutFooter.
  ///
  /// In en, this message translates to:
  /// **'LensNews © 2025'**
  String get aboutFooter;

  /// No description provided for @profileSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettingsTooltip;

  /// No description provided for @profileUnlikeAction.
  ///
  /// In en, this message translates to:
  /// **'Remove Like'**
  String get profileUnlikeAction;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap the camera icon to change your photo'**
  String get tapToChangePhoto;

  /// No description provided for @accountInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfoSection;

  /// No description provided for @editEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get editEmailTitle;

  /// No description provided for @emailDescription.
  ///
  /// In en, this message translates to:
  /// **'Email is used for login and account notifications.'**
  String get emailDescription;

  /// No description provided for @emailHintNew.
  ///
  /// In en, this message translates to:
  /// **'Enter new email'**
  String get emailHintNew;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get emailInvalid;

  /// No description provided for @emailNotChanged.
  ///
  /// In en, this message translates to:
  /// **'Email has not changed'**
  String get emailNotChanged;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reading history yet'**
  String get historyEmpty;

  /// No description provided for @historyReadAt.
  ///
  /// In en, this message translates to:
  /// **'Read at'**
  String get historyReadAt;

  /// No description provided for @historyNewsId.
  ///
  /// In en, this message translates to:
  /// **'News ID'**
  String get historyNewsId;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version {version}'**
  String appVersion(Object version);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get navBookmark;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @drawerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get drawerDashboard;

  /// No description provided for @drawerSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get drawerSearch;

  /// No description provided for @drawerBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get drawerBookmarks;

  /// No description provided for @drawerProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get drawerProfile;

  /// No description provided for @drawerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get drawerNotifications;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @commentTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentTitle;

  /// No description provided for @commentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get commentEmpty;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get commentHint;

  /// No description provided for @commentSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commentSave;

  /// No description provided for @commentCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commentCancel;

  /// No description provided for @commentEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commentEdit;

  /// No description provided for @commentDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commentDelete;

  /// No description provided for @commentReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get commentReport;

  /// No description provided for @commentDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete comment'**
  String get commentDeleteTitle;

  /// No description provided for @commentDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment?'**
  String get commentDeleteConfirm;

  /// No description provided for @commentNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commentNo;

  /// No description provided for @commentYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commentYes;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @reportCommentTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Comment'**
  String get reportCommentTitle;

  /// No description provided for @reportNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Report News'**
  String get reportNewsTitle;

  /// No description provided for @reportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report submitted successfully'**
  String get reportSuccess;

  /// No description provided for @reportHint.
  ///
  /// In en, this message translates to:
  /// **'Write the reason for the report...'**
  String get reportHint;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get successTitle;

  /// No description provided for @successSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready to use'**
  String get successSubtitle;

  /// No description provided for @openHome.
  ///
  /// In en, this message translates to:
  /// **'Open Home'**
  String get openHome;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading application...'**
  String get splashLoading;

  /// No description provided for @privacyIntro1.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy applies to the LensNews app.'**
  String get privacyIntro1;

  /// No description provided for @privacyIntro2.
  ///
  /// In en, this message translates to:
  /// **'By using the app, you agree to this policy.'**
  String get privacyIntro2;

  /// No description provided for @privacySectionCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Data Collection'**
  String get privacySectionCollectTitle;

  /// No description provided for @privacySectionCollectBody.
  ///
  /// In en, this message translates to:
  /// **'We collect data necessary to provide services.'**
  String get privacySectionCollectBody;

  /// No description provided for @privacySectionUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Use of Information'**
  String get privacySectionUseTitle;

  /// No description provided for @privacySectionUseBody.
  ///
  /// In en, this message translates to:
  /// **'Data is used to improve user experience.'**
  String get privacySectionUseBody;

  /// No description provided for @privacySectionShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Information Sharing'**
  String get privacySectionShareTitle;

  /// No description provided for @privacySectionShareBody.
  ///
  /// In en, this message translates to:
  /// **'We do not sell personal data.'**
  String get privacySectionShareBody;

  /// No description provided for @privacySectionSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get privacySectionSecurityTitle;

  /// No description provided for @privacySectionSecurityBody.
  ///
  /// In en, this message translates to:
  /// **'We protect data with high security standards.'**
  String get privacySectionSecurityBody;

  /// No description provided for @privacySectionRetentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Retention'**
  String get privacySectionRetentionTitle;

  /// No description provided for @privacySectionRetentionBody.
  ///
  /// In en, this message translates to:
  /// **'Data is stored according to legal requirements.'**
  String get privacySectionRetentionBody;

  /// No description provided for @privacySectionRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'User Rights'**
  String get privacySectionRightsTitle;

  /// No description provided for @privacySectionRightsBody.
  ///
  /// In en, this message translates to:
  /// **'Users may request data deletion.'**
  String get privacySectionRightsBody;

  /// No description provided for @privacySectionChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Policy Changes'**
  String get privacySectionChangeTitle;

  /// No description provided for @privacySectionChangeBody.
  ///
  /// In en, this message translates to:
  /// **'This policy may be updated at any time.'**
  String get privacySectionChangeBody;

  /// No description provided for @privacyClosing.
  ///
  /// In en, this message translates to:
  /// **'By using LensNews, you agree to this policy.'**
  String get privacyClosing;

  /// No description provided for @privacyHeader.
  ///
  /// In en, this message translates to:
  /// **'LENSNEWS PRIVACY POLICY'**
  String get privacyHeader;

  /// No description provided for @privacyEffectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective date: November 24, 2025'**
  String get privacyEffectiveDate;

  /// No description provided for @bookmarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarkTitle;

  /// No description provided for @bookmarkClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all bookmarks'**
  String get bookmarkClear;

  /// No description provided for @bookmarkEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get bookmarkEmpty;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search News'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search news...'**
  String get searchHint;

  /// No description provided for @searchInitialHint.
  ///
  /// In en, this message translates to:
  /// **'Type a news keyword'**
  String get searchInitialHint;

  /// No description provided for @searchEmptyResult.
  ///
  /// In en, this message translates to:
  /// **'No news found'**
  String get searchEmptyResult;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @profileLikedNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Liked News'**
  String get profileLikedNewsTitle;

  /// No description provided for @profileEmptyLikedNews.
  ///
  /// In en, this message translates to:
  /// **'No liked news yet'**
  String get profileEmptyLikedNews;

  /// No description provided for @deleteHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete this history?'**
  String get deleteHistory;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @historySelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String historySelectedCount(int count);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @unselectAll.
  ///
  /// In en, this message translates to:
  /// **'Unselect all'**
  String get unselectAll;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @notificationToday.
  ///
  /// In en, this message translates to:
  /// **'Today, {date}'**
  String notificationToday(String date);

  /// No description provided for @notificationYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, {date}'**
  String notificationYesterday(String date);

  /// No description provided for @notificationLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading notifications...'**
  String get notificationLoading;

  /// No description provided for @notificationDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete notification'**
  String get notificationDelete;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @notificationSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSection;

  /// No description provided for @notificationNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest news notifications'**
  String get notificationNewsTitle;

  /// No description provided for @notificationNewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when new articles are published'**
  String get notificationNewsSubtitle;

  /// No description provided for @notificationSilentTitle.
  ///
  /// In en, this message translates to:
  /// **'Silent mode'**
  String get notificationSilentTitle;

  /// No description provided for @notificationSilentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications will not appear on your device'**
  String get notificationSilentSubtitle;

  /// No description provided for @notificationSettingsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notification settings'**
  String get notificationSettingsError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
