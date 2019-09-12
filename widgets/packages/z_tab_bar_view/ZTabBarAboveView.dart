import 'package:flutter/material.dart';
import '../../assets/style/constants.dart';
import './MixinZTabBarAboveViewState.dart';

class ZTabBarAboveView extends StatefulWidget {
  final List<Widget> tabItems;
  final List<Widget> pageItems;

  ZTabBarAboveView({
    Key key,
    this.tabItems,
    this.pageItems
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ZTabBarAboveViewState();
  }
}

class _ZTabBarAboveViewState extends State<ZTabBarAboveView> with MixinZTabBarAboveViewState<ZTabBarAboveView>, SingleTickerProviderStateMixin<ZTabBarAboveView> {
  TabController _tabController;
  PageController _pageController;
  bool isPageCanChanged = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabItems.length, vsync: this);
    _pageController = PageController(initialPage: 0);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        onPageChange(_tabController.index, p: _pageController);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(AppColors.BackgroundColor),
      appBar: TabBar(
        controller: _tabController,
        indicatorColor: indicatorColor,
        labelColor: labelColor,
        labelStyle: labelStyle,
        unselectedLabelColor: unselectedLabelColor,
        unselectedLabelStyle: unselectedLabelStyle,
        tabs: widget.tabItems,
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.tabItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              widget.pageItems[index],
              Container(height: 0.5, decoration: BoxDecoration(boxShadow: [BoxShadow(offset: Offset(0.0, 0.0),color: Color(0xff666666), blurRadius: 2.5)]))
            ],
          );
        },
        onPageChanged: (index) {
          if (isPageCanChanged) onPageChange(index);
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @protected
  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {//判断是哪一个切换
      isPageCanChanged = false;
      _pageController.animateToPage(index, duration: Duration(milliseconds: 10), curve: Curves.ease).then((res) {
        isPageCanChanged = true;
      });
    } else _tabController.animateTo(index);//切换Tabbar
  }
}
