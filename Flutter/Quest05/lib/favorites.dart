// 최종본
// 최종본에 대한 회고 (favorites.dart를 작성하며)
// FavoritesScreen(즐겨찾기 목록)과 WeatherScreen(날씨 표시 화면)을
// 두 개의 StatefulWidget으로 분리하여 코드의 가독성을 높였습니다.
// 즐겨찾기 화면을 떠났을 때 다시 돌아오면 즐겨찾기 목록이 저장되지 않는 오류가 있었습니다.
// favoriteCities 리스트가 앱을 재시작하거나 화면을 전환할 때 메모리 상에만 존재하고, 로컬 저장소에 저장하지 않았던 문제였습니다.
// SharedPreferences를 사용하여 선택한 도시를 로컬에 저장하고 불러오는 기능을 구현했습니다.
// 이를 통해 앱을 종료하고 다시 열어도 즐겨찾기 도시 목록이 유지됐습니다.
// 추가적으로 더 나은 UX/UI 디자인을 고려해보고 싶습니다.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_service.dart';

// 즐겨찾기 해놓은 도시 목록 화면
class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteCities = []; // 즐겨찾기 목록

  @override
  void initState() {
    super.initState();
    _loadFavoriteCities(); // 즐겨찾기 불러오기
  }

  // 즐겨찾기 불러오는 함수
  void _loadFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteCities = prefs.getStringList('favoriteCities') ?? [];
    });
  }

  // 즐겨찾기 저장하는 함수
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
            onPressed: _showAddCityDialog, // 도시 추가 다이얼로그
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: favoriteCities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteCities[index]),
            onTap: () => _showWeatherForCity(favoriteCities[index]), // 선택한 도시의 날씨 data 보기
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeCity(index), // 삭제
            ),
          );
        },
      ),
    );
  }

  // 도시 추가 다이얼로그 표시 함수
  void _showAddCityDialog() {
    final TextEditingController _cityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('도시 추가'),
          content: TextField(
            controller: _cityController,
            decoration: InputDecoration(labelText: '도시 이름'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final city = _cityController.text.trim();
                if (city.isNotEmpty && !favoriteCities.contains(city)) {
                  setState(() {
                    favoriteCities.add(city);
                  });
                  _saveFavoriteCities(); // 즐겨찾기 목록 저장
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

  // 삭제
  void _removeCity(int index) {
    setState(() {
      favoriteCities.removeAt(index);
    });
    _saveFavoriteCities();
  }

  // 선택한 도시의 날씨 data 화면으로 이동하는 함수
  void _showWeatherForCity(String city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherScreen(cityName: city),
      ),
    );
  }
}

// 날씨 data 표시
class WeatherScreen extends StatefulWidget {
  final String cityName;

  WeatherScreen({required this.cityName});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>>? _weatherFuture; // 날씨 data 저장하는 Future 객체
  String? _errorMessage; // 오류 메시지
  Color _backgroundColor = Colors.white; // 배경색 변수

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  // 날씨 data 불러오는 함수
  Future<void> _fetchWeather() async { // 날씨 data 가져오기
    setState(() {
      _weatherFuture = WeatherService.getWeather(widget.cityName).catchError((error) {
        setState(() {
          _errorMessage = '오류 발생: $error';
        });
      });
    });
  }

  //기온에 따른 배경색을 설정하는 함수
  void _updateBackgroundColor(double temp) {
    if (temp <= -13) {
      _backgroundColor = Colors.blue.shade900; // 매우 추운 날씨
    } else if (temp > -13 && temp <= -8) {
      _backgroundColor = Colors.blue.shade700; // 추운 날씨
    } else if (temp > -8 && temp <= -1) {
      _backgroundColor = Colors.blue.shade400; // 꽤 추운 날씨
    } else if (temp > -1 && temp <= 5) {
      _backgroundColor = Colors.blue.shade200; // 조금 추운 날씨
    } else if (temp > 5 && temp <= 9) {
      _backgroundColor = Colors.green.shade200; // 쌀쌀한 날씨
    } else if (temp > 9 && temp <= 11) {
      _backgroundColor = Colors.green.shade400; // 서늘한 날씨
    } else if (temp > 11 && temp <= 16) {
      _backgroundColor = Colors.orange.shade300; // 따뜻한 날씨
    } else if (temp > 16 && temp <= 19) {
      _backgroundColor = Colors.orange.shade500; // 맑고 따뜻한 날씨
    } else if (temp > 19 && temp <= 22) {
      _backgroundColor = Colors.orange.shade700; // 좀 더운 날씨
    } else if (temp > 22 && temp <= 27) {
      _backgroundColor = Colors.red.shade400; // 더운 날씨
    } else {
      _backgroundColor = Colors.red.shade700; // 매우 더운 날씨
    }
  }

  //기온에 따른 옷 추천
  String _getClothingRecommendation(double temp) {
    if (temp <= -13) {
      return '엄청 추워요. 롱패딩, 목도리, 장갑을 추천드려요. 히트텍과 핫팩은 필수!';
    } else if (temp > -13 && temp <= -8) {
      return '많이 추워요. 롱패딩, 터틀넥, 기모제품을 추천해요. 핫팩 챙기는 센스!';
    } else if (temp > -8 && temp <= -1) {
      return '꽤 추워요. 롱패딩, 두꺼운 니트, 기모제품을 추천해요.';
    } else if (temp > -1 && temp <= 5) {
      return '추워요. 숏패딩, 터틀넥, 기모제품을 추천해요.';
    } else if (temp > 5 && temp <= 9) {
      return '날이 쌀쌀해요. 코트, 울니트, 청바지, 가죽자켓을 추천해요.';
    } else if (temp > 9 && temp <= 11) {
      return '공기가 서늘해요. 트렌치코트, 맨투맨, 청바지를 추천해요.';
    } else if (temp > 11 && temp <= 16) {
      return '자켓, 야상, 면니트, 청바지를 추천해요. 가디건 입기 좋은 날씨!';
    } else if (temp > 16 && temp <= 19) {
      return '면니트, 맨투맨, 청바지를 추천해요.';
    } else if (temp > 19 && temp <= 22) {
      return '날이 따뜻해요. 긴팔티, 청바지, 면바지를 추천해요.';
    } else if (temp > 22 && temp <= 27) {
      return '조금 더울 수 있어요. 반팔티, 반바지, 운동화를 추천해요. 셔츠 입기 좋은 날씨!';
    } else {
      return '많이 더워요. 반팔티, 민소매, 반바지, 샌들을 추천해요.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.cityName} 날씨')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: _backgroundColor, // 배경색 변경
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
                    final temp = weatherData['temp'];
                    _updateBackgroundColor(temp); // 기온에 따라 배경색 업데이트
                    final clothingRecommendation = _getClothingRecommendation(temp);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('도시: ${widget.cityName}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('현재 온도: ${temp}°C'),
                        Text('체감 온도: ${weatherData['feels_like']}°C'),
                        Text('바람 속도: ${weatherData['wind_speed']} m/s'),
                        Text('강수량: ${weatherData['rain']} mm'),
                        Text('날씨 상태: ${weatherData['weather_description']}'),
                        SizedBox(height: 20),
                        Text('👕 의상 추천: $clothingRecommendation',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      ], // 배경색과 글자색이 겹쳐서 안 보이지 않도록 글자색을 black으로 설정
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
