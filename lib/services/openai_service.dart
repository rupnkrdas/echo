import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:echo/constants/secrets.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> determineResponseType(String prompt) async {
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
      log(response.body);
      if (response.statusCode == 200) {
        String responseType = jsonDecode(response.body)['choices'][0]['message']['content'];
        responseType = responseType.trim().toLowerCase();

        switch (responseType) {
          case 'true':
            final response = await generateImage(prompt);
            return response;
          default:
            final response = await generateText(prompt);
            return response;
        }
      }

      return "An internal error occurred.";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> generateText(String prompt) async {
    debugPrint("called generateText API");
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

  Future<String> generateImage(String prompt) async {
    debugPrint("called generateImage API");
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
