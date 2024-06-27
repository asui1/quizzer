import 'package:flutter/material.dart';
import 'package:quizzer/config.dart';

class questionInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  questionInputTextField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '질문을 입력해주세요.',
      ),
      onChanged: onChanged,
    );
  }
}

class GeneratorDoneButton extends StatelessWidget {
  final Function() onPressed;

  GeneratorDoneButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppConfig.smallPadding),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          child: Text('완료'),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
