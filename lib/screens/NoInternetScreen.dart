import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../utils/Common.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        checkInternet().then((intenet) {
          // ignore: unnecessary_null_comparison
          if (intenet != null && intenet) {
            finish(context);
          } else {
            finish(context);
            finish(context);
          }
        });
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              alignment: Alignment.center,
              color: context.cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('No Internet Connection', style: secondaryTextStyle()),
                ],
              ),
            ),
            Text('waiting for internet to connect', style: secondaryTextStyle(size: 12)).paddingBottom(8),
          ],
        ),
      ),
    );
  }
}
