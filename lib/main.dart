import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quiz2.dart';
import 'package:quizzer/Class/quiz3.dart';
import 'package:quizzer/Class/quiz4.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/requestEmail.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:quizzer/Functions/versionCheck.dart';
import 'package:quizzer/Screens/MakingQuizLayout.dart';
import 'package:quizzer/Screens/searchScreen.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:quizzer/Setup/Strings.dart';
import 'package:quizzer/Widgets/Generator/quizWidget1Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget2Generator.dart';
import 'package:quizzer/Widgets/Generator/quizWidget4Generator.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget1Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget2Viewer.dart';
import 'package:quizzer/Widgets/Generator/quizWidget3Generator.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget3Viewer.dart';
import 'package:quizzer/Widgets/Viewer/quizWidget4Viewer.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Setup/testpage.dart';
import 'package:quizzer/Widgets/noInternetDialog.dart';
import 'package:quizzer/Widgets/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    runApp(NoInternet());
    return;
  }
  bool isUpdateAvailable = await VersionCheckService().checkForUpdate();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    if (isUpdateAvailable) {
      runApp(UpdateApp()); // 업데이트 권장 앱 실행
    } else {
      runApp(MyApp()); // 메인 앱 실행
    }
  });
}

class UpdateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(Intl.message('There is a new version.\nPlease update.')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig.setUp(context);
    var brightness = MediaQuery.of(context).platformBrightness;

    return ChangeNotifierProvider(
      create: (context) => QuizLayout(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // 영어
          const Locale('ko', ''), // 한국어
        ],
        title: 'Quizzer',
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
          colorScheme: brightness == Brightness.light
              ? MyLightColorScheme
              : MyDarkColorScheme,
          // ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 86, 119, 149)),

          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Quizzer'),
      ),
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
  bool isLoggedIn = false;
  String userImageName = '';
  String userNickname = '';
  List<String> userTags = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPreferences();
    final quizLayout = Provider.of<QuizLayout>(context, listen: false);
  }

  _loadPreferences() async {
    isLoggedIn = UserPreferences.loggedIn;
    userImageName = await UserPreferences.getUserImageName() ?? '';
    userNickname = await UserPreferences.getUserName() ?? '';
    userTags = await UserPreferences.getTagsJson() ?? [];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0; // Default index of first tab

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 3) {
        _scaffoldKey.currentState?.openEndDrawer();
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Row(
            children: <Widget>[
              Spacer(
                flex: 1,
              ),
            ],
          ),
          leading: IconButton(
            iconSize: AppConfig.iconSize,
            icon: ImageIcon(
                AssetImage('assets/icon/quizzerImage.png')), // Example icon
            onPressed: () {
              //TODO : 홈 새로고침.
            },
          ),
          actions: [
            IconButton(
              iconSize: AppConfig.iconSize * 0.8,
              icon: Icon(Icons.search), // Example icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
            isLoggedIn
                ? IconButton(
                    iconSize: AppConfig.iconSize * 0.8,
                    icon: ClipOval(
                      child: Image.network(
                        userImageName,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.primary,
                          );
                        },
                      ),
                    ), // ClipOval로 감싸서 이미지를 원형으로 만듦
                    onPressed: () async {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                  )
                : IconButton(
                    iconSize: AppConfig.iconSize * 0.8,
                    icon: Icon(Icons.person), // Example icon
                    onPressed: () {
                      _showLoginDialog(context);
                    },
                  ),
          ]),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: screenHeight / 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()),
                          );
                        },
                        child: Container(
                          width: screenWidth * 0.7,
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: Intl.message("Search"),
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
                        height: AppConfig.largePadding,
                      ),
                      homeLists([
                        "generator1",
                        "generator2",
                        "generator3",
                        "generator4"
                      ], "퀴즈 생성자 테스트."),
                      SizedBox(
                        height: AppConfig.largePadding,
                      ),
                      homeLists(["viewer1", "viewer2", "viewer3", "viewer4"],
                          "퀴즈 풀이 테스트"),
                      SizedBox(
                        height: AppConfig.largePadding,
                      ),
                      homeLists(
                          ["empty1", "empty2", "empty3", "empty4"], "빈 공간입니다."),
                      SizedBox(
                        height: AppConfig.largePadding * 2,
                      ),
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Intl.message("Contact") + ': whwkd122@gmail.com',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withAlpha(130),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16, // Adjust the distance from the right as needed
              bottom: 16, // Adjust the distance from the bottom as needed
              child: FloatingActionButton(
                key: const ValueKey('moveToMakingQuizScreen'),
                onPressed: () {
                  Provider.of<QuizLayout>(context, listen: false).reset();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MakingQuizscreen()),
                  );
                },
                child: Icon(Icons.add), // "+" icon
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: Intl.message('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: Intl.message('Trending'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: Intl.message('Rank'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: Intl.message('My Settings'),
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.onSecondaryContainer,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSecondaryContainer.withAlpha(130),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          userImageName,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.onPrimary,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        userNickname,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          _showLogoutConfirmationDialog(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      Intl.message("Profile"),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      Intl.message("Setting"),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  // Other ListTiles can go here
                ],
              ),
            ),
            // This ListTile will be positioned at the bottom
            ListTile(
              title: Text(
                Intl.message("Announcement"),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                Intl.message("Inquiry"),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                _showRequestDialog(context);
                // Handle the tap
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestDialog(BuildContext context) async {
    final TextEditingController _emailContentController =
        TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> items = [
          Intl.message("Bug Report"),
          Intl.message("Report Quiz"),
          Intl.message("Development Inquiry"),
          Intl.message("Other Inquiry")
        ];
        String dropdownValue = items[0]; // Default value for the dropdown
        return AlertDialog(
          title: Text(Intl.message("Inquiry")),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use minimum space
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Intl.message("Response will be given by email"),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      width:
                          double.infinity, // Make the container fill the width
                      child: DropdownButton<String>(
                        isExpanded:
                            true, // Make the dropdown button fill the container
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items:
                            items.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    TextField(
                      controller: _emailContentController,
                      decoration: InputDecoration(
                        hintText: Intl.message("Enter Inquiry"),
                        border: OutlineInputBorder(
                          // Add an outline border
                          borderRadius: BorderRadius.circular(
                              5.0), // Optional: Round the corners
                        ),
                      ),
                      minLines: 5,
                      maxLines: 5,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Intl.message("Cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(Intl.message("Submit")),
              onPressed: () async {
                await sendEmail(
                    dropdownValue,
                    _emailContentController
                        .text); // Replace 'UserEmail' with the actual user email variable
                _scaffoldKey.currentState?.closeEndDrawer();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 로그인 버튼
              SizedBox(
                width: double.infinity, // 버튼을 대화상자 너비에 맞춤
                child: ElevatedButton(
                  child: Text(Intl.message("Login"), style: TextStyle(fontSize: 20)),
                  onPressed: () async {
                    final account = await _googleSignIn.signIn();
                    if (account != null) {
                      String photoUrl =
                          account.photoUrl == null ? '' : account.photoUrl!;
                      int loginStatus =
                          await loginCheck(account.email, photoUrl);
                      if (loginStatus == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(Intl.message("Successful Login")),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        _loadPreferences();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      } else if (loginStatus == 400) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(Intl.message("Unregistered User")),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(Intl.message("Login Failed")),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Intl.message("Google Login Failed")),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    }

                    // 로그인 로직 구현
                  },
                ),
              ),
              SizedBox(height: 20), // 버튼 사이의 간격
              // 등록 텍스트 버튼
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Text(Intl.message("Registration"),
                    style: TextStyle(
                        fontSize: 16, decoration: TextDecoration.underline)),
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      _loadPreferences();
    });
  }

  Widget homeLists(List<String> list, String title) {
    return Container(
      width: AppConfig.screenWidth * 0.9,
      // Adjust the height to accommodate the text label above the ListView
      height: AppConfig.screenHeight * 0.25,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns children to the start (left)
        children: [
          Padding(
            padding: const EdgeInsets.only(
                bottom: 8.0), // Add some space between the text and the list
            child: Text(
              title, // Use the title passed to the function
              style: TextStyle(
                fontSize: 16, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Make the title bold
              ),
            ),
          ),
          Expanded(
            // Wrap ListView.builder in an Expanded widget to take up remaining space
            child: ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (list[index].contains('gen')) {
                      navigateToQuizPage(context, 2 * index + 1);
                    }
                    if (list[index].contains('vie')) {
                      navigateToQuizPage(context, 2 * index + 2);
                    }
                  },
                  child: Container(
                    width: AppConfig.screenWidth * 0.3,
                    child: Card(
                      child: Center(
                        child: Text(list[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void navigateToQuizPage(BuildContext context, int n) {
    // Navigator를 사용하여 QuizWidgetN 또는 QuizNPage로 이동
    // 예시로 QuizNPage로 이동하는 코드를 작성
    QuizLayout quizLayout = QuizLayout();

    switch (n) {
      case 1:
        Quiz1 quiz = Quiz1(
            answers: ['', '', '', '', ''],
            ans: [false, false, false, false, false],
            question: '');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizWidget1(
              quiz: quiz,
            ),
          ),
        );
        break;
      case 2:
        Quiz1 quiz = Quiz1(
          answers: ['11', '22', '33', '44', '55'],
          ans: [true, false, false, false, false],
          question: "11을 고르세요.",
          bodyType: 1,
          bodyText: "본문입니다.",
          shuffleAnswers: true,
          maxAnswerSelection: 1,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizView1(
                    quiz: quiz,
                    screenHeightModifier: 1,
                    screenWidthModifier: 1,
                  )),
        );
        break;
      case 3:
        Quiz2 quiz = Quiz2(
          answers: ['', '', '', '', ''],
          ans: [],
          question: '',
          maxAnswerSelection: 1,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizWidget2(
                    quiz: quiz,
                  )),
        );
        break;
      case 4:
        Quiz2 quiz = Quiz2(
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
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizView2(
                    quiz: quiz,
                  )),
        );
        break;
      case 5:
        Quiz3 quiz = Quiz3(
          answers: ['', ''],
          ans: [],
          question: '',
          maxAnswerSelection: 1,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizWidget3(
                    quiz: quiz,
                  )),
        );
        break;
      case 6:
        Quiz3 quiz = Quiz3(
          answers: ['111', '222', '333', '444', '555'],
          ans: [true, false, false, false, false],
          question: "11을 고르세요.",
          maxAnswerSelection: 1,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizView3(
                quiz: quiz,
              ),
            ));
        break;
      case 7:
        Quiz4 quiz = Quiz4(
          answers: ['', ''],
          ans: [],
          question: '',
          maxAnswerSelection: 1,
          connectionAnswers: ['', ''],
          connectionAnswerIndex: [null, null],
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizWidget4(
                    quiz: quiz,
                  )),
        );
        break;
      case 8:
        Quiz4 quiz = Quiz4(
          answers: ['11', '22', '33', '44', '55'],
          ans: [true, false, false, false, false],
          question: "11을 고르세요.",
          maxAnswerSelection: 1,
          connectionAnswers: ['C', 'E', 'A', 'B', 'D'],
          connectionAnswerIndex: [2, 4, 0, 1, 3],
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizView4(
                    quiz: quiz,
                    changePageViewState: (bool tint) {},
                  )),
        );
      // Add more cases for other quiz pages
      default:
        // Handle the case when n is not matched with any of the cases
        break;
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(Intl.message("Are you sure to Logout?")),
          actions: <Widget>[
            TextButton(
              child: Text(Intl.message("No")),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            TextButton(
              child: Text(Intl.message("Yes")),
              onPressed: () async {
                UserPreferences.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(Intl.message("You are Logged out")),
                    duration: Duration(seconds: 2),
                  ),
                );
                _loadPreferences(); // 상태를 새로고침합니다.
                _scaffoldKey.currentState?.closeEndDrawer();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
