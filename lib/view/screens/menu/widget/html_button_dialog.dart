import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/html_type.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class HtmlButtonDialog extends StatelessWidget {
  const HtmlButtonDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<HtmlType> _pages = [HtmlType.PRIVACY_POLICY, HtmlType.TERMS_AND_CONDITION, HtmlType.ABOUT_US];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(width: 500, child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1/1,
              mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL, crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
            ),
            itemCount: _pages.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.back();
                  if(_pages[index] == HtmlType.PRIVACY_POLICY) {
                    Get.toNamed(RouteHelper.getHtmlRoute('privacy-policy'));
                  }else if(_pages[index] == HtmlType.TERMS_AND_CONDITION) {
                    Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition'));
                  }else {
                    Get.toNamed(RouteHelper.getHtmlRoute('about-us'));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _pages[index] == HtmlType.PRIVACY_POLICY ? 'privacy_policy'.tr : _pages[index]
                        == HtmlType.TERMS_AND_CONDITION ? 'terms_conditions'.tr : 'about_us'.tr,
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        )),
      ),
    );
  }
}
