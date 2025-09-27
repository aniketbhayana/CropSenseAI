class ApiConfig {
  // OpenAI ChatGPT API Configuration
  static const String openAiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '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',
  );
  
  // OpenWeatherMap API Configuration
  static const String openWeatherApiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: 'aaebb3e63521ded637a1cdb6e046248b',
  );
  
  // API Endpoints
  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // API Headers
  static Map<String, String> get openAiHeaders => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $openAiApiKey',
  };
}