import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/serverRequests.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController textController = TextEditingController();
  final StreamController<bool> _streamController = StreamController<bool>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? account = null;

  @override
  void dispose() {
    textController.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initGoogleSignIn();
  }

  Future<void> _initGoogleSignIn() async {
    account = await _googleSignIn.signIn();
    if (account != null) {
      setState(() {
        textController.value = TextEditingValue(text: account!.displayName!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign In Failed'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: account != null
            ? StreamBuilder<bool>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  Color borderColor =
                      Theme.of(context).colorScheme.onSurface; // 기본 색상
                  String labelText = '닉네임 설정';
                  Color textColor = Theme.of(context).colorScheme.onSurface;
                  if (snapshot.hasData) {
                    borderColor = snapshot.data!
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error; // 조건에 따른 색상 변경
                    labelText = snapshot.data! ? '사용 가능한 닉네임' : '중복된 닉네임';
                    textColor = snapshot.data!
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface;
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (account!.photoUrl != null)
                        Image.network(
                          account!.photoUrl!,
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
                                Logger.log(value); // 닉네임 출력
                                checkDuplicate(value, _streamController);
                              },
                            ),
                          ),
                          // 중복 확인 버튼 추가
                          TextButton(
                            onPressed: () {
                              if (textController.value.text.isEmpty) return;
                              Logger.log(textController.value.text); // 닉네임 출력
                              checkDuplicate(
                                  textController.value.text, _streamController);
                            },
                            child: Text('중복 확인'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () async {
                          if (snapshot.hasData && snapshot.data!) {
                            bool registerResult = await registerUser(
                                textController.value.text,
                                account!.email,
                                account!.photoUrl!);
                            if (registerResult) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('가입에 성공했습니다.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('가입에 실패했습니다.. 잠시 후 다시 시도해주세요.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(
                          '등록',
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : Container(),
      ),
    );
  }
}
