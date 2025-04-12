import 'package:flutter/material.dart';

import '../misc/app_theme.dart';
import '../misc/colors.dart';


class AppButton extends StatelessWidget {
  final Function onTap;
  final bool isOutlined;
  final bool hasIcon;
  final String name;
  final IconData? icon;
  final bool withText;
  final bool isClicked;

  const AppButton({
    super.key,
    required this.onTap,
    this.isOutlined = false,
    this.hasIcon = false,
    required this.name,
    this.withText = false,
    this.icon,
    this.isClicked = false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        // padding: const EdgeInsets.all(2),
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: !isOutlined ? AppColor.mainColor : Colors.white,
            border: Border.all(color: AppColor.mainColor)),
        child: Stack(
          children: [
            Center(
                child: hasIcon
                    ? (withText
                    ? Row(
                  children: [
                    Icon(icon),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      name,
                      style: !isOutlined
                          ? AppTheme.darkTextTheme.headlineMedium
                          : AppTheme.lightTextTheme.headlineMedium,
                    )
                  ],
                )
                    : Icon(icon))
                    : Text(
                  name,
                  style: !isOutlined
                      ? AppTheme.darkTextTheme.headlineMedium
                      : AppTheme.lightTextTheme.headlineMedium,
                )),
            isClicked ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.6)),
                child: const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: AppColor.mainColor,
                    ))) : const SizedBox()
          ],
        ),
      ),
    );
  }
}
