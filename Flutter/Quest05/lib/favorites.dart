import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 추가된 부분
import 'weather_service.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteCities = []; // 즐겨찾기 도시 목록

  @override
  void initState() {
    super.initState();
    _loadFavoriteCities(); // 앱이 시작될 때 즐겨찾기 도시 목록을 불러옴
  }

  // 즐겨찾기 도시 목록을 SharedPreferences에서 불러오는 함수
  void _loadFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteCities = prefs.getStringList('favoriteCities') ?? [];
    });
  }

  // 즐겨찾기 도시 목록을 SharedPreferences에 저장하는 함수
  void _saveFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteCities', favoriteCities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기 도시'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddCityDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: favoriteCities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteCities[index]),
            onTap: () => _showWeatherForCity(favoriteCities[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeCity(index),
            ),
          );
        },
      ),
    );
  }

  // 도시 추가 다이얼로그
  void _showAddCityDialog() {
    final TextEditingController _cityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('도시 추가'),
          content: TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: '도시 이름',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final city = _cityController.text.trim();
                if (city.isNotEmpty && !favoriteCities.contains(city)) {
                  setState(() {
                    favoriteCities.add(city);
                  });
                  _saveFavoriteCities(); // 도시 추가 후 저장
                  Navigator.pop(context);
                }
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // 즐겨찾기에서 도시 삭제
  void _removeCity(int index) {
    setState(() {
      favoriteCities.removeAt(index);
    });
    _saveFavoriteCities(); // 도시 삭제 후 저장
  }

  // 날씨 화면으로 이동
  void _showWeatherForCity(String city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherScreen(cityName: city),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  final String cityName;

  WeatherScreen({required this.cityName});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>>? _weatherFuture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _weatherFuture = WeatherService.getWeather(widget.cityName).catchError((error) {
        setState(() {
          _errorMessage = '오류 발생: $error';
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.cityName} 날씨')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: Text('새로고침'),
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
                      Text('도시: ${widget.cityName}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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