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
        '/favorites': (context) => FavoritesScreen(), // 즐겨찾기 페이지 라우트 추가
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
  String _cityName = 'Seoul'; // 기본 도시
  Future<Map<String, dynamic>>? _weatherFuture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _weatherFuture = WeatherService.getWeather(_cityName).catchError((error) {
        setState(() {
          _errorMessage = '오류 발생: $error';
        });
      });
    });
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
              Navigator.pushNamed(context, '/favorites'); // 즐겨찾기 페이지로 이동
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
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || _errorMessage != null) {
                    return Center(
                      child: Text(_errorMessage ?? '데이터를 불러오지 못했습니다.'),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('날씨 데이터를 가져올 수 없습니다.'));
                  }

                  final weatherData = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('도시: $_cityName', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('현재 온도: ${weatherData['temp']}°C'),
                      Text('체감 온도: ${weatherData['feels_like']}°C'),
                      Text('바람 속도: ${weatherData['wind_speed']} m/s'),
                      Text('강수량: ${weatherData['rain']} mm'),
                      Text('날씨 상태: ${weatherData['weather_description']}'),
                    ],
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