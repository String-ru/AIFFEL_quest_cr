// Correct_coding_quest01
// (C2조 pair) 이하은, 류지호

// 1. 타이머 시작 → "Pomodoro 타이머를 시작합니다." 출력
// 2. 25분 작업 시간 → 1초씩 감소하면서 콘솔에 출력
// 3. 5분 휴식 시간 (4회차 전까지) → 1초씩 감소하면서 콘솔에 출력
// 4. 4회차 후 15분 휴식 → 1초씩 감소하면서 콘솔에 출력
// 5. 반복 → 4회 반복 후 초기화

// Timer.periodic? : 다트의 비동기 타이머로, 일정한 주기마다 특정 함수를 실행하는 역할을 수행.
// 일정 간격으로 반복 실행할 때 유용하다.

import 'dart:async'; // Timer를 사용하기 위해 import 하기.

// Wrong_coding:
// // 함수로 타이머 만들어보고, 안되면 나중에 클래스 시도.
// void main() {
//   print('flutter: Pomodoro 타이머를 시작합니다.');
//
//   int cycleCount = 0; // 사이클 카운트
//   const int workTime = 25; // 작업 시간 (초) // 작업 시간, 휴식 시간을 이후에 수정할 일이 없으니 const로 선언.
//   const int breakTime = 5; // 휴식 시간 (초)
//   const int longBreakTime = 15; // 긴 휴식 시간 (초)
//
//   Timer? timer;
//
//   // 타이머가 1초마다 실행되는 부분
//   void startTimer(int seconds, String phase) {
//     timer = Timer.periodic(Duration(seconds: 1), (Timer) {
//       if (seconds > 0) { // seconds(초)가 0이 아닐 때 실행.
//         print('flutter: $seconds'); // seconds(초) count 출력하기.
//         seconds--; // seconds(초)를 1초 씩 감소하기.
//       } else {
//         // 작업/휴식 후 다음 사이클로 이동.
//         // 문제 : '작업', '휴식', '작업', '휴식', '작업', '휴식','작업', '긴 휴식' 이라는 list를 추가 해봐도 되지 않을까..?
//         if (phase == '작업') {
//           print('flutter: 작업 완료! 휴식 시간입니다.');
//           if (++cycleCount % 4 == 0) {
//             // 4번째 사이클에 긴 휴식 적용
//             startTimer(longBreakTime, '긴 휴식');
//           } else {
//             startTimer(breakTime, '휴식');
//           }
//         } else if (phase == '휴식' || phase == '긴 휴식') {
//           print('flutter: 휴식 완료! 작업 시간입니다.');
//           startTimer(workTime, '작업');
//         }
//       }
//     });
//   }
//
//   // 타이머 시작: 처음에는 작업 시간부터 시작
//   startTimer(workTime, '작업'); // 문제 : 따로 '휴식', '긴 휴식'을 정의하지 않아서 '작업'만 계속 순환되고 여러 타이머 동시에 작동하는 현상이 보였다.
// }   // 문제 : // 타이머 cancel 없었다!


// PomodoroTimer 클래스 내에서 작업 시간, 휴식 시간, 긴 휴식 시간을 정의했다. 이를 기반 삼아서 사이클이 시작된다.
// startTimer를 여러 번 사용한 Wrong_coding_quest01 과의 차이점이 벌써 확인된다.
class PomodoroTimer {
  static const int workDuration = 25 * 1; // 25분
  static const int shortBreakDuration = 5 * 1; // 5분
  static const int longBreakDuration = 15 * 1; // 15분
  int cycleCount = 0; // 현재 사이클 개수
  // Timer.periodic을 사용하여 workDuration, shortBreakDuration, longBreakDuration을 1초씩 감소시킨다.

  void start() {
    print("Pomodoro 타이머를 시작합니다.");
    _startWorkSession();
  }
  // 작업 세션 (휴식 세션과의 분리)
  void _startWorkSession() {
    if (cycleCount == 4) {
      print('4회 작업 완료! Pomodoro 타이머를 종료합니다.');
      return;
    }
    int timeLeft = workDuration; // timeLeft를 workDuration로 초기화
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) { // 시간이 0초 이상 남았을 때만 실행
        int minutes = timeLeft ~/ 1; // timeLeft를 1로 나눈 몫을 분으로 계산
        int seconds = timeLeft % 1; // timeLeft를 1로 나눈 나머지를 초로 계산
        print("flutter: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}");
        timeLeft--; 변수 timeLeft를 1씩 감소
      } else {
      timer.cancel(); // 새 타이머 시작을 위해 현재 타이머 종료
      cycleCount++; // 변수 cycleCount를 1씩 증가
      print("작업 시간이 종료되었습니다. 휴식 시간을 시작합니다.");
      _startBreakSession();
      }
    });
  }
  // 휴식 세션 (작업 세션과의 분리)
  void _startBreakSession() {
    int breakDuration = (cycleCount % 4 == 0) ? longBreakDuration : shortBreakDuration; // 4 사이클 돌고 프로그램 종료. 긴 휴식시간 적용.
    // 여기서 ?는 null 안정성을 위한 것이 아님. "삼항 연산자"의 기능을 가지고 있음.
    // ? 앞의 조건 (cycleCount % 4 == 0)가 참이면 longBreakDuration를 선택.
    // ? 앞의 조건 (cycleCount % 4 == 0)가 거짓이면 shortBreakDuration를 선택.
    int timeLeft = breakDuration; // timeLeft를 breakDuration로 초기화

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) { // 시간이 0초 이상 남았을 때만 실행
        int minutes = timeLeft ~/ 1; // timeLeft를 1로 나눈 몫을 분으로 계산
        int seconds = timeLeft % 1; // timeLeft를 1로 나눈 나머지를 초로 계산
        print("flutter: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}");
        timeLeft--; // 변수 timeLeft를 1씩 감소
      } else {
        timer.cancel(); // 새 타이머 시작을 위해 현재 타이머 종료
        print("휴식 시간이 종료되었습니다. 다음 작업을 시작합니다.");
        _startWorkSession();
      }
    });
  }
}
// 프로그램 시작 및 객체 생성
// start 호출
void main() {
  PomodoroTimer timer = PomodoroTimer();
  timer.start();
}

// 최종 요약
// workDuration, shortBreakDuration, longBreakDuration 값을 설정했다.
// Timer.periodic을 사용하여 매 1초마다 시간이 감소하면서 minute:second 형식으로 출력한다.
// 타이머가 종료되면 timer.cancel()을 통해 타이머를 종료한다.
// 새 타이머를 시작하여 각 세션이 정상적으로 반복된다.