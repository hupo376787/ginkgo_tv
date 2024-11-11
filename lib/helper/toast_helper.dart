import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

void showMyToast(String msg) {
  BotToast.showText(
      text: msg,
      borderRadius: BorderRadius.circular(20),
      duration: Duration(seconds: 6));
}
