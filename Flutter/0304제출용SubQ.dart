/*
[회고]
1) 앱바에 아이콘을 넣었을 때, 텍스트의 중앙 정렬을 위해선, Center() 가 아닌 centerTitile 속성을 설정해주어야 함을 배웠음
2) 앱바의 아이콘을 누름으로써 사이드 메뉴를 열리게끔 하려면, leading 내에 Builder로 묶어줘야 함을 배웠음. (context를 가져옴으로써 사이드 메뉴 오픈이 가능해지기 때문)
3) Stack 내 Container의 위치를 따로 지정해주지 않으면, 왼쪽 상단 좌표가 디폴트값으로 설정됨을 다시 한 번 확인하였음.
4) Stack 내 Container의 정렬은 "alignment: Alignment.center" 등으로 설정 가능함을 배웠음
5) 사이드 메뉴 오픈을 위해선 Scaffold 구조 내에 있는 Drawer()를 사용하면 됨을 배웠음
 */

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  _buttonClick() {
    print("버튼이 눌렸습니다");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text("플러터 앱 만들기", style: TextStyle(color: Colors.white)),
                // title: Center => 타이틀을 중앙에 배치하고 싶어서 사용했으나, 약간 오른쪽으로 치우침
                // 아마 icon 때문에 오른쪽 옆으로 밀린 채 center를 정하는 것 같다
                // icon이 가로로 꽤 많은 공간을 차지하는 것 같다
                centerTitle: true, // title을 정확히 중앙에 배치
                backgroundColor: Colors.blue,
                //새로운 시도: 앱바 내의 메뉴 아이콘을 누르면, 유저 프로필 보여주는 사이드 메뉴 열림
                leading: Builder( // builder로 묶어주지 않으면 context 를 가져올 수 없다고 함... context를 못가져오면 openDrawer() 도 안됨.
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.menu),
                      color: Colors.white,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                )
            ),

            //새로운 시도: 사이드 메뉴 구현
            drawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/짱구.png'),
                    ),
                    accountName: Text("신짱구"),
                    accountEmail: Text("cant_stop_shin@gmail.com"),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    iconColor: Colors.blue.shade500,
                    title: Text('홈'),
                    onTap: () {},
                    trailing: Icon(Icons.navigate_next),
                  )
                ],
              ),
            ),
            body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: _buttonClick, child: Text("Text")),
                    SizedBox(height:50), // 버튼과 컨테이너 사이 공간 위해 빈 박스 생성
                    Stack(
                      //alignment: Alignment.center, // 이 코드를 포함하면, 박스들이 중앙 정렬
                      children: [
                        Container(width: 300, height: 300, color: Colors.blue.shade100),
                        Container(width: 240, height: 240, color: Colors.blue.shade200),
                        Container(width: 180, height: 180, color: Colors.blue.shade300),
                        Container(width: 120, height: 120, color: Colors.blue.shade400),
                        Container(width: 60, height: 60, color: Colors.blue.shade600),
                        /*
                  - Stack으로 쌓을 시, 좌표 초기값이 왼쪽 위로 설정되어 있기 때문에 위 코드에서는 딱히 position을 달아주지 않았다
                  - 그렇지만 이건 이번 케이스에만 국한된 상황이고... 5개 박스 위치를 개별적으로 조정할 상황이 생길 수 있으니
                  - 아래 코드처럼 position을 일일이 달아주는 것도 시도해보았음
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
                   */
                      ],
                    )
                  ],
                )
            )
        )
    );
  }
}