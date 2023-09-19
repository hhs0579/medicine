import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicine/auth/ok.dart';

import '../bottom.dart';
import '../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

User? user = auth.currentUser;
Future<UserCredential> signInWithGoogle(BuildContext context) async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  if (userCredential.user != null) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const MyBottomNavigationBar()));
    await firestore.collection('users').doc(userCredential.user!.uid).set(
        {'uid': userCredential.user!.uid, 'email': userCredential.user!.email});
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('구글 로그인 실패')),
    );
  }

  return userCredential;
}

// ... (중략)

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100, bottom: 30),
              width: MediaQuery.of(context).size.width * 0.4,
              child: Image.asset('assets/images/main.png'),
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    signInWithGoogle(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Image.asset(
                          'assets/images/google.png',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Ok()),
                    );
                  },
                  child: const Text(
                    '개인정보처리방침',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
