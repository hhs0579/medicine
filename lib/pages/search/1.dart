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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorList.primary,
        title: const Text('약 검색'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: '약품명을 입력하세요',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            futureMedicines =
                                fetchMedicines(_searchController.text);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureMedicines ?? Future.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorList.primary,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('결과가 없습니다.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var medicine = snapshot.data![index];
                      return ListTile(
                        title: Text(medicine['itemName']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MedicineDetailPage(medicine: medicine),
                            ),
                          );
                        },
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
