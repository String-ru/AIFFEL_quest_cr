import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = '16b1dd961c790fd8b482333446b237b0';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'temp': data['main']['temp'],
        'feels_like': data['main']['feels_like'],
        'wind_speed': data['wind']['speed'],
        'rain': data['rain'] != null ? data['rain']['1h'] ?? 0 : 0, // 강수량 (없으면 0)
        'weather_description': data['weather'][0]['description'], // 날씨 상태
      };
    } else {
      throw Exception('날씨 정보를 불러오는 데 실패했습니다.');
    }
  }
}