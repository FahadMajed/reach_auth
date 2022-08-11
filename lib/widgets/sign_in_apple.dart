import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/utils.dart';
import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleButton extends ConsumerWidget {
  final AuthAction authAction;
  const AppleButton({
    Key? key,
    required this.authAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) => SignInWithAppleButton(
        height: 50,
        borderRadius: radius,
        style: SignInWithAppleButtonStyle.black,
        text: "cont_with_apple".tr,
        onPressed: () async {
          switch (authAction) {
            case AuthAction.signIn:
              return await ref.read(userPvdr.notifier).signIn(
                    AuthMethod.apple,
                  );
            case AuthAction.register:
              return await ref.read(userPvdr.notifier).createAccount(
                    AuthMethod.apple,
                  );
            case AuthAction.convert:
              return await ref
                  .read(userPvdr.notifier)
                  .convert(AuthMethod.apple);
          }
        },
      );
}
