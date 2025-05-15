// 최종본
// 최종본에 대한 회고 (weather_service.dart를 작성하며)
// API 연동을 위해 http 패키지를 사용하면서 외부 데이터 요청 및 응답 처리에 대한 방법을 배웠습니다.
// json.decode를 사용하여 JSON 데이터를 Map으로 변환하는 방법을 익혔습니다.
// HTTP 요청의 응답 상태 코드에 따라 적절한 처리를 해야 한다는 점을 다시 한 번 인식했습니다.
// 특히 정상적인 응답을 받지 못했을 때의 오류 처리가 중요했습니다.
// 오류를 처리하는 과정에서,
// throw Exception()을 통해 예외를 던져 오류 발생 시 빠르게 문제를 추적할 수 있다는 점을 알게 되었습니다.
// 날씨 데이터를 다룰 때, 강수량이 없는 경우 기본값으로 0을 설정하여 에러를 방지했습니다.

import 'dart:convert'; // JSON data 다루는 라이브러리
import 'package:http/http.dart' as http; // HTTP 요청 위한 패키지

class WeatherService {
  static const String _apiKey = '16b1dd961c790fd8b482333446b237b0'; // 외부 API 연동 (OpenWeather)
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // 특정 도시 날씨 data 가져오는 함수
  static Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric');

    final response = await http.get(url); // HTTP GET 요청 보내기
    if (response.statusCode == 200) { // 응답 정상인 경우
      final data = json.decode(response.body); // JSON data를 Map 형태로 변환
      return {
        'temp': data['main']['temp'], // 현재 기온
        'feels_like': data['main']['feels_like'], // 체감 온도
        'wind_speed': data['wind']['speed'], // 풍속
        'rain': data['rain'] != null ? data['rain']['1h'] ?? 0 : 0, // 강수량
        'weather_description': data['weather'][0]['description'], // 날씨 상태
      };
    } else {
      throw Exception('날씨 정보를 불러오는 데 실패했습니다.'); // 오류 발생
    }
  }
}