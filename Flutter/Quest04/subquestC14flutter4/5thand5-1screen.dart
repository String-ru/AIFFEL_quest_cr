import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '4thand4-1screen.dart';  // 4th 화면 import
import '6thand6-1screen.dart';  // 6th 화면 import

class FifthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/routine_logo.png', width: 40),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,  // 내용이 화면 상단에 위치하도록 수정
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),  // 화면 상단과 텍스트 사이의 여백
              child: Column(
                children: [
                  Text('아침형 인간 님은 지금 ...'),
                  Text('Lv 4. 새싹입니다!'),
                  Text('성장률: 43%'),
                  Text('현재 연속 출석: 6'),
                  Text('최대 연속 출석: 17'),
                  Text('누적 출석일: 43'),
                ],
              ),
            ),
            SizedBox(height: 40),  // 상단 문구와 버튼들 사이의 여백
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // 버튼 사이의 간격을 고르게
              children: [
                ElevatedButton(
                  onPressed: () => Get.to(FourthScreen()),  // 4th 화면으로 이동
                  child: Text('나의 루틴들'),
                ),
                ElevatedButton(
                  onPressed: () => Get.to(Fifth1Screen()),  // 5-1 화면으로 이동
                  child: Text('세부 진행 안내'),
                ),
                ElevatedButton(
                  onPressed: () => Get.to(SixthScreen()),  // 6th 화면으로 이동
                  child: Text('나의 프로필'),
                ),
              ],
            ),
            SizedBox(height: 20),  // 버튼 아래에 여백을 주기 위한 SizedBox
          ],
        ),
      ),
    );
  }
}

class Fifth1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/routine_logo.png', width: 40),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('세부 진행 안내'),
            ElevatedButton(
              onPressed: () => Get.to(FifthScreen()),  // 5th 화면으로 돌아가기
              child: Text('진행도'),
            ),
          ],
        ),
      ),
    );
  }
}
