import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class RememberUserPrefs
{
  static Future<void> storeUserInfo(User userInfo) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userJson = jsonEncode(userInfo.toJson());
    await prefs.setString('currentUser', userJson);
  }

  static Future<User?> readUserInfo() async {
    User? currentUserInfo;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfo = prefs.getString('currentUser');
    if(userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDataMap);
    }
    return currentUserInfo;
  }

  static Future<void> removeUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }

  Future<bool> checkUserPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfo = prefs.getString('currentUser');
    if (userInfo != null) {
      Map<String, dynamic> userData = jsonDecode(userInfo);
      // Check if user has the required log_id and user_name
      return userData['log_id'] == '81' && userData['user_name'] == 'vimalaprovincepodimattom';
    }
    return false;
  }
}