import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';

class GoogleButton extends ConsumerWidget {
  final AuthAction authAction;

  const GoogleButton({
    Key? key,
    required this.authAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) => GestureDetector(
        onTap: () async {
          switch (authAction) {
            case AuthAction.signIn:
              return await ref.read(userPvdr.notifier).signIn(
                    AuthMethod.google,
                  );
            case AuthAction.register:
              return await ref.read(userPvdr.notifier).createAccount(
                    AuthMethod.google,
                  );
            case AuthAction.convert:
              return await ref
                  .read(userPvdr.notifier)
                  .convert(AuthMethod.google);
          }
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radius,
              border: Border.all(color: darkBlue, width: 0.5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AssetImageContainer(
                image: "g.png",
                width: 22,
                height: 22,
                borderless: true,
              ),
              Text('cont_with_google'.tr, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
}
