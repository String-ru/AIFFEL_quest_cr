import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '5thand5-1screen.dart';  // 5th 화면 import
import '6thand6-1screen.dart';  // 6th 화면 import

// NoteController 클래스
class NoteController extends GetxController {
  // 노트를 저장할 리스트
  var notes = <Map<String, String>>[].obs;

  // 노트 추가하는 함수
  void addNote(String title, String content) {
    notes.add({'title': title, 'content': content});
  }

  // 노트 내용 가져오는 함수
  List<Map<String, String>> getNotes() {
    return notes;
  }
}

// FourthScreen 클래스 (StatefulWidget 유지)
class FourthScreen extends StatefulWidget {
  @override
  _FourthScreenState createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  // 텍스트 입력용 컨트롤러
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  // 새로운 노트 추가하기
  void addNote() {
    // NoteController에 데이터 추가
    Get.find<NoteController>().addNote(titleController.text, contentController.text);
    titleController.clear();
    contentController.clear();
    Get.back(); // 창 닫기
    setState(() {}); // 상태 변경을 알리기 위해 setState 호출
  }

  // 새로운 노트를 입력받을 팝업 창
  void showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('새로운 노트 추가'),
          content: SingleChildScrollView(  // 텍스트가 길어지면 스크롤되도록
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: '제목'),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: '내용'),
                  maxLines: 4,  // 입력 가능한 라인 수 조정
                  style: TextStyle(fontSize: 14),  // 글씨 크기 조정
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: addNote,
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/routine_logo.png', width: 40),
          onPressed: () => Get.back(), // 로고 클릭 시 뒤로가기
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('나의 루틴들'),
          SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final notes = Get.find<NoteController>().getNotes();
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    title: Text(note['title'] ?? ''),
                    subtitle: Text(
                      (note['content'] ?? '').length > 15
                          ? (note['content'] ?? '').substring(0, 15) + '...'
                          : note['content'] ?? '',
                    ),
                    onTap: () {
                      // 노트 내용 상세 보기
                      Get.to(() => NoteDetailScreen(note: note));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddNoteDialog, // + 버튼 눌렀을 때 다이얼로그 열기
        child: Image.asset('assets/images/routine_logo.png'),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(Fourth1Screen()),  // 4-1 화면으로 이동
              child: Text('세부 설정'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(FifthScreen()),  // 5th 화면으로 이동
              child: Text('진행도'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(SixthScreen()),  // 6th 화면으로 이동
              child: Text('나의 프로필'),
            ),
          ],
        ),
      ),
    );
  }
}

// Fourth1Screen 클래스
class Fourth1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/routine_logo.png', width: 40),
          onPressed: () => Get.back(), // 로고 클릭 시 뒤로가기
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('쓰임새를 아직 못 정한 화면'),
            ElevatedButton(
              onPressed: () => Get.back(),  // 4th 화면으로 돌아가기
              child: Text('나의 루틴들'),
            ),
          ],
        ),
      ),
    );
  }
}

// NoteDetailScreen 클래스 (노트 상세 화면)
class NoteDetailScreen extends StatelessWidget {
  final Map<String, String> note;

  NoteDetailScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/routine_logo.png', width: 40),
          onPressed: () => Get.back(), // 로고 클릭 시 뒤로가기
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note['title'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              note['content'] ?? '',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
