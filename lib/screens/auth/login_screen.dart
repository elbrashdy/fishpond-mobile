import 'package:fishpond/misc/app_theme.dart';
import 'package:fishpond/misc/colors.dart';
import 'package:fishpond/screens/home.dart';
import 'package:fishpond/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../misc/decorator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  final _formKey =GlobalKey<FormState>();

  submitLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: AppColor.mainColor,
          // padding: const EdgeInsets.only(top: 80.0, right: 25, left: 25),
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(bottom: 40, right: 30, left: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(100))
                    ),
                    child: Form(
                      key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 80,),
                            Text("Welcome Back!", style: AppTheme.lightTextTheme.headlineMedium,),
                            SizedBox(height: 15,),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter username';
                                }
                                return null;
                              },
                              onSaved: (value) => _username = value!,
                              style: Decorator.fieldStyle,
                              decoration: Decorator.fieldDecorate("Enter username").copyWith(
                                  prefixIcon: Icon(Icons.account_circle)
                              ),
                            ),
                            SizedBox(height: 15,),
                            TextFormField(
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter password';
                                }
                                return null;
                              },
                              onSaved: (value) => _password = value!,
                              style: Decorator.fieldStyle,
                              decoration: Decorator.fieldDecorate("Enter password").copyWith(
                                  prefixIcon: Icon(Icons.lock)
                              ),
                            ),
                            SizedBox(height: 15,),
                            AppButton(
                                onTap: submitLogin,
                                isClicked: _isLoading,
                                name: 'Login'
                            ),
                          ],
                        )
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
