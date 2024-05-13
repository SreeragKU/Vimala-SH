import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sacred_hearts/users/model/user.dart';
import 'package:sacred_hearts/users/userPreferences/user_preferences.dart';

import '../../api_connection/api_connection.dart';
import '../fragments/dashboard_fragment.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final isObscure = true.obs;
  var isLoading = false.obs;

  Future<void> loginUser() async {
    isLoading(true);
    try {
      final res = await http.post(
        Uri.parse(API.login),
        body: {
          'user_name': userController.text.trim(),
          'user_password': passwordController.text.trim(),
        },
      );

      if (res.statusCode == 200) {
        final resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(msg: "Login successful");
          final userInfo = User.fromJson(resBodyOfLogin["userData"]);
          await RememberUserPrefs.storeUserInfo(userInfo);
          Future.delayed(const Duration(milliseconds: 2000), () {
            Get.to(DashboardFrag());
          });
        } else {
          Fluttertoast.showToast(msg: resBodyOfLogin['message']);
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to login: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: cons.maxHeight),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 150.0, bottom: 10.0, left: 10.0, right: 10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Image.asset("images/sh.png"),
                    ),
                  ),
                  const Text(
                    "Vimala Province,\nKanirappally",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                      fontFamily: 'Cursive',
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: userController,
                                style: const TextStyle(color: Colors.white),
                                validator: (val) => val?.isEmpty ?? true
                                    ? "Please enter your username"
                                    : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  hintText: "Username...",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[700],
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Obx(() => TextFormField(
                                controller: passwordController,
                                style: const TextStyle(color: Colors.white),
                                obscureText: isObscure.value,
                                validator: (val) => val?.isEmpty ?? true
                                    ? "Please enter your password"
                                    : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.vpn_key_sharp,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      isObscure.value = !isObscure.value;
                                    },
                                    child: Icon(
                                      isObscure.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white,
                                    ),
                                  ),
                                  hintText: "Password...",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[700],
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 16,
                                  ),
                                ),
                              )),
                              const SizedBox(
                                height: 18,
                              ),
                              Material(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30),
                                child: InkWell(
                                  onTap: loginUser,
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    alignment: Alignment.center,
                                    child: Obx(() => isLoading.value
                                        ? CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    )
                                        : const Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
