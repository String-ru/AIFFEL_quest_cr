import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { // state없는 위젯 구현
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // appbar 색상 blue
          title: Text('플러터 앱 만들기'), // 타이틀 달기
          // title: Center( // 상단 중앙에 배치..?? 약간 오른쪽으로 치우침
          // 아마 icon 때문에 오른쪽 옆으로 밀린 채 center를 정하는 것 같다
          // icon이 가로로 꽤 많은 공간을 차지하는 것 같다
          centerTitle: true, // title을 정확히 중앙에 배치
          leading: IconButton( // icon 생성
            icon: Icon(Icons.star), // 별 아이콘!
            onPressed: () {}, // 눌러도 아무 반응 X
          ),
        ),
        body: Center( // 자식들 화면 중앙에 위치
          child: Column( // 세로로 정렬
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton( // 버튼
                onPressed: () { // 누르면 반응 O
                  print("버튼이 눌렸습니다"); // 콘솔 창에 출력
                },
                child: Text('Text'), // Text 라고 표기된 Button
              ),
              SizedBox(height: 50), // 버튼 조금 아래에 쌓기
              Stack( // 5개 container 쌓기
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.red,
                  ),
                  Positioned( // (0, 0)으로 왼쪽 구석부터 쌓기
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 240,
                      height: 240,
                      color: Colors.orange,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 180,
                      height: 180,
                      color: Colors.yellow,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 120,
                      height: 120,
                      color: Colors.green,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}