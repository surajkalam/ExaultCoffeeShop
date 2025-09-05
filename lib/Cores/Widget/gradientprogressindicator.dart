// import 'package:flutter/material.dart';
// class GradientProgressIndicator extends StatelessWidget {
//   final double height;
//   final double? progress; 

//   const GradientProgressIndicator({
//     super.key,
//     this.height = 6,
//     this.progress,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: SizedBox(
//         height: height,
//         child: Stack(
//           children: [
//             // Background
//             Container(color: Colors.black),
//             // Animated progress with gradient
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 final width = progress != null
//                     ? constraints.maxWidth * progress!
//                     : constraints.maxWidth;
//                 return AnimatedContainer(
//                   duration: Duration(milliseconds: 500),
//                   curve: Curves.easeInOut,
//                   width: width,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFFFFA726),
//                         Color(0xFFFF7043),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }