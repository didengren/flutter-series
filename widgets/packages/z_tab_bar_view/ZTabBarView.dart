import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ZTabBarView extends StatefulWidget {
  final TabController tabController;
  final PageController pageController;
  final List<Widget> children;
  final ScrollPhysics physics;
  final DragStartBehavior dragStartBehavior;

  ZTabBarView({
    Key key,
    @required this.children,
    @required this.tabController,
    @required this.pageController,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
  })  : assert(children != null),
        assert(dragStartBehavior != null),
        super(key: key);

  @override
  _ZTabBarViewState createState() => _ZTabBarViewState();
}

class _ZTabBarViewState extends State<ZTabBarView> {

  @override
  Widget build(BuildContext context) {
    return PageView(
      dragStartBehavior: widget.dragStartBehavior,
      physics: widget.physics,
      controller: widget.pageController,
      children: widget.children,
      onPageChanged: (index) {
        widget.tabController.animateTo(index);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.tabController.dispose();
    widget.pageController.dispose();
  }
}
