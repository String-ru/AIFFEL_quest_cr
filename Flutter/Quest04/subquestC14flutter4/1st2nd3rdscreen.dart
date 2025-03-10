import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '4thand4-1screen.dart'; // 네 번째 화면 import

void main() {
  Get.put(NoteController()); // NoteController를 전역적으로 등록
  runApp(MyApp()); // 앱 실행
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨김
      home: FirstScreen(), // 첫 화면 설정
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(), // 뒤로 가기 버튼 제거
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/routine_logo.png', width: 150), // 로고 이미지
            SizedBox(height: 20),
            BubbleText(text: '환영합니다!'), // 말풍선 텍스트
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => Get.to(SecondScreen()), // 클릭 시 두 번째 화면으로 이동
              child: BubbleText(text: '안녕하세요!', isRight: true),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final List<String> concerns = [
    '한 가지 일에 집중을 못 하고 딴 짓을 해요.',
    '할 일을 제 시간안에 못 끝내요.',
    '무리한 계획을 세워요.',
    '중요한 일정을 자주 잊어요.',
    '아침이 분주해요.',
    '늦게 잠들어요.',
    '자주 지각해요.',
    '마음에 여유가 없어요.',
  ]; // 고민 목록

  Map<String, bool> selectedConcerns = {}; // 선택된 고민을 저장하는 맵

  @override
  void initState() {
    super.initState();
    for (var concern in concerns) {
      selectedConcerns[concern] = false; // 모든 고민 초기값 false 설정
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/routine_logo.png', width: 40), // 로고 추가
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BubbleText(text: '당신의 가장 큰 고민은?'), // 질문 표시
            SizedBox(height: 10),
            BubbleText(text: '나는 요즘...', isRight: true),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: concerns.map((concern) {
                  return CheckboxListTile(
                    title: Text(concern),
                    value: selectedConcerns[concern], // 체크박스 값 설정
                    onChanged: (bool? value) {
                      setState(() {
                        selectedConcerns[concern] = value ?? false;
                      }); // 체크 여부 업데이트
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue, // 버튼 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => Get.to(ThirdScreen(), arguments: {'concerns': selectedConcerns}), // 선택한 고민 전달 후 이동
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(); // 이메일 입력 컨트롤러
  final TextEditingController nicknameController = TextEditingController(); // 닉네임 입력 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/routine_logo.png', width: 40), // 로고 추가
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BubbleText(text: '회원 가입'), // 회원 가입 제목
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: '이메일'), // 이메일 입력 필드
            ),
            SizedBox(height: 10),
            TextField(
              controller: nicknameController,
              decoration: InputDecoration(labelText: '닉네임'), // 닉네임 입력 필드
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue, // 버튼 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  String email = emailController.text;
                  String nickname = nicknameController.text;
                  var concerns = Get.arguments?['concerns'] ?? {}; // 전달된 고민 목록 가져오기

                  if (email.isNotEmpty && nickname.isNotEmpty) {
                    Get.to(FourthScreen(), arguments: {
                      'email': email,
                      'nickname': nickname,
                      'concerns': concerns
                    }); // 입력한 값과 고민을 다음 화면으로 전달
                  } else {
                    Get.snackbar('오류', '이메일과 닉네임을 입력해주세요.'); // 입력값이 없을 경우 경고 메시지
                  }
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleText extends StatelessWidget {
  final String text;
  final bool isRight;

  BubbleText({required this.text, this.isRight = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isRight ? Alignment.centerRight : Alignment.centerLeft, // 텍스트 정렬 방향 설정
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isRight ? Colors.blueAccent : Colors.grey[300], // 색상 변경
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(color: isRight ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
