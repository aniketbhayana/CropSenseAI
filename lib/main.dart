import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:math';
import 'services/chatgpt_service.dart';
import 'services/weather_service.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(CropSenseApp());
}

class CropSenseApp extends StatefulWidget {
  @override
  _CropSenseAppState createState() => _CropSenseAppState();
}

class _CropSenseAppState extends State<CropSenseApp> {
  Locale _locale = const Locale('en', '');

  void changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CropSense AI',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFFF5F5DC),
        fontFamily: 'Roboto',
      ),
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('hi', ''),
        Locale('pa', ''),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: GetStartedScreen(onLanguageChanged: changeLanguage),
    );
  }
}

// Localization Helper
class AppText {
  static Map<String, Map<String, String>> _text = {
    'en': {
      'app_title': 'CropSense AI',
      'get_started': 'Get Started',
      'weather': 'Weather',
      'market_pricing': 'Market Pricing',
      'disease_check': 'Disease Check\n(Photo Upload)',
      'fertilizer_pesticide': 'Fertilizer/\nPesticide',
      'ask_anything': 'Ask me anything...',
      'upload': 'Upload',
      'organic_fertilizers': 'Organic Fertilizers',
      'chemical_fertilizers': 'Chemical Fertilizers',
      'pesticides': 'Pesticides',
      'advisory': 'Advisory',
      'forecast': 'Forecast for the week',
    },
    'hi': {
      'app_title': 'क्रॉपसेंस AI',
      'get_started': 'शुरू करें',
      'weather': 'मौसम',
      'market_pricing': 'बाज़ार भाव',
      'disease_check': 'रोग जांच\n(फोटो अपलोड)',
      'fertilizer_pesticide': 'उर्वरक/\nकीटनाशक',
      'ask_anything': 'कुछ भी पूछें...',
      'upload': 'अपलोड करें',
      'organic_fertilizers': 'जैविक उर्वरक',
      'chemical_fertilizers': 'रासायनिक उर्वरक',
      'pesticides': 'कीटनाशक',
      'advisory': 'सलाह',
      'forecast': 'सप्ताह का पूर्वानुमान',
    },
    'pa': {
      'app_title': 'ਕ੍ਰੋਪਸੈਂਸ AI',
      'get_started': 'ਸ਼ੁਰੂ ਕਰੋ',
      'weather': 'ਮੌਸਮ',
      'market_pricing': 'ਬਾਜ਼ਾਰ ਭਾਅ',
      'disease_check': 'ਬਿਮਾਰੀ ਜਾਂਚ\n(ਫੋਟੋ ਅਪਲੋਡ)',
      'fertilizer_pesticide': 'ਖਾਦ/\nਕੀਟਨਾਸ਼ਕ',
      'ask_anything': 'ਕੁਝ ਵੀ ਪੁੱਛੋ...',
      'upload': 'ਅਪਲੋਡ ਕਰੋ',
      'organic_fertilizers': 'ਜੈਵਿਕ ਖਾਦ',
      'chemical_fertilizers': 'ਰਸਾਇਣਿਕ ਖਾਦ',
      'pesticides': 'ਕੀਟਨਾਸ਼ਕ',
      'advisory': 'ਸਲਾਹ',
      'forecast': 'ਹਫ਼ਤੇ ਦਾ ਪੂਰਵ ਅਨੁਮਾਨ',
    },
  };

  static String get(String key, String langCode) {
    return _text[langCode]?[key] ?? _text['en']?[key] ?? key;
  }
}

