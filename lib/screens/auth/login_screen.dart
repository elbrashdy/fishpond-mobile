import 'package:fishpond/misc/app_theme.dart';
import 'package:fishpond/misc/colors.dart';
import 'package:fishpond/screens/home.dart';
import 'package:fishpond/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../misc/decorator.dart';
import '../../providers/auth.dart';


class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';
  final _formKey =GlobalKey<FormState>();

  submitLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    final result = Provider.of<AuthProvider>(context, listen: false)
        .login(_username, _password)
        .then((value) {

      if (!value) {

        setState(() {
          _isLoading = false;
          _errorMessage = 'Wrong Email/Password';
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    });
  }
  final Color primaryColor = AppColor.mainColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/app_icon.png',
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'AQUACULTURE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
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
                          return 'Enter email address';
                        }
                        return null;
                      },
                      onSaved: (value) => _username = value!,
                      style: Decorator.fieldStyle,
                      decoration: Decorator.fieldDecorate("Your email address").copyWith(
                          prefixIcon: Icon(Icons.email)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1, top: 1),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
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
                      decoration: Decorator.fieldDecorate("Your password").copyWith(
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
            ),
          ),
        ],
      ),
    );
  }
}

