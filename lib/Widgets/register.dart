import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:google_sign_in_web/web_only.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];
final GoogleSignInPlatform _platform = GoogleSignInPlatform.instance;

class Register extends StatefulWidget {
  GoogleSignInUserData? account;

  Register({required this.account, Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController textController = TextEditingController();
  final StreamController<bool> _streamController = StreamController<bool>();
  bool _isTapInProgress = false;
  GSIButtonConfiguration? _buttonConfiguration = GSIButtonConfiguration(
      text: GSIButtonText.continueWith); // button configuration

  @override
  void dispose() {
    textController.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _platform.userDataEvents?.listen((GoogleSignInUserData? userData) {
      setState(() {
        if (userData == null) return;
        print('User Data: ${userData.email}, ${userData.photoUrl}');
        widget.account = userData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(), // 뒤로 가기 버튼 추가
      ),
      body: Center(
        child: widget.account != null
            ? StreamBuilder<bool>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  Color borderColor =
                      Theme.of(context).colorScheme.onSurface; // 기본 색상
                  String labelText = Intl.message("Set_Nickname");
                  Color textColor = Theme.of(context).colorScheme.onSurface;
                  if (snapshot.hasData) {
                    borderColor = snapshot.data!
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error; // 조건에 따른 색상 변경
                    labelText = snapshot.data!
                        ? Intl.message("Usable_Nickname")
                        : Intl.message("Duplicate_Nickname");
                    textColor = snapshot.data!
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface;
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.account!.photoUrl != null)
                        Image.network(
                          widget.account!.photoUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              controller: textController, // 초기값 설정
                              decoration: InputDecoration(
                                labelText: labelText,
                                // 조건에 따른 테두리 색상 변경
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: borderColor, width: 2),
                                ),
                              ),
                              onChanged: (value) {
                                _streamController.add(false);
                              },
                              onSubmitted: (value) {
                                if (textController.value.text.isEmpty) return;
                                // 사용자가 키보드에서 '완료'를 눌렀을 때 실행
                                checkDuplicate(value, _streamController);
                              },
                            ),
                          ),
                          // 중복 확인 버튼 추가
                          TextButton(
                            onPressed: () {
                              if (textController.value.text.isEmpty) return;
                              checkDuplicate(
                                  textController.value.text, _streamController);
                            },
                            child: Text(Intl.message("Dup_check")),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_isTapInProgress)
                            return; // 이미 탭이 진행 중이면 아무 작업도 하지 않음
                          _isTapInProgress = true; // 탭 진행 중 상태로 설정

                          if (snapshot.hasData && snapshot.data!) {
                            bool registerResult = await registerUser(
                                textController.value.text,
                                widget.account!.email,
                                widget.account!.photoUrl ?? '',
                                context);
                            if (registerResult) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(Intl.message("Register_Success")),
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              Navigator.pop(context);
                              Navigator.pop(context);
                              _isTapInProgress = false; // 탭 진행 중 상태 해제
                            } else {
                              _isTapInProgress = false; // 탭 진행 중 상태 해제
                            }
                          }
                          _isTapInProgress = false; // 탭 진행 중 상태 해제
                        },
                        child: Text(
                          Intl.message("Register"),
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : renderButton(configuration: _buttonConfiguration),
      ),
    );
  }
}
