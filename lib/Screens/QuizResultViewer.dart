import 'package:flutter/material.dart';

class QuizResultViewer extends StatefulWidget {
  final String resultId;

  QuizResultViewer({required this.resultId});

  @override
  _QuizResultViewerState createState() => _QuizResultViewerState();
}

class _QuizResultViewerState extends State<QuizResultViewer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result Viewer'),
      ),
      body: Center(
        child: Text('Result ID: ${widget.resultId}'),
      ),
    );
  }
}