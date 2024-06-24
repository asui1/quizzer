import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Class/quiz.dart';
import 'package:quizzer/Class/quiz2.dart'; // Add this line to import DateFormat

Widget buildDatePicker(BuildContext context, Quiz2 quiz, Function updateState, bool getInputYearText, bool getDeleteButton, Function deleteThis, int inputType) {
  List<int> selectedDate = [];
  if (inputType == -1) {
    selectedDate = quiz.getCenterDate();
  } else if (inputType >= 0) {
    selectedDate = quiz.getAnswerDateAt(inputType);
  }
  int selectedYear = selectedDate[0];
  int selectedMonth = selectedDate[1];
  int selectedDay = selectedDate[2];
  int range = quiz.getYearRange();
  List<int> years =
      List<int>.generate(range * 2, (index) => selectedYear - range + index);
  List<int> months = List<int>.generate(12, (index) => index + 1);
  List<int> days = List<int>.generate(
    DateUtils.getDaysInMonth(selectedYear, selectedMonth),
    (index) => index + 1,
  );
  TextEditingController yearController =
      TextEditingController(text: selectedYear.toString());

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      getInputYearText ? Container(
        width: 100, // Adjust the width as needed
        child: TextField(
          controller: yearController,
          keyboardType: TextInputType.number,
          onSubmitted: (value) {
            int? yearValue = int.tryParse(value);
            if (yearValue != null) {
              selectedYear = yearValue;
              updateState([selectedYear, selectedMonth, selectedDay]);
            } else {}
          },
          decoration: InputDecoration(
            labelText: 'Year',
            border: OutlineInputBorder(),
          ),
        ),
      ) : Container(),
      SizedBox(width: 20), // Space between the text field and the dropdown
      DropdownButton<int>(
        value: selectedYear,
        items: years.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (newValue) {
          selectedYear = newValue!;
          // Update days based on the selected year and month
          updateState([selectedYear, selectedMonth, selectedDay]);
        },
      ),
      DropdownButton<int>(
        value: selectedMonth,
        items: months.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(DateFormat.MMM().format(DateTime(0, value))),
          );
        }).toList(),
        onChanged: (newValue) {
          selectedMonth = newValue!;
          updateState([selectedYear, selectedMonth, selectedDay]);
        },
      ),
      DropdownButton<int>(
        value: selectedDay,
        items: days.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (newValue) {
          selectedDay = newValue!;
          updateState([selectedYear, selectedMonth, selectedDay]);
        },
      ),


      getDeleteButton ? IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          deleteThis();
        },
      ) : Container(),
    ],
  );
}
