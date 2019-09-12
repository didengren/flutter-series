/// 通用APP骨架 - 带有AppBar和bottomNavigationBar、TabBar
/// Created by Sam Xu
/// Date: 2019-02-11

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../assets/style/constants.dart';
import '../../utils/common_utils.dart';
// import 'package:trina_family/utils/ios_navigator.dart';
import '../z_tab_bar_view/ZTabBarView.dart';

class ZFirstScaffold extends StatefulWidget {
  final Color backgroundColor;
  final Widget title;
  final List<Widget> tabViews;
  final List<Widget> tabItems;
  final Color indicatorColor;
  final List<Widget> actions;

  ZFirstScaffold({
    Key key,
    this.backgroundColor,
    this.title,
    this.tabViews,
    this.tabItems,
    this.indicatorColor,
    this.actions
  }) : super(key: key);

  @override
  _ZFirstScaffoldState createState() {
    // TODO: implement createState
    return _ZFirstScaffoldState(
      backgroundColor,
      title,
      tabViews,
      indicatorColor
    );
  }
}

class _ZFirstScaffoldState extends State<ZFirstScaffold> with SingleTickerProviderStateMixin {
  final Color _backgroundColor;
  final Widget _title;
  final List<Widget> _tabViews;
  final Color _indicatorColor;
  PageController _pageController;
  TabController _tabController;

  _ZFirstScaffoldState(
      _backgroundColor,
      this._title,
      this._tabViews,
      this._indicatorColor
      )
      : _backgroundColor = _backgroundColor ?? Color(AppColors.BackgroundColor),
        super();

  @override
  void initState() {
    super.initState();
//    print('\n-- ZFirstScaffold.dart initState -\n\r');
    _tabController = TabController(length: widget.tabItems.length, vsync: this);
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
//    print('\n-- ZFirstScaffold.dart didChangeDependencies -\n\r');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
//    print('\n-- ZFirstScaffold.dart build -\n\r');
    // TODO: implement build
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: _title,
        centerTitle: true,
        leading: CommonUtils.goBackButton(context, onPressed: () {
          // if (Platform.isAndroid) {
          //   SystemNavigator.pop();
          // } else if (Platform.isIOS) {
          //   IosNavigator.pop();
          // }
          SystemNavigator.pop();
        }),
        actions: widget.actions,
      ),
      body: SafeArea(
        child: ZTabBarView(
          pageController: _pageController,
          tabController: _tabController,
          children: _tabViews,
        ),
      ),
//      body: TabBarView(
//        controller: _tabController,
//        children: _tabViews,
//      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          controller: _tabController,
          tabs: widget.tabItems,
          indicatorColor: _indicatorColor,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('\n-- ZFirstScaffold.dart dispose -\n\r');
    _tabController.dispose();
    super.dispose();
  }
}
