import 'package:flutter/material.dart';

import '../../color.dart';

class MedicineDetailPage extends StatelessWidget {
  final Map<String, dynamic> medicine;

  const MedicineDetailPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorList.primary,
        title: const Text('약품 상세'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이름: ${medicine['itemName']}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                '효능: ${medicine['efcyQesitm']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                '사용법: ${medicine['useMethodQesitm']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                '숙지사항: ${medicine['atpnWarnQesitm']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                '주의사항: ${medicine['atpnQesitm']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                '주의할 음식 및 약품 : ${medicine['intrcQesitm']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                '이상반응 : ${medicine['seQesitm']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                '보관법 : ${medicine['depositMethodQesitm']}',
                style: const TextStyle(fontSize: 16),
              ),
              // 추가적인 정보를 여기에 표시합니다.
            ],
          ),
        ),
      ),
    );
  }
}
