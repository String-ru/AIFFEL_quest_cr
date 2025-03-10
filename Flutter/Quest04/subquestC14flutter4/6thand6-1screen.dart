import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '4thand4-1screen.dart';   // 4th 화면 import
import '5thand5-1screen.dart';  // 5th 화면 import

class SixthScreen extends StatelessWidget {
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
            Text('나의 프로필'),
            Expanded(
              child: Container(),  // 상단 내용을 위로 밀어주는 역할
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // 버튼 사이의 간격을 고르게
              children: [
                ElevatedButton(
                  onPressed: () => Get.to(FourthScreen()),  // 4th 화면으로 이동
                  child: Text('나의 루틴들'),
                ),
                ElevatedButton(
                  onPressed: () => Get.to(FifthScreen()),  // 5th 화면으로 이동
                  child: Text('진행도'),
                ),
                ElevatedButton(
                  onPressed: () => Get.to(Sixth1Screen()),  // 6-1 화면으로 이동
                  child: Text('나의 개인정보'),
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

class Sixth1Screen extends StatelessWidget {
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
            Text('나의 개인정보'),
            ElevatedButton(
              onPressed: () => Get.to(SixthScreen()),  // 6th 화면으로 돌아가기
              child: Text('나의 프로필'),
            ),
          ],
        ),
      ),
    );
  }
}