import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BgWidget extends StatelessWidget {
  final Widget child;
  const BgWidget({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [

      Image.asset(
        ResponsiveHelper.isDesktop(context) ? Get.find<ThemeController>().darkTheme ? Images.web_bg_dark : Images.web_bg : Images.phone_bg,
        opacity: AlwaysStoppedAnimation(ResponsiveHelper.isDesktop(context) ? 1 : 0.2), height: context.height, width: context.width, fit: BoxFit.fill,
      ),

      child,

    ]);
  }
}
