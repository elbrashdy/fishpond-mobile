import 'package:fishpond/providers/auth.dart';
import 'package:fishpond/screens/auth/login_screen.dart';
import 'package:fishpond/widgets/row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../misc/app_theme.dart';
import '../misc/colors.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 35),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              const ProfileCard(),
              const SizedBox(
                height: 20,
              ),
              ProfileScreenSeparedItem(
                  onTap: () {},
                  icon: Icons.lock_outline,
                  routename: '',
                  text: 'Password'),

              const SizedBox(
                height: 5,
              ),

              ProfileScreenSeparedItem(
                  onTap: () => null,
                  icon: Icons.g_translate,
                  text: "Language  ",
                  routename: "routename"),
              ProfileScreenSeparedItem(
                  onTap: () => null,
                  icon: Icons.help_outline,
                  text: "Help",
                  routename: "routename"),

              const SizedBox(
                height: 10,
              ),
              RowWidget(widgetList: [
                TextButton(
                    onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout().then(
                        (value) {
                          if(value) {
                            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                          }
                        }
                    ),
                    child: Text(
                      'Logout',
                      style: AppTheme.lightTextTheme.headlineMedium,
                    ))
              ])
            ],
          ),
    );
  }
}


class ProfileScreenSeparedItem extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String text;
  final String routename;
  const ProfileScreenSeparedItem(
      {required this.onTap,
        required this.icon,
        required this.text,
        required this.routename,
        super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: SizedBox(
        height: 45,
        child: RowWidget(widgetList: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColor.lightlyGreyColor,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(
                text,
                style: AppTheme.lightTextTheme.bodySmall,
              )
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColor.lightlyGreyColor,
          )
        ]),
      ),
    );
  }
}

