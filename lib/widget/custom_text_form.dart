// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final bool obscureText;
//   final String hintText;
//   final bool prefix;
//   final iconPrefix;
//   final Color colorPrefix;

//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.obscureText,
//   }) : super(key: key);
//   // final chatModel;

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(
//         color: Colors.white,
//       ),
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         hintText: hintText,
//         prefixIcon: prefix == false
//             ? null
//             : Icon(
//                 iconPrefix,
//                 color: colorPrefix,
//               ),
//         suffixIcon: IconButton(
//           onPressed: () {
//             setState(() {
//               hidePassword = !hidePassword;
//             });
//           },
//           color: Colors.pink,
//           icon: Icon(
//             hidePassword ? Icons.visibility : Icons.visibility_off,
//             color: CoreColor().appGreen,
//           ),
//         ),
//       ),
//     );
//   }
// }
