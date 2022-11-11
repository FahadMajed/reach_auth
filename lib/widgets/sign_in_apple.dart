import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleButton extends ConsumerWidget {
  final Function onTap;
  const AppleButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) => SignInWithAppleButton(
        height: 50,
        borderRadius: radius,
        style: SignInWithAppleButtonStyle.black,
        text: "cont_with_apple".tr,
        onPressed: () => onTap,
      );
}
