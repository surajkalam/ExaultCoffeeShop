// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import '../core/core.dart';
// class OtpScreen extends StatefulWidget {
//   final String verificationId;
//   final String phoneNumber;
  
//   const OtpScreen({super.key, required this.verificationId, required this.phoneNumber});

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   TextEditingController _pinController = TextEditingController();
//   bool _isLoading = false;
//   final int _resendTokenTimeout = 60;
//   int _resendTokenCountdown = 0;
//   bool _canResend = false;

//   @override
//   void initState() {
//     super.initState();
//     _startResendCountdown();
//   }

//   void _startResendCountdown() {
//     setState(() {
//       _resendTokenCountdown = _resendTokenTimeout;
//       _canResend = false;
//     });

//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted) {
//         setState(() {
//           _resendTokenCountdown--;
//         });
//         if (_resendTokenCountdown > 0) {
//           _startResendCountdown();
//         } else {
//           setState(() {
//             _canResend = true;
//           });
//         }
//       }
//     });
//   }

//   Future<void> _verifyOtp() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId, 
//         smsCode: _pinController.text
//       );
      
//       await FirebaseAuth.instance.signInWithCredential(credential);
      
//       // Navigate to home screen on success
//       // ignore: use_build_context_synchronously
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => MainAppere()),
//       );
//     } catch (ex) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Verification failed: ${ex.toString()}'))
//       );
//       log('Error verifying OTP: $ex');
//     }
//   }

//   Future<void> _resendCode() async {
//     if (!_canResend) return;
    
//     setState(() {
//       _isLoading = true;
//       _canResend = false;
//     });

//     try {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: widget.phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) {},
//         verificationFailed: (FirebaseAuthException ex) {
//           setState(() {
//             _isLoading = false;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Resend failed: ${ex.message}'))
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _isLoading = false;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Verification code resent'))
//           );
//           _startResendCountdown();
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() {
//             _isLoading = false;
//           });
//         },
//         timeout: const Duration(seconds: 60),
//         forceResendingToken: null,
//       );
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}'))
//       );
//     }
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
//             const Text(
//               "Phone Verification",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "Enter the code sent to ${widget.phoneNumber}",
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//             ),
//             const SizedBox(height: 20),
//             Pinput(
//               length: 6,
//               autofocus: true,
//               controller: _pinController,
//               onCompleted: (value) {
//                 _verifyOtp();
//               },
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
//                     onPressed: _verifyOtp,
//                     child: const Text(
//                       "Verify Code",
//                       style: TextStyle(color: Colors.white),
//                     )
//                   ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Didn't receive the code?"),
//                 TextButton(
//                   onPressed: _canResend ? _resendCode : null,
//                   child: Text(
//                     _canResend ? "Resend" : "Resend in $_resendTokenCountdown",
//                     style: TextStyle(
//                       color: _canResend 
//                           ? const Color.fromARGB(255, 7, 192, 106)
//                           : Colors.grey,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// otp_screen.dart
import 'package:coffee_shop/Features/Login_Screen/authenticationService.dart';
import 'package:coffee_shop/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;
  
  const OtpScreen({
    super.key,
    required this.phoneNumber, 
    required this.verificationId,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _otpControllers = 
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false; // Added local loading state

  Future<void> _verifyOtp() async {
    String smsCode = _otpControllers
        .map((controller) => controller.text)
        .join();
    
    if (smsCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .signInWithPhoneNumber(
            widget.verificationId,
            smsCode,
          );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainAppere(),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading || _isLoading; // Combined loading states

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'We sent a code to ${widget.phoneNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                    ),
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                        }
                        
                        // Auto-verification when all digits are entered
                        if (value.isNotEmpty && index == 5) {
                          String fullCode = _otpControllers
                              .map((controller) => controller.text)
                              .join();
                          if (fullCode.length == 6) {
                            _verifyOtp();
                          }
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text('Verify OTP'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}