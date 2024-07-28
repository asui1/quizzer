import 'package:flutter/material.dart';
import 'package:quizzer/Functions/serverRequests.dart';

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
    loadResult(widget.resultId).then((data) {
      setState(() {
        
      });
      print(data);
    });
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