import 'package:flutter/material.dart';

import '../../model/medicine.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse['body']['items'];
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
      appBar: AppBar(
        title: const Text('Medicine Search'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(labelText: 'Search Medicine'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                futureMedicines = fetchMedicines(_searchController.text);
              });
            },
            child: const Text('Search'),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureMedicines ?? Future.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No medicines found');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var medicine = snapshot.data![index];
                      return ListTile(
                        title: Text(medicine['itemName']),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(medicine['itemName']),
                                content: const Text('More details here...'),
                              );
                            },
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
