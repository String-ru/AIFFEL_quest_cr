import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '4thand4-1screen.dart';

void main() {
  Get.put(NoteController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/routine_logo.png', width: 150),
            SizedBox(height: 20),
            BubbleText(text: '환영합니다!'),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => Get.to(SecondScreen()),
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
  ];

  Map<String, bool> selectedConcerns = {};

  @override
  void initState() {
    super.initState();
    for (var concern in concerns) {
      selectedConcerns[concern] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/routine_logo.png', width: 40),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BubbleText(text: '당신의 가장 큰 고민은?'),
            SizedBox(height: 10),
            BubbleText(text: '나는 요즘...', isRight: true),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: concerns.map((concern) {
                  return CheckboxListTile(
                    title: Text(concern),
                    value: selectedConcerns[concern],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedConcerns[concern] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => Get.to(ThirdScreen(), arguments: {'concerns': selectedConcerns}),
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/routine_logo.png', width: 40),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BubbleText(text: '회원 가입'),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nicknameController,
              decoration: InputDecoration(labelText: '닉네임'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  String email = emailController.text;
                  String nickname = nicknameController.text;
                  var concerns = Get.arguments?['concerns'] ?? {};

                  if (email.isNotEmpty && nickname.isNotEmpty) {
                    Get.to(FourthScreen(), arguments: {
                      'email': email,
                      'nickname': nickname,
                      'concerns': concerns
                    });
                  } else {
                    Get.snackbar('오류', '이메일과 닉네임을 입력해주세요.');
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
      alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isRight ? Colors.blueAccent : Colors.grey[300],
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
