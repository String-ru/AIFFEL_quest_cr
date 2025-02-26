import 'dart:async';

void main() {
  print('flutter: Pomodoro 타이머를 시작합니다.');

  int cycleCount = 0; // 사이클 카운트
  int workTime = 25; // 작업 시간 (초)
  int breakTime = 5; // 휴식 시간 (초)
  int longBreakTime = 15; // 긴 휴식 시간 (초)

  Timer? timer;

  // 타이머가 1초마다 실행되는 부분
  void startTimer(int seconds, String phase) {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (seconds > 0) {
        print('flutter: $seconds');
        seconds--;
      } else {
        // 작업/휴식 후 다음 사이클로 이동
        if (phase == '작업') {
          print('flutter: 작업 완료! 휴식 시간입니다.');
          if (++cycleCount % 4 == 0) {
            // 4번째 사이클에 긴 휴식 적용
            startTimer(longBreakTime, '긴 휴식');
          } else {
            startTimer(breakTime, '휴식');
          }
        } else if (phase == '휴식' || phase == '긴 휴식') {
          print('flutter: 휴식 완료! 작업 시간입니다.');
          startTimer(workTime, '작업');
        }
      }
    });
  }

  // 타이머 시작: 처음에는 작업 시간부터 시작
  startTimer(workTime, '작업');
}