import 'package:flutter/material.dart';
//import 'package:weight_finance/global/bloc/global_deposit/global_deposit_bloc.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/global_bloc_provider.dart';
import 'routes.dart';

void main() async {
  // [WidgetsFlutterBinding 초기화]
  WidgetsFlutterBinding.ensureInitialized();

  await GlobalAPI.init();

  runApp(MyApp());

  GlobalAPI.logger.d("main()");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    GlobalAPI.logger.d("App is initState");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    GlobalAPI.logger.d("App is dispose");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    GlobalAPI.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 전환될 때 데이터 클리어
      GlobalAPI.logger.d("App is paused");
    } else if (state == AppLifecycleState.detached) {
      // 앱이 종료될 준비가 되었을 때 데이터 클리어
      GlobalAPI.logger.d("App is detached");
      // 모델 데이터 클리어 작업 수행
      GlobalAPI.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalBlocProviders(
      child: MaterialApp.router(
        title: 'Financial Info App',
        theme: ThemeData(
          fontFamily: "NotoSansCJKkr",
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData.dark(),
        routerConfig: AppPages.router,
      ),
    );
  }
}
