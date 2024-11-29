// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Select Image`
  String get select_image {
    return Intl.message(
      'Select Image',
      name: 'select_image',
      desc: '',
      args: [],
    );
  }

  /// `Select image from album`
  String get select_image_from_album {
    return Intl.message(
      'Select image from album',
      name: 'select_image_from_album',
      desc: '',
      args: [],
    );
  }

  /// `Image selected: {imagePath}`
  String image_selected_image_path(Object imagePath) {
    return Intl.message(
      'Image selected: $imagePath',
      name: 'image_selected_image_path',
      desc: '',
      args: [imagePath],
    );
  }

  /// `Login failed, please check username or password`
  String get login_failed_please_check_username_or_password {
    return Intl.message(
      'Login failed, please check username or password',
      name: 'login_failed_please_check_username_or_password',
      desc: '',
      args: [],
    );
  }

  /// `This user was not found, please check the username`
  String get this_user_was_not_found {
    return Intl.message(
      'This user was not found, please check the username',
      name: 'this_user_was_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password, please re-enter`
  String get wrong_password_please_reenter {
    return Intl.message(
      'Wrong password, please re-enter',
      name: 'wrong_password_please_reenter',
      desc: '',
      args: [],
    );
  }

  /// `Login failed, please try again`
  String get login_failed_please_try_again {
    return Intl.message(
      'Login failed, please try again',
      name: 'login_failed_please_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your registered email address`
  String get please_enter_your_registered_email_address {
    return Intl.message(
      'Please enter your registered email address',
      name: 'please_enter_your_registered_email_address',
      desc: '',
      args: [],
    );
  }

  /// `The email to reset your password has been sent to your mailbox`
  String get the_email_to_reset_your_password_has_been_sent_to_your_mailbox {
    return Intl.message(
      'The email to reset your password has been sent to your mailbox',
      name: 'the_email_to_reset_your_password_has_been_sent_to_your_mailbox',
      desc: '',
      args: [],
    );
  }

  /// `Unable to send reset password email`
  String get unable_to_send_reset_password_email {
    return Intl.message(
      'Unable to send reset password email',
      name: 'unable_to_send_reset_password_email',
      desc: '',
      args: [],
    );
  }

  /// `This user was not found, please check your mailbox`
  String get this_user_was_not_found_please_check_your_mailbox {
    return Intl.message(
      'This user was not found, please check your mailbox',
      name: 'this_user_was_not_found_please_check_your_mailbox',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a username`
  String get please_enter_a_username {
    return Intl.message(
      'Please enter a username',
      name: 'please_enter_a_username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get please_enter_your_password {
    return Intl.message(
      'Please enter your password',
      name: 'please_enter_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? Register`
  String get dont_have_an_account_register {
    return Intl.message(
      'Don\'t have an account? Register',
      name: 'dont_have_an_account_register',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgot_your_password {
    return Intl.message(
      'Forgot your password?',
      name: 'forgot_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Registration Successful`
  String get registration_successful {
    return Intl.message(
      'Registration Successful',
      name: 'registration_successful',
      desc: '',
      args: [],
    );
  }

  /// `The password is too weak.`
  String get the_password_is_too_weak {
    return Intl.message(
      'The password is too weak.',
      name: 'the_password_is_too_weak',
      desc: '',
      args: [],
    );
  }

  /// `This mailbox has been registered.`
  String get this_mailbox_has_been_registered {
    return Intl.message(
      'This mailbox has been registered.',
      name: 'this_mailbox_has_been_registered',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed, please try again.`
  String get registration_failed_please_try_again {
    return Intl.message(
      'Registration failed, please try again.',
      name: 'registration_failed_please_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get please_enter_a_valid_email_address {
    return Intl.message(
      'Please enter a valid email address',
      name: 'please_enter_a_valid_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Passwords need to be at least 6 characters`
  String get passwords_need_to_be_at_least_6_characters {
    return Intl.message(
      'Passwords need to be at least 6 characters',
      name: 'passwords_need_to_be_at_least_6_characters',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password again`
  String get please_enter_your_password_again {
    return Intl.message(
      'Please enter your password again',
      name: 'please_enter_your_password_again',
      desc: '',
      args: [],
    );
  }

  /// `Please select a video first`
  String get please_select_a_video_first {
    return Intl.message(
      'Please select a video first',
      name: 'please_select_a_video_first',
      desc: '',
      args: [],
    );
  }

  /// `Upload Video`
  String get upload_video {
    return Intl.message(
      'Upload Video',
      name: 'upload_video',
      desc: '',
      args: [],
    );
  }

  /// `Shooting Video`
  String get shooting_video {
    return Intl.message(
      'Shooting Video',
      name: 'shooting_video',
      desc: '',
      args: [],
    );
  }

  /// `Select video from album`
  String get select_video_from_album {
    return Intl.message(
      'Select video from album',
      name: 'select_video_from_album',
      desc: '',
      args: [],
    );
  }

  /// `Selected video: {videoFilePath}`
  String selected_video_video_filepath(Object videoFilePath) {
    return Intl.message(
      'Selected video: $videoFilePath',
      name: 'selected_video_video_filepath',
      desc: '',
      args: [videoFilePath],
    );
  }

  /// `Add to video list`
  String get add_to_video_list {
    return Intl.message(
      'Add to video list',
      name: 'add_to_video_list',
      desc: '',
      args: [],
    );
  }

  /// `View Video List`
  String get view_video_list {
    return Intl.message(
      'View Video List',
      name: 'view_video_list',
      desc: '',
      args: [],
    );
  }

  /// `Video Details`
  String get video_details {
    return Intl.message(
      'Video Details',
      name: 'video_details',
      desc: '',
      args: [],
    );
  }

  /// `Processing video`
  String get processing_video {
    return Intl.message(
      'Processing video',
      name: 'processing_video',
      desc: '',
      args: [],
    );
  }

  /// `Play original video`
  String get play_original_video {
    return Intl.message(
      'Play original video',
      name: 'play_original_video',
      desc: '',
      args: [],
    );
  }

  /// `Play processed video`
  String get play_processed_video {
    return Intl.message(
      'Play processed video',
      name: 'play_processed_video',
      desc: '',
      args: [],
    );
  }

  /// `Video List`
  String get video_list {
    return Intl.message(
      'Video List',
      name: 'video_list',
      desc: '',
      args: [],
    );
  }

  /// `Video {index}`
  String video_index_1(Object index) {
    return Intl.message(
      'Video $index',
      name: 'video_index_1',
      desc: '',
      args: [index],
    );
  }

  /// `File path: {filePath}`
  String file_path_global_video_files_index_file_path(Object filePath) {
    return Intl.message(
      'File path: $filePath',
      name: 'file_path_global_video_files_index_file_path',
      desc: '',
      args: [filePath],
    );
  }

  /// `Upload Time: {uploadTime}`
  String upload_time_global_video_files_index_upload_time(Object uploadTime) {
    return Intl.message(
      'Upload Time: $uploadTime',
      name: 'upload_time_global_video_files_index_upload_time',
      desc: '',
      args: [uploadTime],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
