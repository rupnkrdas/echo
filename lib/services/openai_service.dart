import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:echo/constants/secrets.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "user", "content": "Please determine whether this message intends to generate an AI picture, image, art, or anything similar:\n\nPrompt: $prompt\n\nResponse: Please provide 'true' if the message intends to generate an AI picture, or 'false' if it does not."},
            ]
          },
        ),
      );
      print(response.body);
      if (response.statusCode == 200) {
        String content = jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim().toLowerCase();

        switch (content) {
          case 'true':
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      }

      return "An internal error occurred.";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    debugPrint("called chat GPT API");
    messages.add({
      "role": "user",
      "content": prompt,
    });
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": messages,
          },
        ),
      );

      if (response.statusCode == 200) {
        String content = jsonDecode(response.body)['choices'][0]['message']['content'];

        messages.add({
          "role": "assistant",
          "content": content,
        });

        return content;
      }

      return "An internal error occurred.";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    debugPrint("called DALL-E API");
    messages.add({
      "role": "user",
      "content": prompt,
    });
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAIAPIKey",
        },
        body: jsonEncode(
          {
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024",
          },
        ),
      );

      if (response.statusCode == 200) {
        String imageURL = jsonDecode(response.body)['data'][0]['url'];

        messages.add({
          "role": "assistant",
          "content": imageURL,
        });

        log(imageURL);
        return imageURL;
      }

      return "An internal error occurred.";
    } catch (e) {
      return e.toString();
    }
  }
}
