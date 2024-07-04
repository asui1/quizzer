// 1. CustomScrollController 정의
import 'package:flutter/widgets.dart';

class CustomScrollController extends ScrollController {
  @override
  void jumpTo(double value) {
    if (position.pixels == position.maxScrollExtent) {
      // 스크롤이 끝에 도달했을 때의 처리
      // 여기서는 추가 처리가 필요 없으므로 빈 상태로 둡니다.
    } else {
      super.jumpTo(value);
    }
  }

}