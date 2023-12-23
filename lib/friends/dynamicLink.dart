import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'AddFriend.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

//전체 class 예원 구현
class DynamicLink {
  late BuildContext context;
  bool isDynamicLinkListenerInitialized = false;

  DynamicLink(BuildContext context) {
    this.context = context;
    initDynamicLink(context);
  }

  Future<Uri> buildDynamicLink(String friendid) async {
    final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse(
            'https://swapllife.page.link/friends?friendid=${friendid}'),
        uriPrefix: 'https://swapllife.page.link',
        androidParameters: AndroidParameters(
            packageName: "com.example.swap_life")
    );


    Uri dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
        dynamicLinkParams);
    return dynamicLink;
  }

  Future<Uri?> initDynamicLink(context) async {
    Uri? deepLink;
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks
        .instance.getInitialLink();
    if (initialLink != null) {
      deepLink = initialLink.link;
      //Navigator.push(context, MaterialPageRoute(builder: (context) => FriendPage(controller: controller)));
    }
    //다이나믹 링크로 앱이 열릴 때 리스너
    FirebaseDynamicLinks.instance.onLink.listen(
            (PendingDynamicLinkData? Dynamiclink) async {
          if (Dynamiclink != null) {
            deepLink = Dynamiclink.link;
            //print('다이나믹 링크로 열림');
            String? friendid = deepLink!.queryParameters['friendid'];
            kakao.User? user = await kakao.UserApi.instance.me();
            //print('다이나믹 링크로 열린 후, userid ${friendid}');
            print('===================');
            FriendListManager().addFriendList(
                context, friendid!, user.id.toString());
          }
        });
  }
}

