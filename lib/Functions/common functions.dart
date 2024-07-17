import 'package:flutter/material.dart';

void goBack(BuildContext context) {
  // 현재 포커스를 제거하여 키보드를 숨깁니다.
  FocusScope.of(context).unfocus();

  // 약간의 지연 후에 화면을 종료합니다. (선택적)
  Future.delayed(Duration(milliseconds: 100), () {
    Navigator.pop(context);
  });
}