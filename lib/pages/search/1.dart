import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicine/color.dart';
import 'package:medicine/pages/search/2.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

Future<List<dynamic>> fetchMedicines(String query) async {
  String encodedQuery = Uri.encodeComponent(query);
  final response = await http.get(Uri.parse(
      'https://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList?serviceKey=9OW0roEzcIjy7tnqHYZIXT%2BFY9dc2XzW22HsBUrY4J3lexEfuY8NKr8TcaCieAMWmwf2q%2BNdnFEy%2BzcEvkJTCg%3D%3D&itemName=$encodedQuery&type=json'));

  if (response.statusCode == 200) {
    Map<String, dynamic>? jsonResponse = json.decode(response.body);
    if (jsonResponse != null &&
        jsonResponse['body'] != null &&
        jsonResponse['body']['items'] != null) {
      return jsonResponse['body']['items'];
    } else {
      return []; // 여기에서 빈 리스트를 반환하거나, 다른 예외 처리를 할 수 있습니다.
    }
  } else {
    throw Exception('Failed to load medicines');
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<dynamic>>? futureMedicines;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff70BAAD),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff70BAAD),
        title: Text(
          '약 검색',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '약품명을 입력하세요',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          futureMedicines =
                              fetchMedicines(_searchController.text);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xff70BAAD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureMedicines ?? Future.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff70BAAD),
                    ), // 로딩 인디케이터 스타일 변경
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: Colors.white, // 에러 텍스트 색상 변경
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // 결과 없음 텍스트 색상 변경
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var medicine = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            medicine['itemName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // 아이템 텍스트 스타일 변경
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MedicineDetailPage(medicine: medicine),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
