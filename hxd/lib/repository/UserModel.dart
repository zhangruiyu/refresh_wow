//tel        VARCHAR PRIMARY KEY,
//    name       VARCHAR,
//token      VARCHAR,
//    isOnline   VARCHAR,
//nickName   VARCHAR,
//    roleCode   VARCHAR,
//avatar     VARCHAR,
//    gender     VARCHAR,
//address    VARCHAR,
//    relation   VARCHAR,
//ysToken    VARCHAR,
//    schoolName VARCHAR,
//qqOpenId   VARCHAR,
//    wxOpenId   VARCHAR,
//qqNickName VARCHAR,
//    wxNickName VARCHAR

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hxd/core/modules/login/LoginPage.dart';
import 'package:hxd/repository/KindergartenDatabase.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String UserTalbeName = "k_user_table";

final String ID = "id";
final String TEL = "tel";
final String TOKEN = "token";
final String ISONLINE = "isOnline";
final String NICKNAME = "nickName";
final String ROLECODE = "roleCode";
final String AVATAR = "avatar";
final String GENDER = "gender";
final String ADDRESS = "address";
final String RELATION = "relation";
final String YSTOKEN = "ysToken";
final String SCHOOLNAME = "schoolName";
final String QQOPENID = "qqOpenId";
final String WXOPENID = "wxOpenId";
final String QQNICKNAME = "qqNickName";
final String WXNICKNAME = "wxNickName";
final List<String> UserTalbeCloum = [
  ID,
  TEL,
  TOKEN,
  ISONLINE,
  NICKNAME,
  ROLECODE,
  AVATAR,
  GENDER,
  ADDRESS,
  RELATION,
  YSTOKEN,
  SCHOOLNAME,
  QQOPENID,
  WXOPENID,
  QQNICKNAME,
  WXNICKNAME
];
final String userTableSql = '''
              CREATE TABLE 
$UserTalbeName (
                        tel        VARCHAR PRIMARY KEY,
                        id      VARCHAR,
                        token      VARCHAR,
                        isOnline   VARCHAR,
                        nickName   VARCHAR,
                        roleCode   VARCHAR,
                        avatar     VARCHAR,
                        gender     VARCHAR,
                        address    VARCHAR,
                        relation   VARCHAR,
                        ysToken    VARCHAR,
                        schoolName VARCHAR,
                        qqOpenId   VARCHAR,
                        wxOpenId   VARCHAR,
                        qqNickName VARCHAR,
                        wxNickName VARCHAR
                      )
              ''';

class UserModel {
  String id;

  String tel;

  String token;

  String isOnline;

  String nickName;

  String roleCode;

  String avatar;

  String gender;

  String address;

  String relation;

  String ysToken;

  String schoolName;

  String qqOpenId;

  String wxOpenId;

  String qqNickName;

  String wxNickName;

  UserModel({this.id,
    this.tel,
    this.token,
    this.isOnline,
    this.nickName,
    this.roleCode,
    this.avatar,
    this.gender,
    this.address,
    this.relation,
    this.ysToken,
    this.schoolName,
    this.qqOpenId,
    this.wxOpenId,
    this.qqNickName,
    this.wxNickName});

  UserModel.fromMap(Map map) {
    id = map[ID];
    tel = map[TEL];
    token = map[TOKEN];
    isOnline = map[ISONLINE];
    nickName = map[NICKNAME];
    roleCode = map[ROLECODE];
    avatar = map[AVATAR];
    gender = map[GENDER];
    address = map[ADDRESS];
    relation = map[RELATION];
    ysToken = map[YSTOKEN];
    schoolName = map[SCHOOLNAME];
    qqOpenId = map[QQOPENID];
    wxOpenId = map[WXOPENID];
    qqNickName = map[QQNICKNAME];
    wxNickName = map[WXNICKNAME];
  }

  Map toMap() {
    Map map = {};
    if (id != null) {
      map[ID] = id;
    }
    if (tel != null) {
      map[TEL] = tel;
    }
    if (token != null) {
      map[TOKEN] = token;
    }
    if (isOnline != null) {
      map[ISONLINE] = isOnline;
    }
    if (nickName != null) {
      map[NICKNAME] = nickName;
    }
    if (roleCode != null) {
      map[ROLECODE] = roleCode;
    }
    if (avatar != null) {
      map[AVATAR] = avatar;
    }
    if (gender != null) {
      map[GENDER] = gender;
    }
    if (address != null) {
      map[ADDRESS] = address;
    }
    if (relation != null) {
      map[RELATION] = relation;
    }
    if (ysToken != null) {
      map[YSTOKEN] = ysToken;
    }
    if (schoolName != null) {
      map[SCHOOLNAME] = schoolName;
    }
    if (qqOpenId != null) {
      map[QQOPENID] = qqOpenId;
    }
    if (wxOpenId != null) {
      map[WXOPENID] = wxOpenId;
    }
    if (qqNickName != null) {
      map[QQNICKNAME] = qqNickName;
    }
    if (wxNickName != null) {
      map[WXNICKNAME] = wxNickName;
    }
    return map;
  }
}

class UserProvide {
  static UserModel _userCache;

  static Future<UserModel> insert(UserModel user) async {
    Database db = await KindergartenDatabase.openKindergartenDatabase();
    var deleteCode = await db
        .delete(UserTalbeName, where: "$TEL = ?", whereArgs: [user.tel]);
    var code = await db.insert(UserTalbeName, user.toMap());
    db.close();
    return _userCache = user;
  }

  static update() async {
    Database db = await KindergartenDatabase.openKindergartenDatabase();

    await db.update(UserTalbeName, getCacheUser().toMap(),
        where: "$TEL = ?", whereArgs: [getCacheUser().tel]);
    db.close();
  }

  static Future initOnlineUser() async {
    Database db = await KindergartenDatabase.openKindergartenDatabase();
    List<Map> maps = await db.query(UserTalbeName,
        columns: UserTalbeCloum, where: "$ISONLINE = ?", whereArgs: ['1']);
    db.close();
    if (maps.length > 0) {
//      print(maps.last);
      var userModel = new UserModel.fromMap(maps.last);
      _userCache = userModel;
    }
    return _userCache;
  }

  static Future getOnlineUser() async {
    if (_userCache != null) {
      return _userCache;
    }
    Database db = await KindergartenDatabase.openKindergartenDatabase();
    List<Map> maps = await db.query(UserTalbeName,
        columns: UserTalbeCloum, where: "$ISONLINE = ?", whereArgs: ['1']);
    db.close();
    if (maps.length > 0) {
//      print(maps.last);
      var userModel = new UserModel.fromMap(maps.last);
      return _userCache = userModel;
    }

    return null;
  }

  static loginOut() async {
    Database db = await KindergartenDatabase.openKindergartenDatabase();
    await db.delete(UserTalbeName,);
    db.close();
    _userCache = null;
  }


  //更细到内存并写入数据库
  static saveAndUpdate(setUp) {
    setUp();
    update();
  }

  static haveOnlineUser() {
    return _userCache != null;
  }

  static UserModel getCacheUser() {
    return _userCache;
  }

  static loginChecked(context, onSuccessCallback, [props = const {}]) {
    if (haveOnlineUser()) {
      onSuccessCallback();
    } else {
      Navigator.of(context).push(new MaterialPageRoute<bool>(
        builder: (BuildContext context) {
          return new LoginPage(props);
        },
      ));
    }
  }

  //是否是普通人员
  static isNormalPeople() {
    return (UserProvide
        .getCacheUser()
        .roleCode != null &&
        int.parse(UserProvide
            .getCacheUser()
            .roleCode) < 1);
  }
}
