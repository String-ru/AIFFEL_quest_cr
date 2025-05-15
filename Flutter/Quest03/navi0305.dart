// 류지호, 공옥례 team 퀘스트 회고
// StatefulWidget과 StatelessWidget의 차이를 명확히 이해할 수 있었다.
// StatefulWidget은 상태를 변경하고 UI를 갱신할 수 있기 때문에,
// FirstPage에서 버튼 클릭 시 상태를 변경하고 UI를 업데이트할 수 있었다.
// 반면 StatelessWidget은 상태를 변경할 일이 없고, 받은 데이터를 기반으로 UI만 그려주기 때문에
// SecondPage에서는 상태 변경 없이 화면을 그릴 수 있었다.
// Navigator.pushNamed와 Navigator.popUntil을 활용한 화면 간 이동과 상태 전달을 다루면서,
// 특히 arguments를 사용해 데이터를 전달하는 방법을 배우고,
// popUntil을 활용해 이전 화면으로 돌아가는 방법을 익혔다.
// GestureDetector를 사용하여 이미지에 터치 이벤트를 추가하고,
// 그 이벤트를 활용해 팝업을 띄우고,
// showDialog를 사용해 간단한 알림창을 띄우는 방식도 시도했다.
// Flutter에서 이미지 처리 및 아이콘 사용 방법도 이전과 다르게,
// FontAwesomeIcons를 통해 앱바에 아이콘을 추가하고,
// Image.asset을 사용해 이미지를 화면에 출력하는 방법을 사용해보았다.
// Navigator 화면에서 가고 돌아오는 과정을 1차 전달, 2차 stck 제거 하면서 돌아와야 되는데
// 결과 값이 고양이:true 강아지: false 가 안나오고 계속 true, true 가 나오거나
// false, false 가 나와서 그 오류를 잡으려고 5-6번 수정했다.
// 자꾸 수정을 하다보니 조금 더 코드가 보이는 것 같다.

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';  // font_awesome_flutter import 추가

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '0306 퀘스트27 <다음 화면으로 넘어가보자!>',
      initialRoute: '/',
      routes: {
        '/': (context) => FirstPage(),
        '/second': (context) => SecondPage(),
      },
    );
  }
}

class FirstPage extends StatefulWidget {
  // is_cat 상태 관리
  // Next를 눌러서 SecondPage로 넘어감
  // StatefulWidget을 사용하는 이유
  // is_cat 변수를 setState()로 변경해야 함
  // setState(() { isCat = false; });처럼 UI를 업데이트하는 기능도 있음
  @override
  _FirstPageState createState() => _FirstPageState();
}
// FirstPage 상태 관리
// isCat 값을 true/false로 변경

class _FirstPageState extends State<FirstPage> {
  bool isCat = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(FontAwesomeIcons.cat), // 고양이 아이콘
        centerTitle: true,
        title: Text("First Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // is_cat을 false로 변경하고 SecondPage로 이동하면서 전달
                setState(() {
                  isCat = false;
                });
                Navigator.pushNamed(
                  context,
                  '/second',
                  arguments: isCat, // is_cat을 전달
                );
              },
              child: Text('Next'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print("is_cat: $isCat");
              },
              child:
              // Image(
              //   image: AssetImage('assets/images/cat.png'), // 고양이 이미지 적용
              // 2가지 표현 모두 가능
              // AssetImage를 사용하기 때문
              // AssetImage는 ImageProvider의 하위 Class
              Image.asset(
                'assets/images/cat.png',
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  // isCat 값을 받아 강아지 이미지를 표시
  // "Back" 버튼을 통해 FirstPage로 돌아감
  // StatelessWidget을 사용하는 이유
  // is_cat 값을 전달받기만 하고, 변경하지 않음
  // 내부에서 setState()를 호출할 일이 없음
  // 그냥 UI만 바꾸면 되므로 StatelessWidget으로 충분함
  @override
  Widget build(BuildContext context) {
    // FirstPage에서 전달된 is_cat 받기
    final bool isCat = ModalRoute.of(context)!.settings.arguments as bool;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(FontAwesomeIcons.dog), // 강아지 아이콘
        centerTitle: true,
        title: Text("Second Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Back 버튼 클릭 시 페이지 스택 삭제하고 is_cat을 true로 전달하여 FirstPage로 돌아감
                Navigator.popUntil(context, ModalRoute.withName('/'));
                // Navigator.pushNamed(
                //   context,
                //   '/',
                //   arguments: true, // is_cat을 true로 설정하여 전달
                // );
                // popUntil을 사용하면 어차피 FirstPage가 남아있다.
                // 따라서 굳이 여기서도 pushNamed()를 사용할 필요가 없다.
                // popUntil()만으로도 이미 SecondPage를 없애면서 FirstPage로 돌아간다.
                // 충격
                // 잊어버린 중요한 1가지 사실...
                // is_cat의 값을 true로 바꿔서 전달해야 한다.
                // 지금 이렇게 진행하면 다시 FirstPage로 돌아가서 이미지를 누르면
                // True가 아닌 False값이 console창에 뜬다.
                // 결국에 했던 방식대로 복귀했다...ㅜㅜ
                Navigator.pushNamed(
                  context,
                  '/',
                  arguments: true, // is_cat을 true로 설정하여 전달
                );
              },
              child: Text('Back'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print("is_cat: $isCat");
                // 불쌍한 강아지의 속마음
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("나도 고양이가 되고 싶다..."),
                      content: Text("False는 기분나빠"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
                          child: Text(
                            "미안해",
                            style: TextStyle(fontSize: 14, color: Colors.blue), // '미안해' 글씨 스타일 설정
                          ),
                        ),
                      ],
                    );
                  },
                );
                // 강아지를 외면하고 싶다면
                // showDialog( 부터 여기까지 주석처리하면 됩니다.
              },
              child:
              // Image(
              //   image: AssetImage('assets/images/dog.png'), // 강아지 이미지 적용
              // 2가지 표현 모두 가능
              // AssetImage를 사용하기 때문
              // AssetImage는 ImageProvider의 하위 Class
              Image.asset(
                'assets/images/dog.png',
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
