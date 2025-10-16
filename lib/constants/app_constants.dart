// App Constants
class AppConstants {
  // App Information
  static const String appName = 'Medical Record System';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String apiBaseUrl =
      'http://localhost:5000'; // This should be configurable
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB in bytes
  static const int maxFileCount = 5;
  static const String maxFileSizeDisplay = '5MB';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double appBarElevation = 0;

  // Text Sizes
  static const double largeTextSize = 28.0;
  static const double mediumTextSize = 20.0;
  static const double regularTextSize = 16.0;
  static const double smallTextSize = 14.0;
  static const double extraSmallTextSize = 12.0;

  // Spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingExtraLarge = 32.0;

  // Dimensions
  static const double appBarHeight = 56.0;
  static const double buttonHeight = 50.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 80.0;

  // Colors - Using Material color names
  static const String primaryColorName = 'blue';
  static const String secondaryColorName = 'green';
  static const String accentColorName = 'orange';
  static const String errorColorName = 'red';
  static const String successColorName = 'green';
  static const String warningColorName = 'orange';
  static const String infoColorName = 'blue';

  // OTP Configuration
  static const int otpLength = 6;
  static const int otpCooldownSeconds = 30;

  // Search Configuration
  static const int searchDebounceMilliseconds = 500;
  static const int searchResultsLimit = 20;

  // Database Configuration
  static const String databaseName = 'medical_records.db';
  static const int databaseVersion = 1;

  // Notification Channel Configuration
  static const String notificationChannelId = 'channel_id';
  static const String notificationChannelName = 'channel_name';
  static const String notificationChannelDescription = 'channel_description';

  // Route Names
  static const String loginRoute = '/';
  static const String homeRoute = '/home';
  static const String entryRoute = '/entry';
  static const String searchRoute = '/search';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String dashboardRoute = '/dashboard';

  // Theme Configuration
  static const String defaultThemeId = 'light_blue';
  static const String lightBlueThemeId = 'light_blue';
  static const String darkBlueThemeId = 'dark_blue';
  static const String lightGreenThemeId = 'light_green';
  static const String darkGreenThemeId = 'dark_green';

  // Validation Messages
  static const String requiredFieldMessage = 'This field is required';
  static const String invalidEmailMessage =
      'Please enter a valid email address';
  static const String invalidPhoneMessage =
      'Please enter a valid 10-digit phone number';
  static const String invalidPasswordMessage =
      'Password must be at least 6 characters';
  static const String invalidOtpMessage = 'OTP must be 6 digits';
  static const String maxLengthMessage = 'Maximum length exceeded';

  // API Response Messages
  static const String offlineModeMessage =
      'App is in offline mode. Data will sync when online.';
  static const String successMessage = 'Operation completed successfully';
  static const String errorMessage = 'An error occurred. Please try again.';

  // File Configuration
  static const List<String> allowedFileExtensions = [
    'txt',
    'pdf',
    'png',
    'jpg',
    'jpeg',
    'gif',
    'doc',
    'docx'
  ];

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
}
