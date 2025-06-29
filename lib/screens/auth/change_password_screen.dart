import 'package:fishpond/misc/colors.dart';
import 'package:fishpond/screens/home.dart';
import 'package:fishpond/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../misc/decorator.dart';
import '../../providers/auth.dart';


class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change-password';

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String _current_password = '';
  String _new_password = '';
  String _new_password_confirmed = '';
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
        .changePassword(_current_password, _new_password, _new_password_confirmed)
        .then((value) {

      if (!value) {

        setState(() {
          _isLoading = false;
          _errorMessage = 'Wrong password!';
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
            flex: 2,
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
                ],
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Change password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),),
                          SizedBox(height: 12,),
                          TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Your current password is required';
                              }
                              return null;
                            },
                            onSaved: (value) => _current_password = value!,
                            style: Decorator.fieldStyle,
                            decoration: Decorator.fieldDecorate("Your password").copyWith(
                                prefixIcon: Icon(Icons.lock)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0, top: 0),
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
                                return 'Enter new password';
                              }
                              return null;
                            },
                            onSaved: (value) => _new_password = value!,
                            style: Decorator.fieldStyle,
                            decoration: Decorator.fieldDecorate("New password").copyWith(
                                prefixIcon: Icon(Icons.lock)
                            ),
                          ),
                          SizedBox(height: 15,),
                          TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm password';
                              }
                              return null;
                            },
                            onSaved: (value) => _new_password_confirmed = value!,
                            style: Decorator.fieldStyle,
                            decoration: Decorator.fieldDecorate("Confirm password").copyWith(
                                prefixIcon: Icon(Icons.lock)
                            ),
                          ),
                          SizedBox(height: 15,),
                          AppButton(
                              onTap: submitLogin,
                              isClicked: _isLoading,
                              name: 'Change Password'
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