// Language Selection Screen
class GetStartedScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;

  const GetStartedScreen({Key? key, required this.onLanguageChanged}) : super(key: key);

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  String selectedLanguage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Text(
                'Choose Your Language / भाषा चुनें / ਭਾਸ਼ਾ ਚੁਣੋ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLanguageOption('English', 'A', 'en'),
                  _buildLanguageOption('हिंदी', 'अ', 'hi'),
                  _buildLanguageOption('ਪੰਜਾਬੀ', 'ਅ', 'pa'),
                ],
              ),
              Spacer(flex: 2),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: selectedLanguage.isNotEmpty ? () {
                    widget.onLanguageChanged(selectedLanguage);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(selectedLanguage: selectedLanguage)),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB8D4B8),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    selectedLanguage.isEmpty ? 'Select Language' : AppText.get('get_started', selectedLanguage),
                    style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, String symbol, String code) {
    bool isSelected = selectedLanguage == code;
    return GestureDetector(
      onTap: () => setState(() => selectedLanguage = code),
      child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFB8D4B8) : Color(0xFFD3D3D3),
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(symbol, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(language, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  final String selectedLanguage;

  const HomeScreen({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F5DC),
              Color(0xFFF8F8F0),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Enhanced Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.get('app_title', selectedLanguage),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Smart Farming Companion',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFB8D4B8), Color(0xFF81C784)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 22,
                          child: Icon(Icons.person, color: Colors.white, size: 26),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
              Expanded(
                flex: 3,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildOptionCard(
                      AppText.get('fertilizer_pesticide', selectedLanguage),
                      Icons.eco, Color(0xFFB8D4B8),
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => FertilizerScreen(selectedLanguage: selectedLanguage))),
                    ),
                    _buildOptionCard(
                      AppText.get('weather', selectedLanguage),
                      Icons.wb_sunny, Color(0xFFB8D4B8),
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherScreen(selectedLanguage: selectedLanguage))),
                    ),
                    _buildOptionCard(
                      AppText.get('disease_check', selectedLanguage),
                      Icons.camera_alt, Color(0xFFB8D4B8),
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => DiseaseCheckScreen(selectedLanguage: selectedLanguage))),
                    ),
                    _buildOptionCard(
                      AppText.get('market_pricing', selectedLanguage),
                      Icons.trending_up, Color(0xFFB8D4B8),
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => MarketPricingScreen(selectedLanguage: selectedLanguage))),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFE6E6FA),
                      Color(0xFFE6E6FA).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen(selectedLanguage: selectedLanguage))),
                        child: Text(
                          AppText.get('ask_anything', selectedLanguage),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFB8D4B8), Color(0xFF81C784)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 22,
                        child: Icon(Icons.mic, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildOptionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Weather Screen
class WeatherScreen extends StatefulWidget {
  final String selectedLanguage;
  const WeatherScreen({Key? key, required this.selectedLanguage}) : super(key: key);
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherData? currentWeather;
  List<ForecastData> forecast = [];
  bool isLoading = true;
  String? errorMessage;
  bool useLocation = true;
  String loadingMessage = 'Loading weather data...';

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      loadingMessage = 'Getting your location...';
    });

    try {
      Position? position;
      
      // Quick location check with timeout
      if (useLocation) {
        position = await WeatherService.getCurrentLocation()
            .timeout(Duration(seconds: 3), onTimeout: () => null);
      }

      // Update loading message
      setState(() {
        loadingMessage = 'Fetching weather data...';
      });
      
      // Load weather and forecast in parallel for faster loading
      late Future<WeatherData?> weatherFuture;
      late Future<List<ForecastData>> forecastFuture;

      if (position != null) {
        weatherFuture = WeatherService.getCurrentWeather(
          lat: position.latitude, 
          lon: position.longitude,
        );
        forecastFuture = WeatherService.getWeatherForecast(
          lat: position.latitude, 
          lon: position.longitude,
        );
      } else {
        // Default to Delhi if location is not available
        weatherFuture = WeatherService.getCurrentWeather(cityName: 'Delhi,IN');
        forecastFuture = WeatherService.getWeatherForecast(cityName: 'Delhi,IN');
      }

      // Wait for both requests in parallel
      final results = await Future.wait([
        weatherFuture,
        forecastFuture,
      ], eagerError: false);

      setState(() {
        currentWeather = results[0] as WeatherData?;
        forecast = results[1] as List<ForecastData>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load weather data. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.get('weather', widget.selectedLanguage)),
        backgroundColor: Color(0xFFB8D4B8),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadWeatherData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFB8D4B8)),
            SizedBox(height: 16),
            Text(loadingMessage, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 8),
            Text('Please wait...', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            SizedBox(height: 16),
            Text(errorMessage!, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWeatherData,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB8D4B8)),
              child: Text('Retry', style: TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      );
    }

    if (currentWeather == null) {
      return Center(child: Text('No weather data available'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Current Weather Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE6F3FF), Color(0xFFB3E5FC)],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue[300]!, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${currentWeather!.temperature.round()}°C',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                        ),
                        Text(
                          currentWeather!.description.toUpperCase(),
                          style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Feels like ${currentWeather!.feelsLike.round()}°C',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Image.network(
                          WeatherService.getWeatherIconUrl(currentWeather!.icon),
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.wb_sunny, size: 80, color: Colors.orange),
                        ),
                        Text(
                          currentWeather!.cityName,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWeatherDetail('Humidity', '${currentWeather!.humidity.round()}%', Icons.opacity),
                    _buildWeatherDetail('Wind', '${currentWeather!.windSpeed.round()} m/s', Icons.air),
                    _buildWeatherDetail('Pressure', '${currentWeather!.pressure} hPa', Icons.speed),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          // Weather Advice Card
          if (currentWeather != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green[300]!, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.green[700]),
                      SizedBox(width: 8),
                      Text(
                        AppText.get('advisory', widget.selectedLanguage),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green[800]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    WeatherService.getWeatherAdvice(
                      currentWeather!.description,
                      currentWeather!.temperature,
                      widget.selectedLanguage,
                    ),
                    style: TextStyle(fontSize: 14, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          SizedBox(height: 20),
          
          // Forecast Card
          if (forecast.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppText.get('forecast', widget.selectedLanguage),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: forecast.take(5).map((forecastItem) {
                        final date = forecastItem.date;
                        final dayName = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
                        return Container(
                          margin: EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Text(
                                dayName,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              SizedBox(height: 8),
                              Image.network(
                                WeatherService.getWeatherIconUrl(forecastItem.icon),
                                width: 40,
                                height: 40,
                                errorBuilder: (context, error, stackTrace) => 
                                  Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${forecastItem.temperature.round()}°',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${forecastItem.humidity.round()}%',
                                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[600]),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Market Pricing Screen
class MarketPricingScreen extends StatefulWidget {
  final String selectedLanguage;
  const MarketPricingScreen({Key? key, required this.selectedLanguage}) : super(key: key);
  @override
  _MarketPricingScreenState createState() => _MarketPricingScreenState();
}

class _MarketPricingScreenState extends State<MarketPricingScreen> {
  List<Map<String, dynamic>> cropPrices = [];
  String selectedCrop = 'Wheat';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMockPrices();
  }

  void _loadMockPrices() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        cropPrices = [
          {'name': 'Wheat', 'price': 2150 + Random().nextInt(200), 'unit': 'per quintal', 'trend': 'up'},
          {'name': 'Rice', 'price': 2600 + Random().nextInt(200), 'unit': 'per quintal', 'trend': 'down'},
          {'name': 'Corn', 'price': 1900 + Random().nextInt(200), 'unit': 'per quintal', 'trend': 'up'},
          {'name': 'Tomato', 'price': 35 + Random().nextInt(10), 'unit': 'per kg', 'trend': 'up'},
          {'name': 'Onion', 'price': 28 + Random().nextInt(10), 'unit': 'per kg', 'trend': 'down'},
          {'name': 'Potato', 'price': 22 + Random().nextInt(8), 'unit': 'per kg', 'trend': 'up'},
        ];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppText.get('market_pricing', widget.selectedLanguage)), backgroundColor: Color(0xFFB8D4B8)),
      body: isLoading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity, padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Color(0xFFE6F3FF), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue[300]!, width: 2)),
              child: Column(
                children: [
                  Text(selectedCrop, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('₹${cropPrices.firstWhere((crop) => crop['name'] == selectedCrop, orElse: () => cropPrices[0])['price']}',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue[800])),
                  Text(cropPrices.firstWhere((crop) => crop['name'] == selectedCrop, orElse: () => cropPrices[0])['unit'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity, padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose Your Crop:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: cropPrices.take(6).map((crop) {
                      final isSelected = crop['name'] == selectedCrop;
                      return GestureDetector(
                        onTap: () => setState(() => selectedCrop = crop['name']),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFB8D4B8) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? Colors.green[400]! : Colors.grey[300]!),
                          ),
                          child: Text(crop['name'], style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity, padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('All Crop Prices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  ...cropPrices.map((crop) => Container(
                    margin: EdgeInsets.only(bottom: 8), padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Expanded(child: Text(crop['name'], style: TextStyle(fontWeight: FontWeight.w600))),
                        Text('₹${crop['price']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(crop['trend'] == 'up' ? Icons.trending_up : Icons.trending_down, size: 16, color: crop['trend'] == 'up' ? Colors.green : Colors.red),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Disease Check Screen
class DiseaseCheckScreen extends StatefulWidget {
  final String selectedLanguage;
  const DiseaseCheckScreen({Key? key, required this.selectedLanguage}) : super(key: key);
  @override
  _DiseaseCheckScreenState createState() => _DiseaseCheckScreenState();
}

class _DiseaseCheckScreenState extends State<DiseaseCheckScreen> {
  bool hasImage = false;
  bool isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppText.get('disease_check', widget.selectedLanguage)), backgroundColor: Color(0xFFB8D4B8)),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity, margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: hasImage ? Colors.white : Colors.grey[300], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue[300]!, width: 2)),
                child: hasImage ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        color: Colors.green[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.eco, size: 100, color: Colors.green[400]),
                            Text('Plant Image Selected', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10, right: 10,
                      child: GestureDetector(
                        onTap: () => setState(() => hasImage = false),
                        child: CircleAvatar(backgroundColor: Colors.red, radius: 20, child: Icon(Icons.close, color: Colors.white)),
                      ),
                    ),
                  ],
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 80, color: Colors.grey[600]),
                    SizedBox(height: 20),
                    Text('Take a photo of the affected plant', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => setState(() => hasImage = true),
                          icon: Icon(Icons.camera), label: Text('Camera'),
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB8D4B8), foregroundColor: Colors.black87),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => setState(() => hasImage = true),
                          icon: Icon(Icons.photo_library), label: Text('Gallery'),
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB8D4B8), foregroundColor: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity, margin: EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: (hasImage && !isAnalyzing) ? () async {
                  setState(() => isAnalyzing = true);
                  await Future.delayed(Duration(seconds: 3));
                  setState(() => isAnalyzing = false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DiseaseResultScreen(selectedLanguage: widget.selectedLanguage)));
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB8D4B8), padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), disabledBackgroundColor: Colors.grey[400],
                ),
                child: isAnalyzing ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87)),
                    SizedBox(width: 10),
                    Text('Analyzing...', style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500)),
                  ],
                ) : Text(AppText.get('upload', widget.selectedLanguage), style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Disease Result Screen
class DiseaseResultScreen extends StatelessWidget {
  final String selectedLanguage;
  const DiseaseResultScreen({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease Analysis Result'), backgroundColor: Color(0xFFB8D4B8)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildResultCard('Disease Identified', 'Leaf Blight', 'A common fungal disease affecting plant leaves.', Colors.red[100]!, Colors.red[800]!, Icons.bug_report),
            SizedBox(height: 15),
            _buildResultCard('Severity Level', 'Moderate', 'Immediate treatment is recommended.', Colors.orange[100]!, Colors.orange[800]!, Icons.warning),
            SizedBox(height: 15),
            Container(
              width: double.infinity, padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green[300]!, width: 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Treatment Recommendations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[800])),
                  SizedBox(height: 12),
                  _buildTreatmentStep('1', 'Remove affected leaves immediately'),
                  _buildTreatmentStep('2', 'Apply copper-based fungicide spray'),
                  _buildTreatmentStep('3', 'Improve air circulation around plants'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen(selectedLanguage: selectedLanguage))),
                    icon: Icon(Icons.chat), label: Text('Ask Expert'),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB8D4B8), foregroundColor: Colors.black87),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FertilizerScreen(selectedLanguage: selectedLanguage))),
                    icon: Icon(Icons.eco), label: Text('Get Products'),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE6E6FA), foregroundColor: Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String subtitle, String description, Color backgroundColor, Color iconColor, IconData icon) {
    return Container(
      width: double.infinity, padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: iconColor.withOpacity(0.3), width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: iconColor), SizedBox(width: 8), Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: iconColor))]),
          SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildTreatmentStep(String number, String instruction) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(color: Colors.green[800], shape: BoxShape.circle),
            child: Center(child: Text(number, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          SizedBox(width: 12),
          Expanded(child: Text(instruction, style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
        ],
      ),
    );
  }
}

