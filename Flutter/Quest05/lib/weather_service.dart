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