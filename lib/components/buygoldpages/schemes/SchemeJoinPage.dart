// import 'dart:convert';
// import 'package:flutter/material.dart';
// import '../../../views/config/constantsApiBaseUrl.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class SchemeJoinPage extends StatefulWidget {
//   const SchemeJoinPage({super.key});

//   @override
//   State<SchemeJoinPage> createState() => _SchemeJoinPageState();
// }

// class _SchemeJoinPageState extends State<SchemeJoinPage>
//     with SingleTickerProviderStateMixin {
//   String selectedMetal = 'Gold';
//   String selectedFrequency = 'Monthly';
//   String selectedDuration = '1 Year';
//   double amountValue = 0.0;

//   final List<String> metals = ['Gold', 'Silver'];
//   final List<String> frequencies = ['Daily', 'Weekly', 'Monthly'];
//   final List<String> durations = ['6 Months', '1 Year', '2 Years'];
//   // Default values for dropdowns
//   final List<String> schemeTypes = ['Fixed Plan', 'Flexible Plan'];
// String selectedSchemeType = 'Fixed Plan'; // Default value



// Widget _buildSchemeTypeDropdown() {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     decoration: BoxDecoration(
//       color: Colors.grey.shade100,
//       borderRadius: BorderRadius.circular(14),
//       border: Border.all(color: gold, width: 1.2),
//     ),
//     child: DropdownButtonHideUnderline(
//       child: DropdownButton<String>(
//         value: selectedSchemeType,
//         icon: Icon(Icons.keyboard_arrow_down_rounded, color: gold),
//         style: const TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 16,
//           color: Colors.black87,
//         ),
//         dropdownColor: Colors.white,
//         items: schemeTypes.map((String type) {
//           return DropdownMenuItem<String>(
//             value: type,
//             child: Text(type),
//           );
//         }).toList(),
//         onChanged: (value) {
//           if (value != null) {
//             setState(() => selectedSchemeType = value);
//           }
//         },
//       ),
//     ),
//   );
// }


//   final TextEditingController amountController = TextEditingController();

//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;

//   Color get gold => const Color(0xFFFFC107);
//   Color get whiteBg => const Color(0xFFFDFDFD);

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     amountController.dispose();
//     super.dispose();
//   }

//   int _convertDurationToNumber(String duration) {
//     if (duration.contains('Month')) {
//       return int.tryParse(duration.split(' ')[0]) ?? 6;
//     } else if (duration.contains('Year')) {
//       int year = int.tryParse(duration.split(' ')[0]) ?? 1;
//       return year * 12;
//     }
//     return 12;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteBg,
//       appBar: AppBar(
//         backgroundColor: gold,
//         title: const Text("Join Investment Scheme"),
//         centerTitle: true,
//         foregroundColor: Colors.white,
//         elevation: 2,
//       ),
//       body: SafeArea(
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                     offset: const Offset(2, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   _buildLabel("Select Scheme Type"),
// const SizedBox(height: 8),
// _buildSchemeTypeDropdown(),
// const SizedBox(height: 24),

// _buildLabel("Select Metal"),
// const SizedBox(height: 8),
// _buildChipGroup(metals, selectedMetal, (val) {
//   setState(() => selectedMetal = val);
// }),

//                   _buildLabel("Select Metal"),
//                   const SizedBox(height: 8),
//                   _buildChipGroup(metals, selectedMetal, (val) {
//                     setState(() => selectedMetal = val);
//                   }),
//                   const SizedBox(height: 24),
//                   _buildLabel("Select Frequency"),
//                   const SizedBox(height: 8),
//                   _buildChipGroup(frequencies, selectedFrequency, (val) {
//                     setState(() => selectedFrequency = val);
//                   }),
//                   const SizedBox(height: 24),
//                   _buildLabel("Select Duration"),
//                   const SizedBox(height: 8),
//                   _buildDropdown(),
//                   const SizedBox(height: 24),
//                   _buildLabel("Enter Amount (₹)"),
//                   const SizedBox(height: 8),
//                   _buildAmountField(),
//                   const SizedBox(height: 32),
//                   _buildSubmitButton(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 17,
//         fontWeight: FontWeight.w600,
//         color: Colors.black87,
//       ),
//     );
//   }

//   Widget _buildChipGroup(
//       List<String> options, String selected, Function(String) onSelected) {
//     return Wrap(
//       spacing: 12,
//       runSpacing: 10,
//       children: options.map((option) {
//         final bool isSelected = selected == option;
//         return ChoiceChip(
//           label: Text(option),
//           selected: isSelected,
//           onSelected: (_) => onSelected(option),
//           selectedColor: gold,
//           labelStyle: TextStyle(
//             color: isSelected ? Colors.white : Colors.black87,
//             fontWeight: FontWeight.w600,
//           ),
//           backgroundColor: Colors.grey.shade100,
//           elevation: isSelected ? 3 : 0,
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildDropdown() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: gold, width: 1.2),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedDuration,
//           icon: Icon(Icons.keyboard_arrow_down_rounded, color: gold),
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//             color: Colors.black87,
//           ),
//           dropdownColor: Colors.white,
//           items: durations.map((String duration) {
//             return DropdownMenuItem<String>(
//               value: duration,
//               child: Text(duration),
//             );
//           }).toList(),
//           onChanged: (value) {
//             if (value != null) {
//               setState(() => selectedDuration = value);
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildAmountField() {
//     return TextField(
//       controller: amountController,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         hintText: "Enter amount to invest",
//         prefixIcon: const Icon(Icons.currency_rupee),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: gold, width: 1.5),
//         ),
//         filled: true,
//         fillColor: Colors.grey.shade50,
//       ),
//       onChanged: (value) {
//         setState(() {
//           amountValue = double.tryParse(value) ?? 0.0;
//         });
//       },
//     );
//   }

//   Widget _buildSubmitButton() {
//     return Center(
//       child: ElevatedButton.icon(
//         onPressed: () async {
//           if (amountValue <= 0) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("Please enter a valid amount."),
//                 backgroundColor: Colors.redAccent,
//               ),
//             );
//             return;
//           }

//           try {
//             final prefs = await SharedPreferences.getInstance();
//             final token = prefs.getString('auth_token');
//             final userId = prefs.getString('user_id');

//             if (token == null || userId == null) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Session expired. Please login again."),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//               return;
//             }

//             final url = Uri.parse('${AppConstants.baseUrl}/scheme/$userId'); // Replace this!
//             print("Joining scheme with URL: $url");
//             final response = await http.post(
//               url,
//               headers: {
//                 'Authorization': 'Bearer $token',
//                 'Content-Type': 'application/json',
//               },
//               body: jsonEncode({
//                "schemeType": selectedSchemeType.toLowerCase().replaceAll(' ', '_'),
//                 "metal": selectedMetal.toLowerCase(),
//                 "frequency": selectedFrequency.toLowerCase(),
//                 "duration": _convertDurationToNumber(selectedDuration),
//                 "monthlyAmount": amountValue.toInt(),
//               }),
//             );

//             if (response.statusCode == 200 || response.statusCode == 201) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Scheme joined successfully."),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//               Navigator.pop(context);
//             } else {
//               debugPrint("Failed: ${response.body}");
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text("Failed to join scheme: ${response.reasonPhrase}"),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           } catch (e) {
//             debugPrint("Error: $e");
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("Something went wrong. Please try again."),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         icon: const Icon(Icons.check_circle_outline),
//         label: const Text("Join Scheme", style: TextStyle(fontSize: 16)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: gold,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25),
//           ),
//           elevation: 6,
//         ),
//       ),
//     );
//   }
// }
