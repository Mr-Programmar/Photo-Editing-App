import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../screens/DashboardScreen.dart';
import 'home_screen_2.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
    await 8.seconds.delay;
    HomeScreen2().launch(context, isNewTask: true);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset('images/app_logo.png', height: 120).center(),
    );
  }
}
