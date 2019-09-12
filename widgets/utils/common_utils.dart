import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class CommonUtils {
  static getThemeData(Color color) {
    return ThemeData(
      primaryColor: color,
      platform: TargetPlatform.android
    );
  }

  static goBackButton(context, {VoidCallback onPressed}) {
    Widget _iconWidget;
    if (Platform.isAndroid) {
      _iconWidget = Icon(Icons.arrow_back, color: Color(0xffffffff),);
    } else if (Platform.isIOS) {
      _iconWidget = Icon(Icons.arrow_back_ios, color: Color(0xffffffff),);
    }
    return IconButton(icon: _iconWidget, onPressed: onPressed);
  }

  /// 身份证号码验证
  static bool isCardId (String cardId){
    if (cardId == null || cardId == '' || cardId.length != 18) {
      return false; // 位数不够
    }
    // 身份证号码正则
    RegExp postalCode = new RegExp(r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
    // 通过验证，说明格式正确，但仍需计算准确性
    if (!postalCode.hasMatch(cardId)) {
      return false;
    }
    //将前17位加权因子保存在数组里
    final List idCardList = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    final List idCardYArray = ['1','0','10','9','8','7','6','5','4','3','2'];
    // 前17位各自乖以加权因子后的总和
    int idCardWiSum = 0;

    for (int i = 0; i < 17; i ++) {
      int subStrIndex = int.parse(cardId.substring(i,i+1));
      int idCardWiIndex = int.parse(idCardList[i]);
      idCardWiSum += subStrIndex * idCardWiIndex;
    }
    // 计算出校验码所在数组的位置
    int idCardMod = idCardWiSum % 11;
    // 得到最后一位号码
    String idCardLast = cardId.substring(17,18);
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2){
      if (idCardLast != 'x' && idCardLast != 'X'){
        return false;
      }
    }else{
      //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
      if (idCardLast != idCardYArray[idCardMod]){
        return false;
      }
    }
    return true;
  }

  /// 根据身份证号码计算年龄
  /// @param idNumber 考虑到了15位身份证，但不一定存在
  static final int _invalidAge = -1; // 非法的年龄，用于处理异常。
  static int getAgeByIDNumber(String idNumber) {
    String _dateStr;
    if (idNumber.length == 15) {
      _dateStr = "19" + idNumber.substring(6, 12);
    } else if (idNumber.length == 18) {
      _dateStr = idNumber.substring(6, 14);
    } else {//默认是合法身份证号，但不排除有意外发生
      return _invalidAge;
    }

    if (int.tryParse(_dateStr) == null) return _invalidAge;
    DateFormat formatter = new DateFormat('yyyyMMdd');
    try {
      return getAgeByDate(formatter, _dateStr);
    } catch (e) {
       return _invalidAge;
    }
  }

  static int getAgeByDate(DateFormat formatter, String birthday) {
    if (birthday == null || birthday == '' || birthday.length != 8) {
      return _invalidAge;
    }
    int years = 0;
    int diff = 0;
    String nowDay = formatter.format(DateTime.now());
    int b_year = int.parse(birthday.substring(0, 4));
    int b_month = int.parse(birthday.substring(4, 6));
    int b_day = int.parse(birthday.substring(6));
    int n_year = int.parse(nowDay.substring(0, 4));
    int n_month = int.parse(nowDay.substring(4, 6));
    int n_day = int.parse(nowDay.substring(6));

    if (b_year < n_year) {
      years = n_year - b_year;
      if (b_month > n_month) {
        diff = -1;
      } else if (b_month == n_month) {
        if (b_day > n_day) diff = -1;
      }
    }

    return years + diff;
  }
}
