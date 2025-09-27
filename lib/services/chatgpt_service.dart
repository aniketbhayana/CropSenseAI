import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatGPTService {
  static const String _model = 'gpt-3.5-turbo';
  
  static Future<String> sendMessage(String message, {String? language = 'en'}) async {
    try {
      // First try the OpenAI API
      final systemPrompt = _getSystemPrompt(language ?? 'en');
      
      final response = await http.post(
        Uri.parse('${ApiConfig.openAiBaseUrl}/chat/completions'),
        headers: ApiConfig.openAiHeaders,
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': systemPrompt,
            },
            {
              'role': 'user',
              'content': message,
            }
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      print('OpenAI API Response Status: ${response.statusCode}');
      print('OpenAI API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else if (response.statusCode == 429) {
        // Rate limit exceeded - use fallback responses
        print('Rate limit exceeded, using fallback response');
        return _getFallbackResponse(message, language ?? 'en');
      } else if (response.statusCode == 401) {
        // Unauthorized - API key issue
        print('API key issue, using fallback response');
        return _getFallbackResponse(message, language ?? 'en');
      } else {
        print('API error ${response.statusCode}, using fallback response');
        return _getFallbackResponse(message, language ?? 'en');
      }
    } catch (e) {
      print('ChatGPT Error: $e');
      // Use intelligent fallback instead of error message
      return _getFallbackResponse(message, language ?? 'en');
    }
  }

  static String _getSystemPrompt(String language) {
    switch (language) {
      case 'hi':
        return '''आप CropSense AI के लिए एक सहायक AI असिस्टेंट हैं - किसानों के लिए एक स्मार्ट ऐप। आप भारतीय कृषि, फसल उत्पादन, मौसम, रोग प्रबंधन, उर्वरक उपयोग, और बाजार की कीमतों के बारे में जानकारी प्रदान करते हैं। हमेशा उपयोगी, सटीक और व्यावहारिक सलाह दें। हिंदी में उत्तर दें।''';
      case 'pa':
        return '''ਤੁਸੀਂ CropSense AI ਲਈ ਇੱਕ ਸਹਾਇਕ AI ਅਸਿਸਟੈਂਟ ਹੋ - ਕਿਸਾਨਾਂ ਲਈ ਇੱਕ ਸਮਾਰਟ ਐਪ। ਤੁਸੀਂ ਭਾਰਤੀ ਖੇਤੀਬਾੜੀ, ਫਸਲ ਉਤਪਾਦਨ, ਮੌਸਮ, ਬਿਮਾਰੀ ਪ੍ਰਬੰਧਨ, ਖਾਦ ਦੀ ਵਰਤੋਂ, ਅਤੇ ਮਾਰਕੀਟ ਦੀਆਂ ਕੀਮਤਾਂ ਬਾਰੇ ਜਾਣਕਾਰੀ ਪ੍ਰਦਾਨ ਕਰਦੇ ਹੋ। ਹਮੇਸ਼ਾ ਉਪਯੋਗੀ, ਸਹੀ ਅਤੇ ਵਿਹਾਰਕ ਸਲਾਹ ਦਿਓ। ਪੰਜਾਬੀ ਵਿੱਚ ਜਵਾਬ ਦਿਓ।''';
      default:
        return '''You are a helpful AI assistant for CropSense AI - a smart farming app for farmers. You provide information about Indian agriculture, crop production, weather, disease management, fertilizer usage, and market prices. Always give helpful, accurate, and practical advice. Answer in English.''';
    }
  }

  static String _getFallbackResponse(String message, String language) {
    final lowerMessage = message.toLowerCase();
    
    // Crop-related questions
    if (lowerMessage.contains('crop') || lowerMessage.contains('wheat') || lowerMessage.contains('rice') || 
        lowerMessage.contains('फसल') || lowerMessage.contains('गेहूं') || lowerMessage.contains('चावल') ||
        lowerMessage.contains('ਫਸਲ') || lowerMessage.contains('ਕਣਕ') || lowerMessage.contains('ਚਾਵਲ')) {
      return _getCropAdvice(language);
    }
    
    // Disease-related questions
    if (lowerMessage.contains('disease') || lowerMessage.contains('pest') || lowerMessage.contains('bug') ||
        lowerMessage.contains('रोग') || lowerMessage.contains('कीट') || lowerMessage.contains('बीमारी') ||
        lowerMessage.contains('ਰੋਗ') || lowerMessage.contains('ਕੀਟ') || lowerMessage.contains('ਬਿਮਾਰੀ')) {
      return _getDiseaseAdvice(language);
    }
    
    // Fertilizer-related questions
    if (lowerMessage.contains('fertilizer') || lowerMessage.contains('manure') || lowerMessage.contains('compost') ||
        lowerMessage.contains('उर्वरक') || lowerMessage.contains('खाद') || lowerMessage.contains('कंपोस्ट') ||
        lowerMessage.contains('ਖਾਦ') || lowerMessage.contains('ਉਰਵਰਕ') || lowerMessage.contains('ਕੰਪੋਸਟ')) {
      return _getFertilizerAdvice(language);
    }
    
    // Weather-related questions
    if (lowerMessage.contains('weather') || lowerMessage.contains('rain') || lowerMessage.contains('temperature') ||
        lowerMessage.contains('मौसम') || lowerMessage.contains('बारिश') || lowerMessage.contains('तापमान') ||
        lowerMessage.contains('ਮੌਸਮ') || lowerMessage.contains('ਮੀਂਹ') || lowerMessage.contains('ਤਾਪਮਾਨ')) {
      return _getWeatherAdvice(language);
    }
    
    // General farming questions
    if (lowerMessage.contains('farm') || lowerMessage.contains('agriculture') || lowerMessage.contains('soil') ||
        lowerMessage.contains('खेती') || lowerMessage.contains('कृषि') || lowerMessage.contains('मिट्टी') ||
        lowerMessage.contains('ਖੇਤੀ') || lowerMessage.contains('ਕਿਸਾਨੀ') || lowerMessage.contains('ਮਿੱਟੀ')) {
      return _getGeneralFarmAdvice(language);
    }
    
    // Default response
    return _getDefaultResponse(language);
  }
  
  static String _getCropAdvice(String language) {
    switch (language) {
      case 'hi':
        return 'फसल चुनते समय स्थानीय मिट्टी, जलवायु और बाजार की मांग को ध्यान में रखें। गेहूं और चावल मुख्य फसलें हैं। उचित बीज चुनें और समय पर बुवाई करें।';
      case 'pa':
        return 'ਫਸਲ ਚੁਣਦੇ ਸਮੇਂ ਸਥਾਨਕ ਮਿੱਟੀ, ਮੌਸਮ ਅਤੇ ਮਾਰਕੀਟ ਦੀ ਮੰਗ ਨੂੰ ਧਿਆਨ ਵਿੱਚ ਰੱਖੋ। ਕਣਕ ਅਤੇ ਚਾਵਲ ਮੁੱਖ ਫਸਲਾਂ ਹਨ। ਸਹੀ ਬੀਜ ਚੁਣੋ ਅਤੇ ਸਮੇਂ ਸਿਰ ਬੀਜਣਾ ਕਰੋ।';
      default:
        return 'Choose crops based on local soil, climate, and market demand. Wheat and rice are major crops in India. Select good quality seeds and plant at the right time for your region.';
    }
  }
  
  static String _getDiseaseAdvice(String language) {
    switch (language) {
      case 'hi':
        return 'पौधों के रोगों से बचने के लिए स्वच्छ खेती करें। प्रभावित पत्तियों को हटाएं, नीम का तेल या कॉपर सल्फेट का छिड़काव करें। हमारे रोग जांच फीचर का उपयोग करें।';
      case 'pa':
        return 'ਪੌਦਿਆਂ ਦੀਆਂ ਬਿਮਾਰੀਆਂ ਤੋਂ ਬਚਣ ਲਈ ਸਾਫ਼ ਖੇਤੀ ਕਰੋ। ਪ੍ਰਭਾਵਿਤ ਪੱਤਿਆਂ ਨੂੰ ਹਟਾਓ, ਨਿੰਮ ਦਾ ਤੇਲ ਜਾਂ ਕਾਪਰ ਸਲਫੇਟ ਦਾ ਛਿੜਕਾਅ ਕਰੋ।';
      default:
        return 'Prevent plant diseases with clean farming practices. Remove affected leaves, spray neem oil or copper sulfate. Use our disease check feature for specific diagnosis.';
    }
  }
  
  static String _getFertilizerAdvice(String language) {
    switch (language) {
      case 'hi':
        return 'उर्वरक का उपयोग करने से पहले मिट्टी की जांच कराएं। जैविक खाद जैसे कंपोस्ट का अधिक उपयोग करें। NPK की संतुलित मात्रा दें। अधिक उर्वरक हानिकारक है।';
      case 'pa':
        return 'ਖਾਦ ਵਰਤਣ ਤੋਂ ਪਹਿਲਾਂ ਮਿੱਟੀ ਦੀ ਜਾਂਚ ਕਰਾਓ। ਜੈਵਿਕ ਖਾਦ ਜਿਵੇਂ ਕੰਪੋਸਟ ਦੀ ਜ਼ਿਆਦਾ ਵਰਤੋਂ ਕਰੋ। NPK ਦੀ ਸੰਤੁਲਿਤ ਮਾਤਰਾ ਦਿਓ।';
      default:
        return 'Test soil before using fertilizers. Use more organic fertilizers like compost. Apply balanced NPK nutrients. Avoid over-fertilization as it can harm crops.';
    }
  }
  
  static String _getWeatherAdvice(String language) {
    switch (language) {
      case 'hi':
        return 'मौसम का पूर्वानुमान देखकर खेती की योजना बनाएं। बारिश से पहले फसल को सुरक्षित करें। अधिक गर्मी में सिंचाई बढ़ाएं। हमारे मौसम अनुभाग का उपयोग करें।';
      case 'pa':
        return 'ਮੌਸਮ ਦੀ ਭਵਿੱਖਬਾਣੀ ਦੇਖ ਕੇ ਖੇਤੀ ਦੀ ਯੋਜਨਾ ਬਣਾਓ। ਮੀਂਹ ਤੋਂ ਪਹਿਲਾਂ ਫਸਲ ਨੂੰ ਸੁਰੱਖਿਤ ਕਰੋ। ਜ਼ਿਆਦਾ ਗਰਮੀ ਵਿੱਚ ਸਿੰਚਾਈ ਵਧਾਓ।';
      default:
        return 'Plan farming activities based on weather forecasts. Protect crops before rain. Increase irrigation during high temperatures. Use our weather section for updates.';
    }
  }
  
  static String _getGeneralFarmAdvice(String language) {
    switch (language) {
      case 'hi':
        return 'सफल खेती के लिए मिट्टी की जांच, उचित बीज, समय पर सिंचाई और रोग नियंत्रण जरूरी है। आधुनिक तकनीकों का उपयोग करें और बाजार की जानकारी रखें।';
      case 'pa':
        return 'ਸਫਲ ਖੇਤੀ ਲਈ ਮਿੱਟੀ ਦੀ ਜਾਂਚ, ਸਹੀ ਬੀਜ, ਸਮੇਂ ਸਿਰ ਸਿੰਚਾਈ ਅਤੇ ਰੋਗ ਕੰਟਰੋਲ ਜ਼ਰੂਰੀ ਹੈ। ਆਧੁਨਿਕ ਤਕਨੀਕਾਂ ਦੀ ਵਰਤੋਂ ਕਰੋ।';
      default:
        return 'Successful farming requires soil testing, quality seeds, timely irrigation, and disease control. Use modern techniques and stay updated with market information.';
    }
  }
  
  static String _getDefaultResponse(String language) {
    switch (language) {
      case 'hi':
        return 'मैं आपका कृषि सहायक हूं। आप मुझसे फसल, मौसम, रोग, उर्वरक या खेती से जुड़े किसी भी सवाल पूछ सकते हैं। कृपया अपना प्रश्न स्पष्ट रूप से पूछें।';
      case 'pa':
        return 'ਮੈਂ ਤੁਹਾਡਾ ਖੇਤੀਬਾੜੀ ਸਹਾਇਕ ਹਾਂ। ਤੁਸੀਂ ਮੈਨੂੰ ਫਸਲ, ਮੌਸਮ, ਰੋਗ, ਖਾਦ ਜਾਂ ਖੇਤੀ ਨਾਲ ਜੁੜੇ ਕੋਈ ਵੀ ਸਵਾਲ ਪੁੱਛ ਸਕਦੇ ਹੋ।';
      default:
        return 'I\'m your agricultural assistant. You can ask me about crops, weather, diseases, fertilizers, or any farming-related questions. Please ask your question clearly.';
    }
  }
  
  static String _getErrorMessage(String language) {
    switch (language) {
      case 'hi':
        return 'खुशी है, मैं अभी उपलब्ध नहीं हूं। कृपया बाद में कोशिश करें।';
      case 'pa':
        return 'ਮਾਫ਼ ਕਰਨਾ, ਮੈਂ ਹੁਣੇ ਉਪਲਬਧ ਨਹੀਂ ਹਾਂ। ਕਿਰਪਾ ਕਰਕੇ ਬਾਅਦ ਵਿੱਚ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
      default:
        return 'Sorry, I\'m currently unavailable. Please try again later.';
    }
  }
}
