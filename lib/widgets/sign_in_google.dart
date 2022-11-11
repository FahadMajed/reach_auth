import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class GoogleButton extends ConsumerWidget {
  final Function onTap;

  const GoogleButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) => GestureDetector(
        onTap: () {
          onTap.call();
        },
        child: Container(
          height: 55,
          decoration:
              BoxDecoration(color: Colors.white, borderRadius: radius, border: Border.all(color: darkBlue, width: 0.5)),
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
