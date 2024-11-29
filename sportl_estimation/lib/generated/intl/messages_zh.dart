// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(filePath) => "文件路径: ${filePath}";

  static String m1(imagePath) => "已选择图片: ${imagePath}";

  static String m2(videoFilePath) => "已选择视频: ${videoFilePath}";

  static String m3(uploadTime) => "上传时间: ${uploadTime}";

  static String m4(index) => "视频 ${index}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_to_video_list": MessageLookupByLibrary.simpleMessage("添加到视频列表"),
        "confirm_password": MessageLookupByLibrary.simpleMessage("确认密码"),
        "dont_have_an_account_register":
            MessageLookupByLibrary.simpleMessage("没有账号？注册"),
        "file_path_global_video_files_index_file_path": m0,
        "forgot_your_password": MessageLookupByLibrary.simpleMessage("忘记密码？"),
        "image_selected_image_path": m1,
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "login_failed_please_check_username_or_password":
            MessageLookupByLibrary.simpleMessage("登录失败，请检查用户名或密码"),
        "login_failed_please_try_again":
            MessageLookupByLibrary.simpleMessage("登录失败，请重试"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "passwords_need_to_be_at_least_6_characters":
            MessageLookupByLibrary.simpleMessage("密码至少需要6个字符"),
        "play_original_video": MessageLookupByLibrary.simpleMessage("播放原始视频"),
        "play_processed_video":
            MessageLookupByLibrary.simpleMessage("播放处理后的视频"),
        "please_enter_a_username":
            MessageLookupByLibrary.simpleMessage("请输入用户名"),
        "please_enter_a_valid_email_address":
            MessageLookupByLibrary.simpleMessage("请输入有效的电子邮件地址"),
        "please_enter_your_password":
            MessageLookupByLibrary.simpleMessage("请输入密码"),
        "please_enter_your_password_again":
            MessageLookupByLibrary.simpleMessage("请再次输入密码"),
        "please_enter_your_registered_email_address":
            MessageLookupByLibrary.simpleMessage("请输入您的注册邮箱"),
        "please_select_a_video_first":
            MessageLookupByLibrary.simpleMessage("请先选择一个视频"),
        "processing_video": MessageLookupByLibrary.simpleMessage("处理视频"),
        "register": MessageLookupByLibrary.simpleMessage("注册"),
        "registration_failed_please_try_again":
            MessageLookupByLibrary.simpleMessage("注册失败，请重试。"),
        "registration_successful": MessageLookupByLibrary.simpleMessage("注册成功"),
        "select_image": MessageLookupByLibrary.simpleMessage("选择图片"),
        "select_image_from_album":
            MessageLookupByLibrary.simpleMessage("从相册选择图片"),
        "select_video_from_album":
            MessageLookupByLibrary.simpleMessage("从相册选择视频"),
        "selected_video_video_filepath": m2,
        "shooting_video": MessageLookupByLibrary.simpleMessage("拍摄视频"),
        "the_email_to_reset_your_password_has_been_sent_to_your_mailbox":
            MessageLookupByLibrary.simpleMessage("重置密码的邮件已发送到您的邮箱"),
        "the_password_is_too_weak":
            MessageLookupByLibrary.simpleMessage("密码太弱了。"),
        "this_mailbox_has_been_registered":
            MessageLookupByLibrary.simpleMessage("此邮箱已被注册。"),
        "this_user_was_not_found":
            MessageLookupByLibrary.simpleMessage("用户没找到，请检查用户名"),
        "this_user_was_not_found_please_check_your_mailbox":
            MessageLookupByLibrary.simpleMessage("未找到此用户，请检查邮箱"),
        "unable_to_send_reset_password_email":
            MessageLookupByLibrary.simpleMessage("无法发送重置密码邮件"),
        "upload_time_global_video_files_index_upload_time": m3,
        "upload_video": MessageLookupByLibrary.simpleMessage("上传视频"),
        "username": MessageLookupByLibrary.simpleMessage("用户名"),
        "video_details": MessageLookupByLibrary.simpleMessage("视频详情"),
        "video_index_1": m4,
        "video_list": MessageLookupByLibrary.simpleMessage("视频列表"),
        "view_video_list": MessageLookupByLibrary.simpleMessage("查看视频列表"),
        "wrong_password_please_reenter":
            MessageLookupByLibrary.simpleMessage("密码错误，请重新输入")
      };
}
