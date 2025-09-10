// import 'dart:async';
// import 'package:coffee_shop/Authentication/phone_auth.dart';
// import 'package:coffee_shop/core/widget/widgets.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 2), _checkUserSession);
//   }

//   void _checkUserSession() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MainAppere()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const PhoneAuth()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, 
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(image:AssetImage('Assets/Images/splashimage.jpg'),
//           fit: BoxFit.fill,),),
//         ),
//     );
//   }
// }import 'dart:async';
import 'dart:async';
import 'dart:developer';

import 'package:coffee_shop/Authentication/phone_auth.dart';
import 'package:coffee_shop/core/core.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => MainAppere()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/Images/splashimage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        // child: const Center(
        //   child: CircularProgressIndicator( // Add a loading indicator
        //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //   ),
        // ),
      ),
    );
  }
}