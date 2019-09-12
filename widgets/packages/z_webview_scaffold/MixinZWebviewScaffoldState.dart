import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:trina_family/utils/video_record_plugin.dart';
import '../z_toast/ZToast.dart';

mixin MixinZWebviewScaffoldState<T extends StatefulWidget> on State<T> {

  static const int MAXSIZE = 1024 * 1024 * 10;

  /// [intent] 调相机、录像还是相册
  /// [sec] 录制视频的时长
  Future cameraService(String intent, {int sec}) async {
    File _res;
    List<int> _enc;
    switch(intent) {
      case 'camera':
        _res = await takeFromCamera();
        break;
      case 'video':
        if(sec == null) _res = await takeFromVideo();
        else _res = await takeFromVideo(sec: sec);
        break;
      case 'gallery':
        _res = await takeFromGallery();
        break;
      default:
        break;
    }
    _enc = await _res.readAsBytes();
    if (_enc.length > MAXSIZE) {
      Toast.toast(context, '内容大小不得超过10M');
    }
    else return _res;
  }

  /// 相机
  Future<File> takeFromCamera() async {
    return await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 20);
  }

  /// 录像
  // Future<File> takeFromVideo({int sec = 30}) async {
  //   print('sec______$sec');
  //   Map<String, dynamic> _map = await VideoRecordPlugin.startRecord(sec);
  //   File _video = File(_map['video']);
  //   return _video;
  // }

  /// 相册
  Future<File> takeFromGallery() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  @override
  void initState() {
//    print('\n- general_state.dart initState -\n\r');
    super.initState();
  }

  @override
  void didChangeDependencies() {
//    print('\n- general_state.dart didChangeDependencies -\n\r');
    super.didChangeDependencies();
  }
}
