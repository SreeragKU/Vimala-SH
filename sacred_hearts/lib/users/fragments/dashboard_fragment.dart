import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sacred_hearts/users/authentication/login_screen.dart';
import 'package:sacred_hearts/users/fragments/home_fragment.dart';
import 'package:sacred_hearts/users/fragments/members_fragment.dart';
import 'package:sacred_hearts/users/userPreferences/current_user.dart';
import 'package:sacred_hearts/users/userPreferences/user_preferences.dart';

class DashboardFrag extends StatelessWidget {
  signOutUser() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[300],
        title: const Text(
          "Sign Out",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: "loggedOut");
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
    if (resultResponse == "loggedOut") {
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(const LoginScreen());
      });
    }
  }

  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
  final List<Widget> _fragmentScreens = [
    const HomeScreen(),
    MemberScreen(),
  ];

  final List _navigationProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.people,
      "non_active_icon": Icons.people_alt_outlined,
      "label": "Members",
    },
  ];

  final RxInt _indexNumber = 0.obs;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56.0),
            child: AppBar(
              title: Image.asset('images/sh.png', height: 120, width: 180),
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              actions: [
                const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.red),
                  onPressed: () {
                    signOutUser();
                  },
                ),
              ],
            ),
          ),
          body: SafeArea(child: Obx(() => _fragmentScreens[_indexNumber.value])),
          bottomNavigationBar: Obx(
                () => BottomNavigationBar(
              currentIndex: _indexNumber.value,
              onTap: (value) {
                _indexNumber.value = value;
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white24,
              backgroundColor: Colors.black,
              items: List.generate(2, (index) {
                var navBtnProps = _navigationProperties[index];
                return BottomNavigationBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(navBtnProps["non_active_icon"]),
                  activeIcon: Icon(navBtnProps["active_icon"]),
                  label: navBtnProps["label"],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
