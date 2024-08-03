import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:quizzer/Widgets/quizCard.dart';

class MyQuiz extends StatefulWidget {
  @override
  _MyQuizState createState() => _MyQuizState();
}

class _MyQuizState extends State<MyQuiz> {
  List<QuizCard> _myQuizData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    String? email = await UserPreferences.getUserEmail();
    if (email == null || email == 'userEmail') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Intl.message('Login_to_see_your_quiz_data')),
      ));
      Navigator.of(context).pop();
      return;
    } else {
      _myQuizData = await searchMyQuiz(email);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteQuiz(int index) async {
    bool delete = await deleteQuiz(_myQuizData[index].uuid, context);
    if (delete) {
      setState(() {
        _myQuizData.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Intl.message('myQuiz')),
      ),
      body: _isLoading
          ? Container()
          : _myQuizData.isEmpty
              ? Center(child: Text(Intl.message("No_data_found")))
              : ListView.builder(
                  itemCount: _myQuizData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteQuiz(index),
                      ),
                      title: _myQuizData[index],
                    );
                  },
                ),
    );
  }
}
