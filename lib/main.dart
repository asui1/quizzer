import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/MakingQuizLayout.dart';
import 'package:quizzer/Strings.dart';
import 'package:quizzer/Widgets/Generator/quizWidget1Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget2Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget4Generator.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget1Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget2Viewer.dart';
import 'package:quizzer/Widgets/Generator/quizWidget3Generator.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget3Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget4Viewer.dart';
import 'package:quizzer/config.dart';
import 'package:quizzer/testpage.dart';
import 'searchScreen.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig.setUp(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
          title: 'Quizzer :  Customable Quiz App to Meet All Your Purposes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double screenHeight = AppConfig.screenHeight;
  double screenWidth = AppConfig.screenWidth;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,
            style: TextStyle(
              fontFamily: MyFonts.gothicA1,
            )),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: screenHeight / 12,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                child: Container(
                  width: screenWidth / 2,
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()),
                            );
                          },
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 12,
              ),
              Container(
                width: screenWidth * 0.4,
                height: screenWidth * 0.3,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MakingQuizscreen(
                                quizLayout: QuizLayout(),
                              )),
                    );
                  },
                  child: Text(
                    '나만의 퀴즈\n만들기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: AppConfig.fontSize,
                        color: Colors.white), // Set text color to white
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                    ),
                    elevation: 8, // Add elevation to make the button pop out
                    foregroundColor: const Color.fromARGB(
                        255, 153, 27, 175), // Set button color to purple
                    backgroundColor:
                        Colors.purple, // Set button color to purple
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2열로 버튼 배치
                    childAspectRatio: 1,
                    crossAxisSpacing: screenWidth * 0.2, // 가로 간격
                    mainAxisSpacing: screenHeight / 10, // 세로 간격
                  ),
                  itemCount: 8, // 예시로 6개의 버튼을 생성, 필요에 따라 조정
                  shrinkWrap: true, // GridView의 높이를 자동으로 조정
                  itemBuilder: (context, index) {
                    int n = (index + 1); // N 값을 결정
                    return InkWell(
                      onTap: () => navigateToQuizPage(context, n),
                      child: Card(
                        child: Center(
                          child: Text(stringResources['quiz$n']!),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToQuizPage(BuildContext context, int n) {
    // Navigator를 사용하여 QuizWidgetN 또는 QuizNPage로 이동
    // 예시로 QuizNPage로 이동하는 코드를 작성
    switch (n) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget1(
              quiz: Quiz1(
                  answers: ['', '', '', '', ''],
                  ans: [false, false, false, false, false],
                  question: ''),
              quizLayout: QuizLayout(),
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizView1(
                    quiz: Quiz1(
                      answers: ['11', '22', '33', '44', '55'],
                      ans: [true, false, false, false, false],
                      question: "11을 고르세요.",
                      bodyType: 1,
                      bodyText: "본문입니다.",
                      shuffleAnswers: true,
                      maxAnswerSelection: 1,
                    ),
                    screenHeightModifier: 1,
                    screenWidthModifier: 1,
                    quizLayout: QuizLayout(),
                  )),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizWidget2(
                    quiz: Quiz2(
                      answers: [],
                      ans: [],
                      question: '',
                      maxAnswerSelection: 1,
                    ),
                    quizLayout: QuizLayout(),
                  )),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizView2(
                    quiz: Quiz2(
                      answers: ['11', '22', '33', '44', '55'],
                      ans: [true, false, false, false, false],
                      question: "11을 고르세요.",
                      maxAnswerSelection: 1,
                      centerDate: [2024, 6, 22],
                      yearRange: 10,
                      answerDate: [
                        [2024, 6, 22],
                        [2024, 6, 20]
                      ],
                    ),
                  )),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizWidget3(
                    quiz: Quiz3(
                      answers: ['', ''],
                      ans: [],
                      question: '',
                      maxAnswerSelection: 1,
                    ),
                    quizLayout: QuizLayout(),
                  )),
        );
        break;
      case 6:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizView3(
                  quiz: Quiz3(
                answers: ['111', '222', '333', '444', '555'],
                ans: [true, false, false, false, false],
                question: "11을 고르세요.",
                maxAnswerSelection: 1,
              )),
            ));
        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizWidget4(
                    quiz: Quiz4(
                      answers: ['', ''],
                      ans: [],
                      question: '',
                      maxAnswerSelection: 1,
                      connectionAnswers: ['', ''],
                      connectionAnswerIndex: [null, null],
                    ),
                    quizLayout: QuizLayout(),
                  )),
        );
        break;
      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizView4(
                    quiz: Quiz4(
                      answers: ['11', '22', '33', '44', '55'],
                      ans: [true, false, false, false, false],
                      question: "11을 고르세요.",
                      maxAnswerSelection: 1,
                      connectionAnswers: ['C', 'E', 'A', 'B', 'D'],
                      connectionAnswerIndex: [2, 4, 0, 1, 3],
                    ),
                    quizLayout: QuizLayout(),
                  )),
        );
      // Add more cases for other quiz pages
      default:
        // Handle the case when n is not matched with any of the cases
        break;
    }
  }
}
