import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Setup/config.dart';
import 'dart:convert';

import 'package:quizzer/Screens/solver.dart';

class QuizCard extends StatelessWidget {
  final String uuid;
  final String title;
  final List<String> tags;
  final String creator;
  final Uint8List titleImageByte;
  final int counts;
  final bool isOwner;
  bool _isTapInProgress = false;

  QuizCard(
      {required this.uuid,
      required this.title,
      required this.titleImageByte,
      this.tags = const ['#테스트'],
      this.creator = '테스트를 위한 문구입니다.',
      this.isOwner = false,
      this.counts = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppConfig.smallPadding), // AppConfig에서 패딩 값 가져오기
      child: Material(
        type: MaterialType
            .transparency, // This makes the material widget transparent
        child: InkWell(
          onTap: () async {
            if (_isTapInProgress) return; // 이미 탭이 진행 중이면 아무 작업도 하지 않음
            // -> Solver에 uuid 제공하고, solver에서는 그 uuid로 로드하기.
            _isTapInProgress = true; // 탭 진행 중 상태로 설정

            if (isOwner) {
              final Uri newUri = Uri(
                path: '/editor',
                queryParameters: {'uuid': uuid},
              );
              Navigator.pushNamed(context, newUri.toString());
            } else {
              final Uri newUri = Uri(
                path: '/solver',
                queryParameters: {'uuid': uuid},
              );
              Navigator.pushNamed(context, newUri.toString());
            }

            _isTapInProgress = false;
          },
          child: Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(AppConfig.smallPadding),
                child: Row(
                  // Row 위젯을 사용하여 이미지와 텍스트 열을 수평으로 배열
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0), // 둥근 모서리 반경 설정
                      child: SizedBox(
                        width: AppConfig.screenHeight * 0.15, // 이미지 너비
                        height: AppConfig.screenHeight * 0.15, // 이미지 높이
                        child: titleImageByte.length < 30
                            ? Image.asset('assets/images/question2.png',
                                fit: BoxFit.cover) // 에셋 이미지 사용
                            : Image.memory(
                                titleImageByte,
                                fit: BoxFit.cover,
                              ), // 파일 이미지 사용
                      ),
                    ),
                    SizedBox(
                      width: AppConfig.shortestSide * 0.05,
                    ),
                    Expanded(
                      // 이미지와 텍스트 사이의 공간을 채우기 위해 Expanded 사용
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 텍스트를 시작 부분에서 정렬
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: AppConfig.fontSize,
                                fontWeight: FontWeight.bold),
                          ), // 제목 표시
                          Flexible(
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: AppConfig.smallPadding, // 태그 사이의 가로 간격
                              runSpacing:
                                  AppConfig.smallerPadding, // 태그 사이의 세로 간격
                              children: tags.map((tag) {
                                return Chip(
                                  color: WidgetStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  padding: EdgeInsets.all(4),
                                  labelPadding: EdgeInsets.all(2),
                                  label: Text(
                                    tag,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontSize: AppConfig.fontSize * 0.6,
                                        fontWeight: FontWeight.w300),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                creator,
                                style: TextStyle(
                                    fontSize: AppConfig.fontSize * 0.8,
                                    fontWeight: FontWeight.w200), // 추가 데이터 표시
                              ), // 추가 데이터 표시
                              Spacer(),
                              Text(
                                Intl.message("Solved_num") + ': $counts',
                                style: TextStyle(
                                    fontSize: AppConfig.fontSize * 0.8,
                                    fontWeight: FontWeight.w200), // 추가 데이터 표시
                              ), // 추가 데이터 표시
                              SizedBox(
                                width: AppConfig.padding,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
