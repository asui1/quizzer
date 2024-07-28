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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: loadResult(widget.resultId),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {

              return Center(child: Text('Result: ${snapshot.data}'));
            } else {
              return Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }
}
