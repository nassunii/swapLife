//김진영 작성//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'login.dart';
import 'package:swap_life/kakao_login/mainview.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              //login 안 된 상태
              if(!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 2),
                    Container(
                      //decoration: BoxDecoration(border: Border.all()),
                      child: Image.asset("assets/swap_life_nukki.png", scale: 3),
                    ),
                    Spacer(flex: 2),
                    InkWell(
                      onTap: () async {
                        await viewModel.login();
                        setState(() {});
                    },
                      child: Container(
                        child: Image.asset('assets/kakao_login_pic.png'),
                    ),
                  ),
                    Spacer(flex: 1),
                    Container(
                        child: Text("선녕원"),
                    ),
                    Container(
                      child: Text("version 1.0.0"),
                    ),
                  ]
                );
              }
              return MyHome();
            }
        ),
      ),
    );
  }
}