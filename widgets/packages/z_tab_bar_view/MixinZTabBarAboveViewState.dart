import 'package:flutter/material.dart';

mixin MixinZTabBarAboveViewState<ZTabBarAboveView extends StatefulWidget> on State<ZTabBarAboveView> {
  Color indicatorColor;
  Color labelColor;
  Color unselectedLabelColor;
  TextStyle labelStyle;
  TextStyle unselectedLabelStyle;

  @override
  void initState() {
    super.initState();
    indicatorColor = Color(0xff008CD7);
    labelColor = Color(0xff008CD7);
    unselectedLabelColor = Color(0xff303030);
    labelStyle = TextStyle(
        fontWeight: FontWeight.bold
    );
    unselectedLabelStyle = TextStyle(
        fontWeight: FontWeight.normal
    );
  }
}
