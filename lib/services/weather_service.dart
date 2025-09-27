import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../config/api_config.dart';

class WeatherData {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;
  final double feelsLike;
  final int pressure;
  final int visibility;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.pressure,
    required this.visibility,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] ?? 0.0).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: (json['main']['humidity'] ?? 0.0).toDouble(),
      windSpeed: (json['wind']['speed'] ?? 0.0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0.0).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      visibility: json['visibility'] ?? 0,
    );
  }
}

class ForecastData {
  final DateTime date;
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String icon;
  final double humidity;

  ForecastData({
    required this.date,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.icon,
    required this.humidity,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] ?? 0.0).toDouble(),
      minTemp: (json['main']['temp_min'] ?? 0.0).toDouble(),
      maxTemp: (json['main']['temp_max'] ?? 0.0).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: (json['main']['humidity'] ?? 0.0).toDouble(),
    );
  }
}

class WeatherService {
  static Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Location Error: $e');
      return null;
    }
  }

  static Future<WeatherData?> getCurrentWeather({double? lat, double? lon, String? cityName}) async {
    try {
      String url;
      if (lat != null && lon != null) {
        url = '${ApiConfig.openWeatherBaseUrl}/weather?lat=$lat&lon=$lon&appid=${ApiConfig.openWeatherApiKey}&units=metric';
      } else if (cityName != null) {
        url = '${ApiConfig.openWeatherBaseUrl}/weather?q=$cityName&appid=${ApiConfig.openWeatherApiKey}&units=metric';
      } else {
        // Default to Delhi if no location provided
        url = '${ApiConfig.openWeatherBaseUrl}/weather?q=Delhi,IN&appid=${ApiConfig.openWeatherApiKey}&units=metric';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'CropSense-AI/1.0'},
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => throw Exception('Weather API timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Weather Error: $e');
      return null;
    }
  }

  static Future<List<ForecastData>> getWeatherForecast({double? lat, double? lon, String? cityName}) async {
    try {
      String url;
      if (lat != null && lon != null) {
        url = '${ApiConfig.openWeatherBaseUrl}/forecast?lat=$lat&lon=$lon&appid=${ApiConfig.openWeatherApiKey}&units=metric';
      } else if (cityName != null) {
        url = '${ApiConfig.openWeatherBaseUrl}/forecast?q=$cityName&appid=${ApiConfig.openWeatherApiKey}&units=metric';
      } else {
        // Default to Delhi if no location provided
        url = '${ApiConfig.openWeatherBaseUrl}/forecast?q=Delhi,IN&appid=${ApiConfig.openWeatherApiKey}&units=metric';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'CropSense-AI/1.0'},
      ).timeout(
        Duration(seconds: 8),
        onTimeout: () => throw Exception('Forecast API timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<ForecastData> forecasts = [];
        
        for (var item in data['list']) {
          forecasts.add(ForecastData.fromJson(item));
        }
        
        return forecasts.take(5).toList(); // Return next 5 forecasts
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      print('Forecast Error: $e');
      return [];
    }
  }

  static String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  static String getWeatherAdvice(String description, double temperature, String language) {
    final advice = <String, Map<String, String>>{
      'rain': {
        'en': 'Rainy weather detected. Avoid irrigation and consider covering sensitive crops.',
        'hi': 'बारिश का मौसम है। सिंचाई न करें और संवेदनशील फसलों को ढकने पर विचार करें।',
        'pa': 'ਮੀਂਹ ਦਾ ਮੌਸਮ ਹੈ। ਸਿੰਚਾਈ ਨਾ ਕਰੋ ਅਤੇ ਸੰਵੇਦਨਸ਼ੀਲ ਫਸਲਾਂ ਨੂੰ ਢੱਕਣ ਬਾਰੇ ਸੋਚੋ।',
      },
      'clear': {
        'en': 'Clear weather is good for fieldwork and harvesting activities.',
        'hi': 'साफ मौसम खेती के काम और फसल कटाई के लिए अच्छा है।',
        'pa': 'ਸਾਫ਼ ਮੌਸਮ ਖੇਤੀ ਦੇ ਕੰਮ ਅਤੇ ਫਸਲ ਕਟਾਈ ਲਈ ਚੰਗਾ ਹੈ।',
      },
      'hot': {
        'en': 'High temperature detected. Increase irrigation frequency and provide shade to livestock.',
        'hi': 'उच्च तापमान है। सिंचाई की आवृत्ति बढ़ाएं और पशुओं को छाया दें।',
        'pa': 'ਜ਼ਿਆਦਾ ਤਾਪਮਾਨ ਹੈ। ਸਿੰਚਾਈ ਦੀ ਬਾਰੰਬਾਰਤਾ ਵਧਾਓ ਅਤੇ ਪਸ਼ੂਆਂ ਨੂੰ ਛਾਂ ਦਿਓ।',
      },
    };

    if (description.toLowerCase().contains('rain') || description.toLowerCase().contains('drizzle')) {
      return advice['rain']?[language] ?? advice['rain']?['en'] ?? '';
    } else if (temperature > 35) {
      return advice['hot']?[language] ?? advice['hot']?['en'] ?? '';
    } else {
      return advice['clear']?[language] ?? advice['clear']?['en'] ?? '';
    }
  }
}