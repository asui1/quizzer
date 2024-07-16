import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class scoreCard extends StatelessWidget{
  ColorScheme color;
  int score;
  
  scoreCard({required this.color, required this.score});


  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('확인'),
      onPressed: (){},
    );
  }
  
}