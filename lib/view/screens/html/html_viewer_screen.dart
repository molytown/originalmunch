import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/html_type.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/bg_widget.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewerScreen extends StatefulWidget {
  final HtmlType htmlType;
  HtmlViewerScreen({@required this.htmlType});

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<SplashController>().getHtmlText(widget.htmlType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_conditions'.tr
          : widget.htmlType == HtmlType.ABOUT_US ? 'about_us'.tr : widget.htmlType == HtmlType.PRIVACY_POLICY
          ? 'privacy_policy'.tr : 'no_data_found'.tr),
      body: BgWidget(child: GetBuilder<SplashController>(builder: (splashController) {
        return Align(
          alignment: Alignment.topCenter,
          child: splashController.htmlText != null ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Ink(
              width: Dimensions.WEB_MAX_WIDTH,
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [

                ResponsiveHelper.isDesktop(context) ? Container(
                  height: 50, alignment: Alignment.center, color: Theme.of(context).cardColor, width: Dimensions.WEB_MAX_WIDTH,
                  child: SelectableText(widget.htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_conditions'.tr
                      : widget.htmlType == HtmlType.ABOUT_US ? 'about_us'.tr : widget.htmlType == HtmlType.PRIVACY_POLICY
                      ? 'privacy_policy'.tr : 'no_data_found'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.black),
                  ),
                ) : SizedBox(),

                (splashController.htmlText.contains('<ol>') || splashController.htmlText.contains('<ul>')) ? HtmlWidget(
                  splashController.htmlText ?? '',
                  key: Key(widget.htmlType.toString()),
                  isSelectable: true,
                  onTapUrl: (String url) {
                    return launchUrlString(url, mode: LaunchMode.externalApplication);
                  },
                ) : SelectableHtml(
                  data: splashController.htmlText, shrinkWrap: true,
                  onLinkTap: (String url, RenderContext context, Map<String, String> attributes, element) {
                    if(url.startsWith('www.')) {
                      url = 'https://' + url;
                    }
                    print('Redirect to url: $url');
                    html.window.open(url, "_blank");
                  },
                ),

              ]),
            ),
          ) : CircularProgressIndicator(),
        );
      })),
    );
  }
}