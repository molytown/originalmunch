import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/social_log_in_body.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/bg_widget.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromSocialLogin;
  final bool fromOtpLogin;
  final SocialLogInBody socialLogInBody;
  ForgetPassScreen({@required this.fromSocialLogin, @required this.socialLogInBody, @required this.fromOtpLogin});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _numberController = TextEditingController();
  String _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).dialCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.fromSocialLogin ? 'phone'.tr : 'forgot_password'.tr),
      body: SafeArea(child: BgWidget(child: Center(child: Scrollbar(child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Center(child: Container(
          width: context.width > 700 ? 700 : context.width,
          padding: context.width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
          decoration: context.width > 700 ? BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
          ) : null,
          child: Column(children: [

            widget.fromOtpLogin ? Column(children: [
              Image.asset(Images.logo, width: 150),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              Text('sign_in'.tr.toUpperCase(), style: robotoBlack.copyWith(fontSize: 30)),
              SizedBox(height: 50),
            ]) : Image.asset(Images.forgot, height: 220),

            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                widget.fromOtpLogin ? 'please_enter_number_for_otp'.tr : widget.fromSocialLogin ? 'please_enter_mobile'.tr : 'please_enter_email'.tr,
                style: robotoRegular, textAlign: TextAlign.center,
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                color: Theme.of(context).cardColor,
              ),
              child: Row(children: [
                (widget.fromSocialLogin || widget.fromOtpLogin) ? CodePickerWidget(
                  onChanged: (CountryCode countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  initialSelection: CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).code,
                  favorite: [CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).code],
                  showDropDownButton: true,
                  padding: EdgeInsets.zero,
                  showFlagMain: true,
                  dialogBackgroundColor: Theme.of(context).cardColor,
                  textStyle: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge.color,
                  ),
                ) : SizedBox(),
                Expanded(child: CustomTextField(
                  controller: _numberController,
                  inputType: (widget.fromSocialLogin || widget.fromOtpLogin) ? TextInputType.phone : TextInputType.emailAddress,
                  inputAction: TextInputAction.done,
                  hintText: (widget.fromSocialLogin || widget.fromOtpLogin) ? 'phone'.tr : 'email'.tr,
                  onSubmit: (text) => GetPlatform.isWeb ? _forgetPass(_countryDialCode) : null,
                )),
              ]),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            GetBuilder<AuthController>(builder: (authController) {
              return !authController.isLoading ? CustomButton(
                buttonText: 'next'.tr,
                onPressed: () => _forgetPass(_countryDialCode),
              ) : Center(child: CircularProgressIndicator());
            }),

          ]),
        )),
      ))))),
    );
  }

  void _forgetPass(String countryCode) async {
    String _phone = _numberController.text.trim();

    String _numberWithCountryCode = ((widget.fromSocialLogin || widget.fromOtpLogin) ? countryCode : '') + _phone;
    bool _isValid = (GetPlatform.isWeb && !(widget.fromSocialLogin || widget.fromOtpLogin)) ? true : false;
    if(!GetPlatform.isWeb && (widget.fromSocialLogin || widget.fromOtpLogin)) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode = '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }else if(!(widget.fromSocialLogin || widget.fromOtpLogin)) {
      _isValid = GetUtils.isEmail(_phone);
    }

    if (_phone.isEmpty) {
      showCustomSnackBar((widget.fromSocialLogin || widget.fromOtpLogin) ? 'enter_phone_number'.tr : 'enter_email_address'.tr);
    }else if (!_isValid) {
      showCustomSnackBar((widget.fromSocialLogin || widget.fromOtpLogin) ? 'invalid_phone_number'.tr : 'enter_a_valid_email_address'.tr);
    }else {
      if(widget.fromOtpLogin) {
        Get.find<AuthController>().loginWithOtp(_numberWithCountryCode, '');
      }else if(widget.fromSocialLogin) {
        widget.socialLogInBody.phone = _numberWithCountryCode;
        Get.find<AuthController>().registerWithSocialMedia(widget.socialLogInBody);
      }else {
        Get.find<AuthController>().forgetPassword(_numberWithCountryCode).then((status) async {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode, '', RouteHelper.forgotPassword, ''));
          }else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }
  }
}
