import 'package:flutter/material.dart';

class UsageAgreementScreen extends StatefulWidget {
  @override
  _UsageAgreementScreenState createState() => _UsageAgreementScreenState();
}

class _UsageAgreementScreenState extends State<UsageAgreementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/icon/quizzerImage.png', // 앱 아이콘 경로
              height: 32.0,
            ),
            SizedBox(width: 8.0),
            Text('Quizzer'), // 앱 이름
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              '''
개인정보처리방침

1. 개인정보의 수집 및 이용 목적
Quizzer(이하 "앱")은 사용자의 개인정보를 중요하게 생각하며, 아래와 같은 목적을 위해 개인정보를 수집 및 이용합니다.

사용자 식별 및 앱 서비스 제공
사용자와의 의사소통을 위한 이메일 사용
앱 내부에서의 활동 정보 분석을 통한 서비스 개선

2. 수집하는 개인정보 항목
앱은 다음과 같은 개인정보를 수집합니다.

이메일 주소: 사용자 식별 및 의사소통을 위해 사용됩니다.
앱 내부 활동 정보: 앱 사용 패턴 분석 및 서비스 개선을 위해 사용됩니다.

3. 개인정보의 보유 및 이용기간
수집된 개인정보는 이용목적이 달성되거나 사용자가 삭제를 요청할 때까지 보유 및 이용됩니다. 사용자가 요청할 경우, 수집된 개인정보는 지체 없이 삭제됩니다.

4. 개인정보의 제3자 제공
앱은 사용자의 사전 동의 없이는 개인정보를 제3자에게 제공하지 않습니다.

5. 개인정보의 안전성 확보 조치
앱은 사용자의 개인정보를 안전하게 관리하기 위해 다음과 같은 조치를 취하고 있습니다.

개인정보의 암호화
해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출을 막기 위한 기술적 대책
개인정보 접근 권한 제한

6. 개인정보보호책임자
개인정보와 관련된 문의사항은 아래의 개인정보보호책임자에게 연락해 주시기 바랍니다.

책임자: 조장현
연락처: whwkd122@gmail.com

7. 개인정보 처리방침의 변경
개인정보처리방침이 변경될 경우, 변경 사항은 앱 내 공지사항을 통해 고지됩니다.

본 방침은 2024년 8월 4일부터 시행됩니다.

--------------------------------------------------

Privacy Policy

1. Purpose of Collecting and Using Personal Information
asu1 (hereinafter referred to as "the App") highly values user privacy and collects and uses personal information for the following purposes:

User identification and provision of app services
Communication with users via email
Analyzing in-app activity information to improve services

2. Items of Personal Information Collected
The App collects the following personal information:

Email Address: Used for user identification and communication.
In-app Activity Information: Used for analyzing app usage patterns and improving services.

3. Retention and Use Period of Personal Information
Collected personal information is retained and used until the purpose of use is achieved or the user requests deletion. Upon user request, the collected personal information will be promptly deleted.

4. Provision of Personal Information to Third Parties
The App does not provide personal information to third parties without the prior consent of the user.

5. Measures to Ensure the Safety of Personal Information
The App takes the following measures to ensure the safety of users' personal information:

Encryption of personal information
Technical measures to prevent personal information leakage due to hacking or computer viruses
Restriction of access rights to personal information

6. Personal Information Protection Officer
For inquiries related to personal information, please contact the Personal Information Protection Officer below.

Officer: [Name of Personal Information Protection Officer]
Contact: whwkd122@gmail.com

7. Changes to the Privacy Policy
If there are any changes to the privacy policy, the changes will be notified through the app's notice board.

This policy is effective as of August 4, 2024.
              ''',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
