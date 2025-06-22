import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../misc/app_theme.dart';
import 'circle_image.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {

  String name = 'User';
  String email = 'Email';

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uName = sharedPreferences.getString('name');
    String? uEmail = sharedPreferences.getString('email');

    setState(() {
      name = uName!;
      email = uEmail!;
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleImage(
          hasText: true,
          letter: name,
          imageRadius: 30,
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppTheme.lightTextTheme.headlineMedium,
            ),
            Text(
              email,
              style: AppTheme.lightTextTheme.headlineSmall,
            )
          ],
        )
      ],
    );
  }
}
