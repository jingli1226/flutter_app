import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Message {
  static info(String msg) {
    EasyLoading.showToast(msg);
  }

  static error(String msg) {
    EasyLoading.showError(msg);
  }
}
