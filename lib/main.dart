import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_web/web_only.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/myScroll.dart';
import 'package:quizzer/Class/myTransition.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/CustomNavigatorObserver.dart';
// ignore: unused_import
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/keys.dart';
import 'package:quizzer/Functions/requestEmail.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:quizzer/Screens/MakingQuizLayout.dart';
import 'package:quizzer/Screens/QuizResultViewer.dart';
import 'package:quizzer/Screens/additionalSetup.dart';
import 'package:quizzer/Screens/loadTemp.dart';
import 'package:quizzer/Screens/makingQuiz.dart';
import 'package:quizzer/Screens/scoreCardCreator.dart';
import 'package:quizzer/Screens/scoringScreen.dart';
import 'package:quizzer/Screens/searchScreen.dart';
import 'package:quizzer/Screens/solver.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:quizzer/Theme/theme.dart';
import 'package:quizzer/Theme/util.dart';
import 'package:quizzer/Widgets/QuizCardVertical.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/register.dart';
import 'package:quizzer/generated/intl/messages_all.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:html' as html;
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];
final GoogleSignInPlatform _platform = GoogleSignInPlatform.instance;
GoogleSignInUserData? _userData = null;
final CustomNavigatorObserver customNavigatorObserver =
    CustomNavigatorObserver();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  List<Locale> locales = WidgetsBinding.instance.platformDispatcher.locales;
  // 한국어 지원 여부 확인
  String locale = locales.contains(const Locale('ko', "KR")) ? 'ko' : 'en';
  await initializeMessages(locale);
  String localeCode = (locale == 'ko') ? 'ko_KR' : 'en_US';
  // Intl 패키지에 로케일 설정
  Intl.defaultLocale = localeCode;
  await _platform.initWithParams(SignInInitParameters(
    clientId: googleClientId,
    scopes: scopes,
  ));
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizLayout(),
      child: MyApp(),
    ),
  ); // 메인 앱 실행
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig.setUp(context);
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Noto Sans", "Gothic A1");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', ''), // 한국어
        const Locale('en', ''), // 영어
      ],
      title: 'Quizzer',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      navigatorObservers: [customNavigatorObserver],
      onGenerateRoute: (settings) {
        bool isMakingQuizscreenInStack =
            customNavigatorObserver.isPageInStack('/makingQuizLayout');

        if (settings.name == '/makingQuiz' && isMakingQuizscreenInStack) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                MakingQuiz(),
            transitionsBuilder: mySlideTransition,
          );
        } else if (settings.name == '/additionalSetup' &&
            isMakingQuizscreenInStack) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                quizLayoutAdditionalSetup(),
            transitionsBuilder: mySlideTransition,
          );
        } else if (settings.name == '/scoreCardCreator' &&
            isMakingQuizscreenInStack) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                ScoreCardGenerator(),
            transitionsBuilder: mySlideTransition,
          );
        } else if (settings.name != null &&
            settings.name!.startsWith('/searchResult')) {
          final uri = Uri.parse(settings.name!);
          final searchText = uri.queryParameters['searchText'];
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => SearchScreen(searchText: searchText),
          );
        } else if (settings.name != null &&
            settings.name!.startsWith('/solver')) {
          final uri = Uri.parse(settings.name!);
          final uuid = uri.queryParameters['uuid'];
          final index = int.parse(uri.queryParameters['index'] ?? '0');
          final isPreview = uri.queryParameters['isPreview'] == 'true';

          if (!isPreview) {
            Provider.of<QuizLayout>(context, listen: false).reset();
          } else if (isPreview && !isMakingQuizscreenInStack) {
            return null;
          }

          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => QuizSolver(
              uuid: uuid,
              index: index,
              isPreview: isPreview,
            ),
            transitionsBuilder: mySlideTransition,
          );
        } else if (settings.name != null &&
            settings.name!.startsWith('/result')) {
          final uri = Uri.parse(settings.name!);
          final resultId = uri.queryParameters['resultId'];
          Logger.log(resultId);
          if (resultId == null) return null;

          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                QuizResultViewer(
              resultId: resultId,
            ),
            transitionsBuilder: mySlideTransition,
          );
        } else if (settings.name!.startsWith('/makingQuizLayout')) {
          Provider.of<QuizLayout>(context, listen: false).reset();

          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                MakingQuizscreen(),
            transitionsBuilder: mySlideTransition,
          );
        } else {
          // 기본 경로 설정
          return MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Quizzer'),
          );
        }
      },
      routes: {
        '/': (context) => const MyHomePage(title: 'Quizzer'),
        '/register': (context) => Register(account: _userData),
        '/search': (context) => SearchScreen(searchText: null),
      },
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
  List<QuizCardVertical> quizCardList1 = [];
  List<QuizCardVertical> quizCardList2 = [];
  List<QuizCardVertical> quizCardList3 = [];
  late Future<void> _future;
  GSIButtonConfiguration? _buttonConfiguration; // button configuration
  StreamSubscription? _userDataSubscription;

  @override
  void initState() {
    Logger.log('Home Page Initialized');
    super.initState();
    _loadPreferences();
    Provider.of<QuizLayout>(context, listen: false);
    _future = _loadDataFromServer();
    _startUserDataSubscription();
    _platform.signInSilently();
  }

  void _startUserDataSubscription() {
    _userDataSubscription =
        _platform.userDataEvents?.listen((GoogleSignInUserData? userData) {
      setState(() async {
        if (userData == null) return;
        print('User Data: ${userData.email}, ${userData.photoUrl}');
        _userData = userData;
        await loginCheck(userData.email, userData.photoUrl ?? '');
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    });
  }

  Future<void> _loadDataFromServer() async {
    List<Locale> locales = WidgetsBinding.instance.platformDispatcher.locales;
    // 한국어 지원 여부 확인
    String locale = locales.contains(const Locale('ko', "KR")) ? 'ko' : 'en';
    List<List<QuizCardVertical>> recommendations =
        await getRecommendations(locale);
    quizCardList1 = recommendations[0]; // 가장 인기있는 5개
    quizCardList2 = recommendations[1]; // 태그 기반 추천 5개
    quizCardList3 = recommendations[2]; // 최신 5개
    setState(() {});
    // 가장 인기있는 5개, 태그 기반 추천 5개, 최신 5개
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

    return FutureBuilder(
      // Call _loadDataFromServer and wait for it to complete.
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // You can check the snapshot state to show loading indicators or error messages
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: ImageIcon(
                AssetImage('assets/icon/quizzerImage.png'), // Example icon
                size: 100.0, // Adjust the size as needed
              ),
            ),
          ); // Show empty screen with AppIcon at center while waiting
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show error message if something went wrong
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
                icon: ImageIcon(
                    AssetImage('assets/icon/quizzerImage.png')), // Example icon
                onPressed: () {
                  //TODO : 홈 새로고침.
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search), // Example icon
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                isLoggedIn
                    ? IconButton(
                        icon: ClipOval(
                          child: Image.network(
                            userImageName,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
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
                              Navigator.pushNamed(context, '/search');
                            },
                            child: Container(
                              width: screenWidth * 0.7,
                              child: AbsorbPointer(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: Intl.message("Search"),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/search');
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
                          homeLists(
                              quizCardList1, Intl.message("Popular_Quiz")),
                          SizedBox(
                            height: AppConfig.largePadding,
                          ),
                          homeLists(
                              quizCardList2, Intl.message("Recommendation")),
                          SizedBox(
                            height: AppConfig.largePadding,
                          ),
                          homeLists(quizCardList3, Intl.message("Most_Recent")),
                          SizedBox(
                            height: AppConfig.largePadding * 2,
                          ),
                          Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Intl.message("Contact") +
                                      ': whwkd122@gmail.com',
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
                      Navigator.pushNamed(context, '/makingQuizLayout');
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
                label: Intl.message("Home"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: Intl.message("Trending"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard),
                label: Intl.message("Rank"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: Intl.message("My_Settings"),
              ),
            ],
            selectedItemColor:
                Theme.of(context).colorScheme.onSecondaryContainer,
            unselectedItemColor: Theme.of(context)
                .colorScheme
                .onSecondaryContainer
                .withAlpha(130),
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
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Spacer(),
                          isLoggedIn
                              ? IconButton(
                                  icon: Icon(Icons.logout),
                                  onPressed: () {
                                    _showLogoutConfirmationDialog(context);
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.person), // Example icon
                                  onPressed: () {
                                    _showLoginDialog(context);
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
      },
    );
  }

  void _showRequestDialog(BuildContext context) async {
    final TextEditingController _emailContentController =
        TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> items = [
          Intl.message("Bug_Report"),
          Intl.message("Report_Quiz"),
          Intl.message("Development_Inquiry"),
          Intl.message("Other_Inquiry")
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
                        Intl.message("Response_will_be_given_by_email"),
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
                        hintText: Intl.message("Enter_Inquiry"),
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
                child: renderButton(configuration: _buttonConfiguration),
              ),
              SizedBox(height: 20), // 버튼 사이의 간격
              // 등록 텍스트 버튼
              GestureDetector(
                onTap: () async {
                  await _userDataSubscription?.cancel();

                  Navigator.pushNamed(context, '/register').then((_) {
                    _startUserDataSubscription();
                  });
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

  Widget homeLists(List<QuizCardVertical> list, String title) {
    return Container(
      width: AppConfig.screenWidth * 0.9,
      // Adjust the height to accommodate the text label above the ListView
      height: AppConfig.screenHeight * 0.30 + AppConfig.fontSize * 2,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns children to the start (left)
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0,
                bottom: 8.0), // Add some space between the text and the list
            child: Text(
              title, // Use the title passed to the function
              style: TextStyle(
                fontSize:
                    AppConfig.fontSize * 0.8, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Make the title bold
              ),
            ),
          ),
          Expanded(
            // Wrap ListView.builder in an Expanded widget to take up remaining space
            child: ListView.builder(
              shrinkWrap: false,
              physics:
                  AlwaysScrollableScrollPhysics(), // Enable always scrollable physics
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return list[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(Intl.message("Are_you_sure_to_Logout")),
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
                    content: Text(Intl.message("You_are_Logged_out")),
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
