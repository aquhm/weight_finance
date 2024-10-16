import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_finance/extension/color_extension.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(Duration(microseconds: 100)); // 스플래시 시간 (3초)

    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // 첫 실행인 경우 온보딩 화면으로 이동
      prefs.setBool('isFirstLaunch', false); // 첫 실행 이후 false로 설정
      context.pushReplacement("/onboarding");
    } else {
      // 이후 실행에서는 홈 화면으로 바로 이동
      context.pushReplacement("/home");
    }
  }

  LinearGradient _buildLinearGradient() {
    return LinearGradient(
        colors: [HexColor.fromHex('#fffbd5'), HexColor.fromHex('#b20a2c')], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: _buildLinearGradient(),
            ),
          ),

          //로고 및 애니메이션
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/holidays.png",
                  height: 200,
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Finance App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                //CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
