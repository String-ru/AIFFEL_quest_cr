// 최종본
// 검색에 번역 기능 넣는 것은 아쉽게도 실패 - 이것에 대한 회고는 mistakes.dart에 적었습니다.
// 최종본에 대한 회고 (main.dart를 작성하며)
// FutureBuilder를 사용할 때 snapshot.hasError와 _errorMessage 처리를 꼭 동시에 고려해야 한다는 점을 배웠습니다.
// catchError를 사용할 때 setState를 적절히 감싸지 않으면 상태 관리가 꼬일 수 있다는 점을 알게 되었습니다.
// Color.lerp를 활용해 온도에 따른 배경색을 자연스럽게 변하게 하는 로직을 구현했던 것이 디자인적인 면에서 인상깊었습니다.
// 검색 기능을 추가하면서 TextEditingController를 초기화하지 않으면 이전 입력값이 남아 있을 수 있다는 점도 기억에 남습니다.
// 오류가 생겼던 코드
// Text('최고 / 최저 기온: ${weatherData['temp_max']}°C / ${weatherData['temp_min']}°C'),
// Text('어제와의 기온 차이: ${weatherData['temp'] - weatherData['yesterday_temp']}°C'),
// api를 통해 불러올 수 있는 data의 디테일함에 한계가 있었습니다.
// 실제 하루의 최고 최저 기온과 어제와의 기온 차이를 표시하기에는 시간과 실력이 부족했습니다.
//  final airQualityData = await _weatherService.fetchAirQuality(lat, lon);
// 미세먼지도 표시하려고 했으나 유사한 문제로 인해 포기했습니다.


import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'favorites.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '날씨 앱',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherScreen(),
      routes: {
        '/favorites': (context) => FavoritesScreen(), // 즐겨찾기 페이지로 이동하는 라우트 추가
      },
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  String _cityName = 'Seoul'; // 서울로 예시 화면
  Future<Map<String, dynamic>>? _weatherFuture; // 날씨 정보 저장하는 Future 객체
  String? _errorMessage; // 오류 메시지 저장하는 변수
  String _outfitRecommendation = ''; // 추천 의상 정보 저장하는 변수

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // 초기 화면에서 기본 날씨 data 가져오기
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _weatherFuture = WeatherService.getWeather(_cityName).catchError((error) {
        setState(() {
          _errorMessage = '오류 발생: $error'; // 오류 발생 시 메시지 저장
        });
      });
    });
  }

  // 날씨 온도에 따라 의상 추천
  String _getOutfitRecommendation(double temperature) {
    if (temperature <= -13) {
      return '롱패딩, 목도리, 장갑, 핫팩, 기모제품';
    } else if (temperature > -13 && temperature <= -8) {
      return '롱패딩, 터틀넥, 목도리, 핫팩, 기모제품';
    } else if (temperature > -8 && temperature <= -1) {
      return '롱패딩, 터틀넥, 내복, 기모제품';
    } else if (temperature > -1 && temperature <= 5) {
      return '숏패딩, 터틀넥, 내복';
    } else if (temperature > 5 && temperature <= 9) {
      return '코트, 울니트, 청바지, 가죽자켓';
    } else if (temperature > 9 && temperature <= 11) {
      return '트렌치코트, 맨투맨, 청바지';
    } else if (temperature > 11 && temperature <= 16) {
      return '자켓, 야상, 긴팔티, 면니트, 청바지';
    } else if (temperature > 16 && temperature <= 19) {
      return '가디건, 면니트, 긴팔티, 청바지';
    } else if (temperature > 19 && temperature <= 22) {
      return '맨투맨, 청바지, 면바지, 운동화';
    } else if (temperature > 22 && temperature <= 27) {
      return '셔츠, 반팔티, 반바지, 운동화';
    } else {
      return '반팔티, 민소매, 반바지, 샌들';
    }
  }

  // 기온에 따른 배경색 설정
  Color _getBackgroundColor(double temperature) {
    if (temperature < 0) {
      return Color.lerp(Colors.blue, Colors.white, -temperature / 30)!; // 낮은 온도일수록 점진적으로 파란색
    } else {
      return Color.lerp(Colors.white, Colors.red, temperature / 40)!; // 높은 온도일수록 점진적으로 붉은색
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('날씨 앱'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites'); // 즐겨찾기 page로 이동
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '도시 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _cityName = _controller.text;
                    _errorMessage = null;
                    _outfitRecommendation = ''; // 새 도시로 변경 시 의상 초기화
                  });
                  _fetchWeather();
                }
              },
              child: Text('검색'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // data 로딩 중 표시
                  } else if (snapshot.hasError || _errorMessage != null) {
                    return Center(
                      child: Text(_errorMessage ?? '데이터를 불러오지 못했습니다.'),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('날씨 데이터를 가져올 수 없습니다.'));
                  }

                  final weatherData = snapshot.data!;
                  final temperature = weatherData['temp'];
                  _outfitRecommendation = _getOutfitRecommendation(temperature); // 온도에 따른 의상 추천

                  // 배경색 설정
                  final backgroundColor = _getBackgroundColor(temperature);

                  return Container(
                    color: backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('도시: $_cityName', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('현재 온도: ${weatherData['temp']}°C'),
                        Text('체감 온도: ${weatherData['feels_like']}°C'),
                        Text('바람 속도: ${weatherData['wind_speed']} m/s'),
                        Text('강수량: ${weatherData['rain']} mm'),
                        Text('날씨 상태: ${weatherData['weather_description']}'),
                        SizedBox(height: 20),
                        Text('추천 의상: $_outfitRecommendation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}