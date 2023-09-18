import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Answer extends StatefulWidget {
  final String prompt;
  const Answer(this.prompt, {super.key});

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  final apiKey = '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';
  final apiUrl = "https://api.openai.com/v1/chat/completions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI의 추천',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff70BAAD),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xff70BAAD),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32), // 간격 조정
            const Text(
              '본 내용은 AI의 의견이며 자세한 내용은 병원에 방문하여 진료를 받으시기 바랍니다.', // 내용 텍스트
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32), // 간격 조정
            Expanded(
              child: FutureBuilder<List<String>>(
                future: generateText(widget.prompt),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                snapshot.data![index],
                                style: const TextStyle(
                                  color: Color(0xff70BAAD),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 이전 화면으로 돌아가기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // 배경 색상
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '이전 화면으로',
                style: TextStyle(
                  color: Color(0xff70BAAD),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> generateText(String prompt) async {
    var messages = [
      {"role": "system", "content": "You are a helpful assistant"},
      {"role": "user", "content": "해당 증상에 대한 약 추천해줘 "},
      {"role": "assistant", "content": prompt}
    ];
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        'messages': messages,
        'temperature': 0,
      }),
    );

    Map<String, dynamic> newresponse =
        jsonDecode(utf8.decode(response.bodyBytes));
    List<String> result = [newresponse['choices'][0]['message']['content']];
    return result;
  }
}
