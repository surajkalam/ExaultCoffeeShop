import 'dart:developer';
import 'package:coffee_shop/Authentication/otp_screen.dart';
import 'package:coffee_shop/Features/Login_Screen/authenticationService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset(
              'Assets/Icons/Robot_says_hello.json',
              height: 300,
              width: 300,
            ),
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
                      color: colorScheme.onPrimaryFixed,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text("Skip")),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "Phone Verification",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We need to register your phone number before getting started",
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.shadow, width: 2),
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
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
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
                        decoration: InputDecoration(
                          hintText: "Enter valid phone number..",
                          hintStyle: textTheme.bodySmall?.copyWith(
                            color: colorScheme.secondary,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor: const WidgetStatePropertyAll(
                        Colors.green,
                      ),
                      fixedSize: WidgetStatePropertyAll(
                        Size.fromWidth(MediaQuery.of(context).size.width),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String fullPhoneNumber =
                            countryController.text + phoneNoController.text;

                        try {
                          await ref
                              .read(authNotifierProvider.notifier)
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
                                },
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
                    child: Text(
                      "Send the code",
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryFixed,
                        fontSize: 12,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_verificationId', _verificationId));
  }
}
// import 'dart:developer';
// import 'package:coffee_shop/Authentication/otp_screen.dart' show LoginController, OtpScreen;
// import 'package:flutter/material.dart';
// class PhoneAuth extends StatefulWidget {
//   const PhoneAuth({super.key});

//   @override
//   State<PhoneAuth> createState() => _PhoneAuthState();
// }

// class _PhoneAuthState extends State<PhoneAuth> {
//   TextEditingController countryController = TextEditingController();
//   TextEditingController phoneNoController = TextEditingController();

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
//             Image.asset(
//               "assets/img1.png",
//               width: 200,
//               height: 200,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const Text(
//               "Phone Verification",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Text(
//               "We need to register your phone number before getting started",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey, width: 2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   const SizedBox(
//                     width: 10,
//                   ),

//                   //country textfield
//                   SizedBox(
//                     width: 40,
//                     child: TextField(
//                       keyboardType: TextInputType.phone,
//                       controller: countryController,
//                       decoration:
//                           const InputDecoration(border: InputBorder.none),
//                     ),
//                   ),

//                   const Text(
//                     "|",
//                     style: TextStyle(fontSize: 26, color: Colors.grey),
//                   ),

//                   const SizedBox(
//                     width: 10,
//                   ),

//                   // number textfield
//                   Expanded(
//                     child: SizedBox(
//                         width: 50,
//                         child: TextField(
//                           keyboardType: TextInputType.number,
//                           controller: phoneNoController,
//                           decoration: const InputDecoration(
//                               hintText: "Phone", border: InputBorder.none),
//                         )),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//                 style: ButtonStyle(
//                     shape: WidgetStatePropertyAll(RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8))),
//                     backgroundColor: const WidgetStatePropertyAll(
//                         Color.fromARGB(255, 7, 192, 106)),
//                     fixedSize: WidgetStatePropertyAll(
//                         Size.fromWidth(MediaQuery.of(context).size.width))),
//                 onPressed: () async {
//                   try {
//                     LoginController controller = LoginController();
//                     await controller
//                         .verifyPhoneNumber('+91${phoneNoController.text}');

//                     Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => OtpScreen()));
//                   } catch (ex) {
//                     log(ex.toString());
//                   }
//                 },
//                 child: const Text(
//                   "Send the code",
//                   style: TextStyle(color: Colors.white),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
