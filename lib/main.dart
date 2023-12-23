import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:swap_life/friends/AlertFriendDialog.dart';
import 'package:swap_life/kakao_login/firebase_options.dart';
import 'package:swap_life/kakao_login/myhompage.dart';
import 'dart:core';
import 'MyProfile.dart';
import 'TodoScreen.dart';
import 'package:swap_life/friends/dynamicLink.dart';
import 'package:swap_life/Body/friendBody.dart';
import 'package:swap_life/MBTI/myMBTIreport.dart';


void main() async{
  KakaoSdk.init(
      nativeAppKey: 'e7a7bba0f8d93f336d1343d3f47222ae',
      javaScriptAppKey: 'dc58af574c1d9b2e8e2a27485a830ecf14f59171');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options : DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

//MyApp class 예선 작성//
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DynamicLink(context).initDynamicLink(context);
    return MaterialApp(
      title: 'Swap Life',
      theme: ThemeData(primaryColor: Colors.blueGrey[200]),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/myHome': (context) => MyHome(),
        '/myProfile' : (context) => MyProfile(),
        '/todoScreen': (context) => TodoScreen(),
        '/alert_dialog': (context) => AlertFriendDialog(),
        '/myMBTIreport' : (context) => myMBTIreport(),
        //'/friendScreen': (context) => FriendPage(friendChecklist: friendChecklist),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

//MyHome, _MyHomeState class 예선 작성//
class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    //앱 초기 실행시 프로필로 바꿨을 때 tabcontroller도 바꿔줌(예원)
      _tabController = TabController(length: 3, vsync: this);
      _tabController!.index = 2;
      _tabController!.addListener(() {
        setState(() {
          _selectedIndex = _tabController!.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    if(_selectedIndex==0) {
      //추후 친구 chech list받아오는 함수 연결
      bodyWidget = friendBody(friendChecklist: [], friendName: '', friendid: '',);
      //bodyWidget = FriendPage(friendChecklist: [], friendName: '');
    } else if(_selectedIndex == 1) {
      bodyWidget = TodoScreen();
    } else {
      bodyWidget = MyProfile();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/alert_dialog');
            },icon: Icon(Icons.add_alert, color: Colors.black,)),
        iconTheme: IconThemeData(color: Colors.deepPurple),
        title: Text("Swap Life"),
        centerTitle: true,
        backgroundColor:Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: bodyWidget,
      bottomNavigationBar: BottomNavBar(
        tabController: _tabController!,
        selectedIndex: _selectedIndex,
        onTabTapped: (index) {
          setState(() {
            _selectedIndex = index;
            _tabController!.index = index;
          });
        },
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final TabController tabController;
  final int selectedIndex;
  final Function(int) onTabTapped;
  BottomNavBar({required this.tabController, required this.selectedIndex, required this.onTabTapped,});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: Colors.deepPurple,
      labelColor: Colors.black,
      overlayColor: MaterialStatePropertyAll(Colors.white70),
      controller: tabController,
      tabs: <Tab>[
        Tab(
          icon: Icon(
            selectedIndex == 0
                ? Icons.swap_horizontal_circle
                : Icons.swap_horizontal_circle_outlined,
            color: Colors.deepPurple,
          ),
          text: "Friend",
        ),
        Tab(
          icon: Icon(
            selectedIndex == 1 ? Icons.home : Icons.home_outlined,
            color: Colors.deepPurple,
          ),
          text: "Home",
        ),
        Tab(
          icon: Icon(
            selectedIndex == 2 ? Icons.person : Icons.person_outline,
            color: Colors.deepPurple,
          ),
          text: "Profile",
        ),
      ],
    );
  }
}