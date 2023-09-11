import 'package:flutter/material.dart';
import '../../color.dart';

class MedicineDetailPage extends StatelessWidget {
  final Map<String, dynamic> medicine;

  const MedicineDetailPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff70BAAD), // 전체 배경 색상 설정
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0xff70BAAD), // 앱바 색상 설정
          title: const Text(
            '약품 상세',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 약품 이미지
          medicine['itemImage'] != null
              ? Image.network('${medicine['itemImage']}')
              : Container(),
          const SizedBox(height: 16),

          // 약품 이름
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18), // 좌우 여백 추가

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 70, 68, 68).withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '약품명: ${medicine['itemName']}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 텍스트 컬러 변경
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 효능
          Visibility(
            visible: medicine['efcyQesitm'] != null &&
                medicine['efcyQesitm'].isNotEmpty,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '효능',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${medicine['efcyQesitm']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

// 사용법
          Visibility(
            visible: medicine['useMethodQesitm'] != null &&
                medicine['useMethodQesitm'].isNotEmpty,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '사용법',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${medicine['useMethodQesitm']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

// 주의사항
          Visibility(
            visible: medicine['atpnWarnQesitm'] != null &&
                medicine['atpnWarnQesitm'].isNotEmpty,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '숙지사항',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${medicine['atpnWarnQesitm']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

// 주의할 음식 및 약품
          Visibility(
            visible: medicine['intrcQesitm'] != null &&
                medicine['intrcQesitm'].isNotEmpty,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '주의할 음식 및 약품',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${medicine['intrcQesitm']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

// 이상반응
          Visibility(
            visible:
                medicine['seQesitm'] != null && medicine['seQesitm'].isNotEmpty,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '이상반응',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${medicine['seQesitm']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

// 보관법
          Visibility(
            visible: medicine['depositMethodQesitm'] != null &&
                medicine['depositMethodQesitm'].isNotEmpty,
            child: Container(
              margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '보관법',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${medicine['depositMethodQesitm']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        ),
        ),
    );
  }
}
