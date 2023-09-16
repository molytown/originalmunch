import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/menu_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    double _ratio = ResponsiveHelper.isDesktop(context) ? 1.1 : ResponsiveHelper.isTab(context) ? 1.1 : 1.2;

    final List<MenuModel> _menuList = [
      MenuModel(icon: '', title: 'profile'.tr, color: Theme.of(context).primaryColor, route: RouteHelper.getProfileRoute()),
      MenuModel(icon: Images.location, title: 'my_address'.tr, color: Color(0xFFf5427b), route: RouteHelper.getAddressRoute()),
      MenuModel(icon: Images.language, title: 'language'.tr, color: Color(0xFF009A5F), route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(icon: Images.coupon, title: 'coupon'.tr, color: Color(0xFFD900F1), route: RouteHelper.getCouponRoute(fromCheckout: false)),
      MenuModel(icon: Images.chat, title: 'live_chat'.tr, color: Color(0xFFFFA148), route: RouteHelper.getConversationRoute()),
      MenuModel(icon: Images.telephone, title: 'contact_us'.tr, color: Color(0xFF00C7B2), route: RouteHelper.getSupportRoute()),
      MenuModel(icon: Images.policy, title: 'about_us_and_policies'.tr, color: Color(0xFF6165D7), route: null),
      // MenuModel(icon: Images.about_us, title: 'about_us'.tr, route: RouteHelper.getHtmlRoute('about-us')),
      // MenuModel(icon: Images.terms, title: 'terms_conditions'.tr, route: RouteHelper.getHtmlRoute('terms-and-condition')),
    ];

    if(Get.find<SplashController>().configModel.refEarningStatus == 1 ) {
      _menuList.add(MenuModel(icon: Images.refer_code, title: 'refer'.tr, color: Color(0xFF44FF85), route: RouteHelper.getReferAndEarnRoute()));
    }
    if(Get.find<SplashController>().configModel.customerWalletStatus == 1 ) {
      _menuList.add(MenuModel(icon: Images.wallet, title: 'wallet'.tr, color: Color(0xFF6AB5FF), route: RouteHelper.getWalletRoute(true)));
    }
    if(Get.find<SplashController>().configModel.loyaltyPointStatus == 1 ) {
      _menuList.add(MenuModel(icon: Images.loyal, title: 'loyalty_points'.tr, color: Color(0xFFb3f549), route: RouteHelper.getWalletRoute(false)));
    }
    if(Get.find<SplashController>().configModel.toggleDmRegistration && !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.delivery_man_join, title: 'join_as_a_delivery_man'.tr, color: Color(0xff02924f),
        route: RouteHelper.getDeliverymanRegistrationRoute(),
      ));
    }
    if(Get.find<SplashController>().configModel.toggleRestaurantRegistration && !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.restaurant_join, title: 'join_as_a_restaurant'.tr, color: Color(0xffb327fa),
        route: RouteHelper.getRestaurantRegistrationRoute(),
      ));
    }
    _menuList.add(MenuModel(icon: Images.log_out, color: null, title: _isLoggedIn ? 'logout'.tr : 'sign_in'.tr, route: ''));

    return PointerInterceptor(
      child: Container(
        width: Dimensions.WEB_MAX_WIDTH,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).cardColor,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4,
              childAspectRatio: (1/_ratio),
              crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            itemCount: _menuList.length,
            itemBuilder: (context, index) {
              return MenuButton(menu: _menuList[index], isProfile: index == 0, isLogout: index == _menuList.length-1);
            },
          ),
          SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.PADDING_SIZE_SMALL : 0),

        ]),
      ),
    );
  }
}