// Fertilizer Screen
class FertilizerScreen extends StatelessWidget {
  final String selectedLanguage;
  const FertilizerScreen({Key? key, required this.selectedLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppText.get('fertilizer_pesticide', selectedLanguage)), backgroundColor: Color(0xFFB8D4B8)),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildCategoryCard('Organic Fertilizers', Icons.eco, Color(0xFFB8D4B8), 'Natural and eco-friendly options', context),
          SizedBox(height: 15),
          _buildCategoryCard('Chemical Fertilizers', Icons.science, Color(0xFFFFB8B8), 'Fast-acting nutrient solutions', context),
          SizedBox(height: 15),
          _buildCategoryCard('Pesticides', Icons.bug_report, Color(0xFFB8E6FF), 'Effective pest control solutions', context),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color, String description, BuildContext context) {
    return GestureDetector(
      onTap: () => _showProductInfo(context, title),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.black87),
            SizedBox(width: 20),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(description, style: TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            )),
            Icon(Icons.arrow_forward_ios, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  void _showProductInfo(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category),
        content: Text('Product recommendations and usage guidelines for $category will be displayed here.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }
}

// Chatbot Screen
class ChatbotScreen extends StatefulWidget {
  final String selectedLanguage;
  const ChatbotScreen({Key? key, required this.selectedLanguage}) : super(key: key);
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeText = {
      'en': 'Hello! I\'m your AI-powered agricultural assistant. I can help you with farming questions, crop advice, disease diagnosis, fertilizer recommendations, and more. How can I assist you today?',
      'hi': 'नमस्ते! मैं आपका AI-संचालित कृषि सहायक हूं। मैं आपकी खेती के सवालों, फसल की सलाह, रोग निदान, उर्वरक की सिफारिशों और बहुत कुछ में मदद कर सकता हूं। आज मैं आपकी कैसे सहायता कर सकता हूं?',
      'pa': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ ਤੁਹਾਡਾ AI-ਸੰਚਾਲਿਤ ਖੇਤੀਬਾੜੀ ਸਹਾਇਕ ਹਾਂ। ਮੈਂ ਤੁਹਾਡੇ ਖੇਤੀ ਦੇ ਸਵਾਲਾਂ, ਫਸਲ ਦੀ ਸਲਾਹ, ਬਿਮਾਰੀ ਦੀ ਜਾਂਚ, ਖਾਦ ਦੀਆਂ ਸਿਫਾਰਸ਼ਾਂ ਅਤੇ ਹੋਰ ਬਹੁਤ ਕੁਝ ਵਿੱਚ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ। ਅੱਜ ਮੈਂ ਤੁਹਾਡੀ ਕਿਵੇਂ ਸਹਾਇਤਾ ਕਰ ਸਕਦਾ ਹਾਂ?',
    };
    
    _messages.add(ChatMessage(
      content: welcomeText[widget.selectedLanguage] ?? welcomeText['en']!,
      isUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CropSense AI Assistant'),
        backgroundColor: Color(0xFFB8D4B8),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(20),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.smart_toy, size: 18, color: Colors.grey[600]),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'AI Assistant is thinking...',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final message = _messages[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!message.isUser) ...[
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0xFFB8D4B8),
                          child: Icon(Icons.smart_toy, size: 18, color: Colors.black87),
                        ),
                        SizedBox(width: 8),
                      ],
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: message.isUser ? Color(0xFFB8D4B8) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: SelectableText(
                          message.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: message.isUser ? Colors.black87 : Colors.black,
                          ),
                        ),
                      ),
                      if (message.isUser) ...[
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blue[300],
                          child: Icon(Icons.person, size: 18, color: Colors.white),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: AppText.get('ask_anything', widget.selectedLanguage),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: _isTyping ? null : _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: _isTyping ? Colors.grey[400] : Color(0xFFB8D4B8),
                    radius: 22,
                    child: _isTyping
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(Icons.send, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isTyping) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(content: userMessage, isUser: true));
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      final response = await ChatGPTService.sendMessage(
        userMessage,
        language: widget.selectedLanguage,
      );

      setState(() {
        _messages.add(ChatMessage(content: response, isUser: false));
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        final errorMessage = {
          'en': 'I\'m having trouble connecting right now. Please try again later.',
          'hi': 'मुझे अभी कनेक्ट करने में परेशानी हो रही है। कृपया बाद में पुनः प्रयास करें।',
          'pa': 'ਮੈਨੂੰ ਹੁਣੇ ਕਨੈਕਟ ਕਰਨ ਵਿੱਚ ਮੁਸ਼ਕਲ ਹੋ ਰਹੀ ਹੈ। ਕਿਰਪਾ ਕਰਕੇ ਬਾਅਦ ਵਿੱਚ ਕੋਸ਼ਿਸ਼ ਕਰੋ।',
        };
        _messages.add(ChatMessage(
          content: errorMessage[widget.selectedLanguage] ?? errorMessage['en']!,
          isUser: false,
        ));
        _isTyping = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _addWelcomeMessage();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
