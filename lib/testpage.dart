import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Widgets/Generator/quizWidget1Generator.dart';

class TestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _uiState = 0;

  void _toggleUIState() {
    setState(() {
      _uiState = (_uiState + 1) % 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold (
      body:
    GestureDetector(
      onTap: _toggleUIState,
      child: 
      Align(
        alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16.0), // adjust the value as needed
            child: QuizWidget1(),
          ),
        ),
    ),
    );
  }
}

