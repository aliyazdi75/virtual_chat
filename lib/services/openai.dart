import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;

  OpenAIService(this.apiKey);

  Future<String> getResponse(String prompt) async {
    const String url = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'model': 'gpt-3.5-turbo',
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var text = data['choices'][0]['text'].trim();
        return text;
      } else {
        return "Sorry, I couldn't understand that.";
      }
    } catch (e) {
      return "An error occurred. Please try again.";
    }
  }
}
