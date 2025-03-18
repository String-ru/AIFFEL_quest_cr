// 추가 기능(번역 검색) 실패 회고
// 영어로만 검색이 가능한 점이 한국인으로서 불편하다고 느껴서
// papago api키를 받아와서 자동번역(한글->영어)기능을 검색창에 추가하려고 했다.
// 하지만 XMLHttpRequest error로 인해 검색이 진행되지 않았다.
// 번역 버튼을 눌러도 출력이 없거나, 아예 검색이 되지 않았다.
// CORS(Cross-Origin Resource Sharing) 문제
// 현재 Gradle과 관련하여 이슈가 해결되지 않아서, Pixel 디바이스가 아닌 Web앱으로 진행하고 있다.
// API 서버가 CORS 정책을 설정하지 않아서 브라우저에서 요청이 차단될 수 있다고 한다.
// 특히 무료 API 키를 사용할 때 브라우저에서 직접 호출하면 CORS 차단이 걸릴 가능성이 높다고 한다.
// 나중에 Gradle관련 문제가 해결되면, 백엔드 프록시 서버를 사용하거나, 웹이 아닌 모바일(Android/iOS)로 실행해보면 성공할 것이다.

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'weather_service.dart';
// import 'favorites.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: '날씨 앱',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: WeatherScreen(),
//       routes: {
//         '/favorites': (context) => FavoritesScreen(), // 즐겨찾기 페이지 라우트 추가
//       },
//     );
//   }
// }
//
// class WeatherScreen extends StatefulWidget {
//   @override
//   _WeatherScreenState createState() => _WeatherScreenState();
// }
//
// class _WeatherScreenState extends State<WeatherScreen> {
//   final TextEditingController _controller = TextEditingController();
//   String _cityName = 'Seoul'; // 기본 도시 설정
//   Future<Map<String, dynamic>>? _weatherFuture; // 날씨 정보 저장
//   String? _errorMessage; // 오류 메시지 저장
//   String _outfitRecommendation = ''; // 의상 추천 저장
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchWeather(); // 초기 화면에서 날씨 가져오기
//   }
//
//   Future<void> _fetchWeather() async {
//     setState(() {
//       _weatherFuture = WeatherService.getWeather(_cityName).catchError((error) {
//         setState(() {
//           _errorMessage = '오류 발생: $error'; // 오류 처리
//         });
//       });
//     });
//   }
//
//   // Papago API를 사용한 번역 함수
//   Future<String> _translateCityName(String city) async {
//     final String clientId = "YOUR_CLIENT_ID"; // 네이버 Papago Client ID
//     final String clientSecret = "YOUR_CLIENT_SECRET"; // 네이버 Papago Client Secret
//     final String apiUrl = "https://openapi.naver.com/v1/papago/n2mt";
//
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
//         "X-Naver-Client-Id": clientId,
//         "X-Naver-Client-Secret": clientSecret,
//       },
//       body: {
//         "source": "ko",
//         "target": "en",
//         "text": city,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       return responseData['message']['result']['translatedText']; // 번역된 텍스트 반환
//     } else {
//       return city; // 번역 실패 시 원래 도시명 반환
//     }
//   }
//
//   // 의상 추천 함수
//   String _getOutfitRecommendation(double temperature) {
//     if (temperature <= -13) return '롱패딩, 목도리, 장갑, 핫팩, 기모제품';
//     if (temperature <= -8) return '롱패딩, 터틀넥, 목도리, 핫팩, 기모제품';
//     if (temperature <= -1) return '롱패딩, 터틀넥, 내복, 기모제품';
//     if (temperature <= 5) return '숏패딩, 터틀넥, 내복';
//     if (temperature <= 9) return '코트, 울니트, 청바지, 가죽자켓';
//     if (temperature <= 11) return '트렌치코트, 맨투맨, 청바지';
//     if (temperature <= 16) return '자켓, 야상, 긴팔티, 면니트, 청바지';
//     if (temperature <= 19) return '가디건, 면니트, 긴팔티, 청바지';
//     if (temperature <= 22) return '맨투맨, 청바지, 면바지, 운동화';
//     if (temperature <= 27) return '셔츠, 반팔티, 반바지, 운동화';
//     return '반팔티, 민소매, 반바지, 샌들';
//   }
//
//   // 배경색 설정 함수
//   Color _getBackgroundColor(double temperature) {
//     if (temperature < 0) {
//       return Color.lerp(Colors.blue, Colors.white, -temperature / 30)!;
//     } else {
//       return Color.lerp(Colors.white, Colors.red, temperature / 40)!;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('날씨 앱'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.favorite),
//             onPressed: () {
//               Navigator.pushNamed(context, '/favorites'); // 즐겨찾기 이동
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: '도시 입력',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_controller.text.isNotEmpty) {
//                   String translatedCity = await _translateCityName(_controller.text);
//                   setState(() {
//                     _cityName = translatedCity;
//                     _errorMessage = null;
//                     _outfitRecommendation = '';
//                   });
//                   _fetchWeather();
//                 }
//               },
//               child: Text('검색'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: FutureBuilder<Map<String, dynamic>>(
//                 future: _weatherFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError || _errorMessage != null) {
//                     return Center(
//                       child: Text(_errorMessage ?? '데이터를 불러오지 못했습니다.'),
//                     );
//                   } else if (!snapshot.hasData) {
//                     return Center(child: Text('날씨 데이터를 가져올 수 없습니다.'));
//                   }
//
//                   final weatherData = snapshot.data!;
//                   final temperature = weatherData['temp'];
//                   _outfitRecommendation = _getOutfitRecommendation(temperature);
//                   final backgroundColor = _getBackgroundColor(temperature);
//
//                   return Container(
//                     color: backgroundColor,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('도시: $_cityName', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                         Text('현재 온도: ${weatherData['temp']}°C'),
//                         Text('체감 온도: ${weatherData['feels_like']}°C'),
//                         Text('바람 속도: ${weatherData['wind_speed']} m/s'),
//                         Text('강수량: ${weatherData['rain']} mm'),
//                         Text('날씨 상태: ${weatherData['weather_description']}'),
//                         SizedBox(height: 20),
//                         Text('추천 의상: $_outfitRecommendation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
