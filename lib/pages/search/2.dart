import 'package:flutter/material.dart';
import '../../color.dart';

class MedicineDetailPage extends StatelessWidget {
  final Map<String, dynamic> medicine;

  const MedicineDetailPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff70BAAD), // 전체 배경 색상 설정
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff70BAAD), // 앱바 색상 설정
        title: Text(
          '약품 상세',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 약품 이미지
            medicine['itemImage'] != null
                ? Image.network('${medicine['itemImage']}')
                : Container(),
            SizedBox(height: 16),

            // 약품 이름
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18), // 좌우 여백 추가

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 70, 68, 68).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '약품명: ${medicine['itemName']}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 효능
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18), // 좌우 여백 추가
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '효능',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                    Text(
                      '${medicine['efcyQesitm']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 사용법
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18), // 좌우 여백 추가
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '사용법',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                    Text(
                      '${medicine['useMethodQesitm']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 숙지사항
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18), // 좌우 여백 추가
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '숙지사항',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                    Text(
                      '${medicine['atpnWarnQesitm']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 주의사항
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18), // 좌우 여백 추가
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '주의사항',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                    Text(
                      '${medicine['atpnQesitm']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 주의할 음식 및 약품
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18), // 좌우 여백 추가
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '주의할 음식 및 약품',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                    Text(
                      '${medicine['intrcQesitm']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 이상반응
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18), // 좌우 여백 추가
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이상반응',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                    Text(
                      '${medicine['seQesitm']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 보관법
            Container(
              margin: EdgeInsets.fromLTRB(18, 0, 18, 18), // 좌우 여백 추가
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '보관법',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                    Text(
                      '${medicine['depositMethodQesitm']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // 텍스트 컬러 변경
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 추가적인 정보를 여기에 표시합니다.
          ],
        ),
      ),
    );
  }
}
