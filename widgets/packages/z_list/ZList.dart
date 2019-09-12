/// 通用列表刷新和加载控件
/// Created by Sam Xu
/// Date: 2019-02-02

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ZListController {
  List dataList = new List();
  bool needLoadMore = true;
}

class ZList extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder; // item控件的builder
  final RefreshCallback onRefresh; // 下拉刷新事件的callback
  final RefreshCallback onLoadMore; // 加载更多事件的callback
  final Key refreshKey;
  final ZListController control; // 列表控件配置选项
  
  ZList(this.control, {this.itemBuilder, this.onRefresh, this.onLoadMore, this.refreshKey});
  
  @override
  _ZListState createState() {
    // TODO: implement createState
    return _ZListState(this.control, this.itemBuilder, this.onRefresh, this.onLoadMore, this.refreshKey);
  }
}

class _ZListState extends State<ZList> {
  final IndexedWidgetBuilder itemBuilder; // item控件的builder
  final RefreshCallback onRefresh; // 下拉刷新事件的callback
  final RefreshCallback onLoadMore; // 加载更多事件的callback
  final Key refreshKey;
  final ZListController control;
  final ScrollController _scrollController = ScrollController();

  _ZListState(this.control, this.itemBuilder, this.onRefresh, this.onLoadMore, this.refreshKey);

  _getListCount() {
    if (control.dataList.length == 0) {
      return 1;
    }
    return (control.dataList.length > 0) ? control.dataList.length + 1 : control.dataList.length;
  }

  _getItem(int index) {
    if (index == control.dataList.length && control.dataList.length != 0 || index == _getListCount() - 1 && control.dataList.length != 0) {
      if (_scrollController.position.pixels == 0.0) {
        control.needLoadMore = false;
      }
      return _buildProgressIndicator();
    } else if (control.dataList.length == 0) {
      Future.delayed(Duration(milliseconds: 2000), () {_buildEmpty();});
    } else {
      return itemBuilder(context, index);
    }
  }

  Widget _buildProgressIndicator() {
    Widget _bottomWidget = (control.needLoadMore) ?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitRing(
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
            Container(width: 5.0,),
            Text(
              '正在加载更多',
              style: TextStyle(
                color: Color(0xff121917),
                fontSize: 14.0,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ) :
        Container();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: _bottomWidget,
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Text('暂无数据', textAlign: TextAlign.center, style: TextStyle(
          fontSize: 18.0
      ))
    );
  }

  @protected
  void scrollCallback() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && this.control.needLoadMore) {
      this.onLoadMore?.call();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollCallback);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _getItem(index);
          },
          itemCount: _getListCount(),
          controller: _scrollController,
        ),
        onRefresh: onRefresh,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollCallback);
    super.dispose();
  }
}
