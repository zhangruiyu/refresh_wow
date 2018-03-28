import 'dart:async';

import 'package:hxd/net/NetWork.dart';

const USER_URL = "/user/normal";
const TEACHER_URL = "/user/teacher";

class RequestHelper {
  static login(String tel, String password) {
    return RequestClient
        .request('/public/auth/login', {'tel': tel, 'password': password});
  }

  static verifyIsRegister(String tel) {
    return RequestClient.request('/public/verifyIsRegister', {'tel': tel});
  }

  static Future getAccountProfile() {
    return RequestClient.request("$USER_URL/profile");
  }

  static Future getHomepage() {
    return RequestClient.request("/canUserToken/getBanner");
  }

  static Future getDynamics(int pageIndex) {
    return RequestClient.request("$USER_URL/dynamic/list", {
      'page_index': pageIndex.toString(),
      'dynamic_type': '1',
      'page_size': '5'
    });
  }

  static Future getSchoolAlbum() {
    return RequestClient.request(
      "$USER_URL/album/schoolAlbum",
    );
  }

  static Future getInforms(int pageIndex) {
    return RequestClient.request("$USER_URL/messageList/schoolMessage",
        {'page_index': pageIndex.toString()});
  }

  static Future getSchoolMessage(int pageIndex) {
    return RequestClient.request("$USER_URL/messageList/classroomMessage",
        {'page_index': pageIndex.toString()});
  }

  static Future commitSchoolMessage(String message) {
    return RequestClient.request("$TEACHER_URL/messageList/addClassroomMessage",
        {'message': message.toString()});
  }

  static Future getCameraList() {
    return RequestClient.request("$USER_URL/ys/classroom/list");
  }

  static Future commitDynamicComment(String commentContent, String dynamicId,
      String parentCommentId, String groupTag) {
    return RequestClient.request("$USER_URL/dynamic/commitComment", {
      'commentContent': commentContent.toString(),
      'dynamicId': dynamicId.toString(),
      'parentCommentId': parentCommentId.toString(),
      'groupTag': groupTag.toString()
    });
  }

  static Future commitDynamicLiked(String dynamicId) {
    return RequestClient
        .request("$USER_URL/dynamic/commitLiked", {'dynamicId': dynamicId});
  }

  static Future reviseProfile(
      int checkGender, int relationCheck, String address, String avatarUrl) {
    return RequestClient.request("$USER_URL/reviseProfile", {
      'checkGender': checkGender.toString(),
      'relationCheck': relationCheck.toString(),
      'address': address.toString(),
      'avatarUrl': avatarUrl.toString(),
    });
  }
}
