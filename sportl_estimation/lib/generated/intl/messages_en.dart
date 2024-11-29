// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(filePath) => "File path: ${filePath}";

  static String m1(imagePath) => "Image selected: ${imagePath}";

  static String m2(videoFilePath) => "Selected video: ${videoFilePath}";

  static String m3(uploadTime) => "Upload Time: ${uploadTime}";

  static String m4(index) => "Video ${index}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_to_video_list":
            MessageLookupByLibrary.simpleMessage("Add to video list"),
        "confirm_password":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "dont_have_an_account_register": MessageLookupByLibrary.simpleMessage(
            "Don\'t have an account? Register"),
        "file_path_global_video_files_index_file_path": m0,
        "forgot_your_password":
            MessageLookupByLibrary.simpleMessage("Forgot your password?"),
        "image_selected_image_path": m1,
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "login_failed_please_check_username_or_password":
            MessageLookupByLibrary.simpleMessage(
                "Login failed, please check username or password"),
        "login_failed_please_try_again": MessageLookupByLibrary.simpleMessage(
            "Login failed, please try again"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwords_need_to_be_at_least_6_characters":
            MessageLookupByLibrary.simpleMessage(
                "Passwords need to be at least 6 characters"),
        "play_original_video":
            MessageLookupByLibrary.simpleMessage("Play original video"),
        "play_processed_video":
            MessageLookupByLibrary.simpleMessage("Play processed video"),
        "please_enter_a_username":
            MessageLookupByLibrary.simpleMessage("Please enter a username"),
        "please_enter_a_valid_email_address":
            MessageLookupByLibrary.simpleMessage(
                "Please enter a valid email address"),
        "please_enter_your_password":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "please_enter_your_password_again":
            MessageLookupByLibrary.simpleMessage(
                "Please enter your password again"),
        "please_enter_your_registered_email_address":
            MessageLookupByLibrary.simpleMessage(
                "Please enter your registered email address"),
        "please_select_a_video_first":
            MessageLookupByLibrary.simpleMessage("Please select a video first"),
        "processing_video":
            MessageLookupByLibrary.simpleMessage("Processing video"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "registration_failed_please_try_again":
            MessageLookupByLibrary.simpleMessage(
                "Registration failed, please try again."),
        "registration_successful":
            MessageLookupByLibrary.simpleMessage("Registration Successful"),
        "select_image": MessageLookupByLibrary.simpleMessage("Select Image"),
        "select_image_from_album":
            MessageLookupByLibrary.simpleMessage("Select image from album"),
        "select_video_from_album":
            MessageLookupByLibrary.simpleMessage("Select video from album"),
        "selected_video_video_filepath": m2,
        "shooting_video":
            MessageLookupByLibrary.simpleMessage("Shooting Video"),
        "the_email_to_reset_your_password_has_been_sent_to_your_mailbox":
            MessageLookupByLibrary.simpleMessage(
                "The email to reset your password has been sent to your mailbox"),
        "the_password_is_too_weak":
            MessageLookupByLibrary.simpleMessage("The password is too weak."),
        "this_mailbox_has_been_registered":
            MessageLookupByLibrary.simpleMessage(
                "This mailbox has been registered."),
        "this_user_was_not_found": MessageLookupByLibrary.simpleMessage(
            "This user was not found, please check the username"),
        "this_user_was_not_found_please_check_your_mailbox":
            MessageLookupByLibrary.simpleMessage(
                "This user was not found, please check your mailbox"),
        "unable_to_send_reset_password_email":
            MessageLookupByLibrary.simpleMessage(
                "Unable to send reset password email"),
        "upload_time_global_video_files_index_upload_time": m3,
        "upload_video": MessageLookupByLibrary.simpleMessage("Upload Video"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "video_details": MessageLookupByLibrary.simpleMessage("Video Details"),
        "video_index_1": m4,
        "video_list": MessageLookupByLibrary.simpleMessage("Video List"),
        "view_video_list":
            MessageLookupByLibrary.simpleMessage("View Video List"),
        "wrong_password_please_reenter": MessageLookupByLibrary.simpleMessage(
            "Wrong password, please re-enter")
      };
}
