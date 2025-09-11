
// import 'dart:developer';
// import 'package:coffee_shop/Authentication/otp_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../Features/Home/Home.dart';

// class PhoneAuth extends StatefulWidget {
//   const PhoneAuth({super.key});

//   @override
//   State<PhoneAuth> createState() => _PhoneAuthState();
// }

// class _PhoneAuthState extends State<PhoneAuth> {
//   TextEditingController countryController = TextEditingController();
//   TextEditingController phoneNoController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     countryController.text = "+91";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     context.go('/navbar');
//                   },
//                   child: Container(
//                     width: 100,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       color: Colors.amberAccent,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Center(child: Text("Skip")),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Text(
//               "Phone Verification",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "We need to register your phone number before getting started",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//             ),
//             const SizedBox(height: 20),
//             Form(
//               key: _formKey,
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey, width: 2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     const SizedBox(width: 10),
//                     // Country code textfield
//                     SizedBox(
//                       width: 40,
//                       child: TextFormField(
//                         keyboardType: TextInputType.phone,
//                         controller: countryController,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Required';
//                           }
//                           if (!value.startsWith('+')) {
//                             return 'Must start with +';
//                           }
//                           return null;
//                         },
//                         decoration: const InputDecoration(border: InputBorder.none),
//                       ),
//                     ),
//                     const Text(
//                       "|",
//                       style: TextStyle(fontSize: 26, color: Colors.grey),
//                     ),
//                     const SizedBox(width: 10),
//                     // Phone number textfield
//                     Expanded(
//                       child: TextFormField(
//                         keyboardType: TextInputType.phone,
//                         controller: phoneNoController,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Phone number is required';
//                           }
//                           if (value.length < 8) {
//                             return 'Enter a valid phone number';
//                           }
//                           return null;
//                         },
//                         decoration: const InputDecoration(
//                           hintText: "Phone Number",
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     style: ButtonStyle(
//                       shape: WidgetStatePropertyAll(
//                         RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
//                       ),
//                       backgroundColor: const WidgetStatePropertyAll(
//                         Color.fromARGB(255, 7, 192, 106)
//                       ),
//                       fixedSize: WidgetStatePropertyAll(
//                         Size.fromWidth(MediaQuery.of(context).size.width)
//                       ),
//                     ),
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         setState(() {
//                           _isLoading = true;
//                         });
                        
//                         String fullPhoneNumber = 
//                             countryController.text + phoneNoController.text;
                        
//                         try {
//                           await FirebaseAuth.instance.verifyPhoneNumber(
//                             phoneNumber: fullPhoneNumber,
//                             verificationCompleted: (PhoneAuthCredential credential) {
//                               // Auto-sign-in on Android devices
//                               FirebaseAuth.instance.signInWithCredential(credential)
//                                 .then((value) {
//                                   Navigator.of(context).pushReplacement(
//                                     MaterialPageRoute(builder: (context) => HomeScreen())
//                                   );
//                                 });
//                             },
//                             verificationFailed: (FirebaseAuthException ex) {
//                               setState(() {
//                                 _isLoading = false;
//                               });
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Verification failed: ${ex.message}'),
//                                  margin: EdgeInsets.all(16),
//                                  behavior: SnackBarBehavior.floating,
//                               backgroundColor: Colors.red,                                )
//                               );
//                               log('Verification failed: $ex');
//                             },
//                             codeSent: (String verificationId, int? resendToken) {
//                               setState(() {
//                                 _isLoading = false;
//                               });
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => OtpScreen(
//                                     verificationId: verificationId,
//                                     phoneNumber: fullPhoneNumber,
//                                   ),
//                                 ),
//                               );
//                             },
//                             codeAutoRetrievalTimeout: (String verificationId) {
//                               // Auto-resolution timed out...
//                               setState(() {
//                                 _isLoading = false;
//                               });
//                             },
//                             timeout: const Duration(seconds: 60),
//                           );
//                         } catch (e) {
//                           setState(() {
//                             _isLoading = false;
//                           });
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               margin: EdgeInsets.all(16),
//                               content: Text('Error: ${e.toString()}'),
//                               behavior: SnackBarBehavior.floating,
//                               backgroundColor: Colors.green,
//                               ),
//                           );
//                           log('Error: $e');
//                         }
//                       }
//                     },
//                     child: const Text(
//                       "Send the code",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'package:coffee_shop/Authentication/otp_screen.dart';
import 'package:coffee_shop/Features/Login_Screen/authenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PhoneAuth extends ConsumerStatefulWidget {
  const PhoneAuth({super.key});

  @override
  ConsumerState<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends ConsumerState<PhoneAuth> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _verificationId; 
  
  @override
  void initState() {
    super.initState();
    countryController.text = "+91";
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    context.go('/navbar');
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.amberAccent,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text("Skip")),
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              "Phone Verification",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We need to register your phone number before getting started",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    // Country code textfield
                    SizedBox(
                      width: 40,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: countryController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (!value.startsWith('+')) {
                            return 'Must start with +';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 26, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    // Phone number textfield
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phoneNoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          if (value.length < 8) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Phone Number",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ButtonStyle(
                      shape:  WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                      ),
                      backgroundColor: const WidgetStatePropertyAll(
                        Color.fromARGB(255, 7, 192, 106)
                      ),
                      fixedSize: WidgetStatePropertyAll(
                        Size.fromWidth(MediaQuery.of(context).size.width)
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String fullPhoneNumber =
                            countryController.text + phoneNoController.text;

                        try {
                          await ref.read(authNotifierProvider.notifier)
                              .verifyPhoneNumber(
                                fullPhoneNumber, 
                                onCodeSent: (verificationId) {
                                  setState(() {
                                    _verificationId = verificationId;
                                  });
                                  // Navigate to OTP screen after getting verificationId
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                        phoneNumber: fullPhoneNumber,
                                        verificationId: verificationId,
                                      ),
                                    ),
                                  );
                                }
                              );
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              margin: const EdgeInsets.all(16),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red,
                            ),
                          );
                          log('Error: $e');
                        }
                      }
                    },
                    child: const Text(
                      "Send the code",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}