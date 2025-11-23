// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import '../../views/config/constantsApiBaseUrl.dart';
// import '../../utils/logout.dart';
// import '../profilepages/kyc_verification/kyc_verification_page.dart';

// class UserProfileFormPage extends StatefulWidget {
//   const UserProfileFormPage({super.key});

//   @override
//   State<UserProfileFormPage> createState() => _UserProfileFormPageState();
// }

// class _UserProfileFormPageState extends State<UserProfileFormPage> {
//   final _formKey = GlobalKey<FormState>();

//   List<Map<String, dynamic>> userSchemes = [];

//   String? name, username, address, mobile, aadharNumber, accountNo, ifsc;
//   File? profileImage;
//   String? imageUrl;
//   bool isLoading = true;
//   bool isEdit = false;
//   String? userId;
//   String? token;

//   bool isProfileComplete = false;

//   // Dropdown options
//   final List<String> schemeTypes = ['Fixed Plan', 'Flexible Plan'];
//   final List<String> metals = ['Gold', 'Silver'];
//   final List<String> frequencies = ['Daily', 'Weekly', 'Monthly'];
//   final List<String> durations = ['6 Months', '1 Year', '2 Years'];

//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile();
//   }

//   Widget _buildSchemeCard(Map<String, dynamic> scheme, int index) {
//     // Initialize dropdown values with current scheme data or defaults
//     String selectedSchemeType = scheme['schemeType'] ?? 'Fixed Plan';
//     String selectedMetal = scheme['metal'] ?? 'Gold';
//     String selectedFrequency = scheme['frequency'] ?? 'Monthly';
//     String selectedDuration = scheme['duration']?.toString() ?? '1 Year';
//     double monthlyAmount = scheme['monthlyAmount']?.toDouble() ?? 0.0;
//     double oneTimeAmount = scheme['oneTimeAmount']?.toDouble() ?? 0.0;

//     return Card(
//       elevation: 8,
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.amber.shade50,
//               Colors.amber.shade100,
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.card_membership, color: Colors.amber.shade800, size: 28),
//                   const SizedBox(width: 12),
//                   Text(
//                     'Scheme ${index + 1}',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.amber.shade900,
//                     ),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     onPressed: () => _deleteScheme(index),
//                     icon: Icon(Icons.delete, color: Colors.red.shade600),
//                     tooltip: 'Delete Scheme',
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Scheme Type Dropdown
//               _buildDropdownField(
//                 'Scheme Type',
//                 selectedSchemeType,
//                 schemeTypes,
//                 Icons.category,
//                 (String? newValue) {
//                   setState(() {
//                     userSchemes[index]['schemeType'] = newValue;
//                   });
//                 },
//               ),

//               // Metal Dropdown
//               _buildDropdownField(
//                 'Metal',
//                 selectedMetal,
//                 metals,
//                 Icons.diamond,
//                 (String? newValue) {
//                   setState(() {
//                     userSchemes[index]['metal'] = newValue;
//                   });
//                 },
//               ),

//               // Frequency Dropdown
//               _buildDropdownField(
//                 'Frequency',
//                 selectedFrequency,
//                 frequencies,
//                 Icons.schedule,
//                 (String? newValue) {
//                   setState(() {
//                     userSchemes[index]['frequency'] = newValue;
//                   });
//                 },
//               ),

//               // Duration Dropdown
//               _buildDropdownField(
//                 'Duration',
//                 selectedDuration,
//                 durations,
//                 Icons.timer,
//                 (String? newValue) {
//                   setState(() {
//                     userSchemes[index]['duration'] = newValue;
//                   });
//                 },
//               ),

//               // Monthly Amount
//               _buildAmountField(
//                 'Monthly Amount',
//                 monthlyAmount,
//                 (String value) {
//                   setState(() {
//                     userSchemes[index]['monthlyAmount'] = double.tryParse(value) ?? 0.0;
//                   });
//                 },
//               ),

//               // One-time Amount
//               _buildAmountField(
//                 'One-time Amount',
//                 oneTimeAmount,
//                 (String value) {
//                   setState(() {
//                     userSchemes[index]['oneTimeAmount'] = double.tryParse(value) ?? 0.0;
//                   });
//                 },
//               ),

//               // Joined Date (Read-only)
//               _buildReadOnlyField(
//                 'Joined On',
//                 scheme['createdAt']?.toString().split("T")[0] ?? 'Not specified',
//                 Icons.calendar_today,
//               ),

//               const SizedBox(height: 20),
              
//               // Action Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _saveScheme(index),
//                       icon: const Icon(Icons.save, color: Colors.white),
//                       label: const Text('Save Changes', style: TextStyle(color: Colors.white)),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green.shade600,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         elevation: 4,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _resetScheme(index),
//                       icon: Icon(Icons.refresh, color: Colors.amber.shade800),
//                       label: Text('Reset', style: TextStyle(color: Colors.amber.shade800)),
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(color: Colors.amber.shade800),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownField(
//     String label,
//     String currentValue,
//     List<String> options,
//     IconData icon,
//     Function(String?) onChanged,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: DropdownButtonFormField<String>(
//         value: options.contains(currentValue) ? currentValue : options.first,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.amber.shade800),
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.amber.shade800),
//           filled: true,
//           fillColor: Colors.white,
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.amber.shade300),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.amber.shade800, width: 2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//         items: options.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value, style: const TextStyle(fontSize: 16)),
//           );
//         }).toList(),
//         onChanged: onChanged,
//         validator: (value) => value == null ? 'Please select $label' : null,
//       ),
//     );
//   }

//   Widget _buildAmountField(String label, double initialValue, Function(String) onChanged) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         initialValue: initialValue.toString(),
//         keyboardType: TextInputType.numberWithOptions(decimal: true),
//         decoration: InputDecoration(
//           prefixIcon: Icon(Icons.currency_rupee, color: Colors.amber.shade800),
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.amber.shade800),
//           filled: true,
//           fillColor: Colors.white,
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.amber.shade300),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.amber.shade800, width: 2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//         onChanged: onChanged,
//         validator: (value) {
//           if (value == null || value.isEmpty) return 'Please enter $label';
//           if (double.tryParse(value) == null) return 'Please enter a valid amount';
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildReadOnlyField(String label, String value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         initialValue: value,
//         readOnly: true,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.grey.shade600),
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.grey.shade600),
//           filled: true,
//           fillColor: Colors.grey.shade100,
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//       ),
//     );
//   }

//   void _saveScheme(int index) {
//     // Here you can implement API call to save the scheme
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Scheme ${index + 1} saved successfully'),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _resetScheme(int index) {
//     setState(() {
//       // Reset to original values or defaults
//       fetchUserProfile(); // Refresh from server
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Scheme ${index + 1} reset to original values'),
//         backgroundColor: Colors.orange,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _deleteScheme(int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Scheme'),
//           content: Text('Are you sure you want to delete Scheme ${index + 1}?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   userSchemes.removeAt(index);
//                 });
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Scheme deleted successfully'),
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );
//               },
//               child: const Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _addNewScheme() {
//     setState(() {
//       userSchemes.add({
//         'schemeType': 'Fixed Plan',
//         'metal': 'Gold',
//         'frequency': 'Monthly',
//         'duration': '1 Year',
//         'monthlyAmount': 0.0,
//         'oneTimeAmount': 0.0,
//         'createdAt': DateTime.now().toIso8601String(),
//       });
//     });
//   }

//   Future<void> fetchUserProfile() async {
//     final prefs = await SharedPreferences.getInstance();
//     token = prefs.getString('auth_token');

//     if (token == null || JwtDecoder.isExpired(token!)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Session expired. Please log in again.")),
//       );
//       setState(() => isLoading = false);
//       return;
//     }

//     final decodedToken = JwtDecoder.decode(token!);
//     userId = decodedToken['userId'] ?? decodedToken['_id'] ?? decodedToken['id'];

//     if (userId == null) {
//       debugPrint("User ID not found in token.");
//       setState(() => isLoading = false);
//       return;
//     }

//     try {
//       final response = await http.get(
//         Uri.parse('${AppConstants.baseUrl}/user/profile/$userId'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body)['user'];

//         setState(() {
//           name = data['name'];
//           username = data['username'];
//           address = data['address'];
//           mobile = data['mobile'];
//           aadharNumber = data['aadharNumber'];
//           accountNo = data['accountNo'];
//           ifsc = data['ifsc'];
//           imageUrl = data['aadharImageUrl'];
//           isEdit = true;

//           userSchemes = List<Map<String, dynamic>>.from(data['schemes'] ?? []);

//           isProfileComplete = name != null &&
//               username != null &&
//               address != null &&
//               mobile != null &&
//               aadharNumber != null &&
//               accountNo != null &&
//               ifsc != null;
//         });
//         prefs.setBool('is_profile_complete', isProfileComplete);
//       }
//     } catch (e) {
//       debugPrint("Error fetching profile: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() => profileImage = File(picked.path));
//     }
//   }

//   Future<void> saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     final uri = Uri.parse(
//       '${AppConstants.baseUrl}/user/profile${isEdit ? '/$userId' : ''}',
//     );

//     final request = http.MultipartRequest(isEdit ? 'PUT' : 'POST', uri);
//     request.headers['Authorization'] = 'Bearer $token';

//     request.fields['name'] = name!;
//     request.fields['username'] = username!;
//     request.fields['address'] = address!;
//     request.fields['mobile'] = mobile!;
//     request.fields['aadharNumber'] = aadharNumber!;
//     request.fields['accountNo'] = accountNo!;
//     request.fields['ifsc'] = ifsc!;

//     if (profileImage != null) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'aadharImage',
//         profileImage!.path,
//       ));
//     }

//     try {
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Profile ${isEdit ? 'updated' : 'created'} successfully'),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       } else {
//         debugPrint("Failed: $respStr");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $respStr'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint("Error during request: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Something went wrong. Please try again."),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: Drawer(
//         child: Column(
//           children: [
//             const UserAccountsDrawerHeader(
//               accountName: Text("User Menu"),
//               accountEmail: Text(""),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, size: 40),
//               ),
//               decoration: BoxDecoration(
//                 color: Color(0xFFFFD700),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text("Settings"),
//               onTap: () {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Settings tapped")),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.badge),
//               title: const Text("KYC Update"),
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (_) => const KYCVerificationPage()));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text("Logout"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const LogoutPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: Text(isEdit ? "Profile" : "Create Profile"),
//         backgroundColor: Colors.amber.shade700,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           Builder(
//             builder: (context) => IconButton(
//               icon: const Icon(Icons.menu),
//               onPressed: () => Scaffold.of(context).openEndDrawer(),
//             ),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   // Profile Section
//                   Card(
//                     elevation: 8,
//                     shadowColor: Colors.amber.shade200,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Colors.amber.shade50,
//                             Colors.amber.shade100,
//                           ],
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(24),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               // Profile Image
//                               GestureDetector(
//                                 onTap: pickImage,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(color: Colors.amber.shade800, width: 4),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.amber.shade200,
//                                         blurRadius: 10,
//                                         offset: const Offset(0, 5),
//                                       ),
//                                     ],
//                                   ),
//                                   child: CircleAvatar(
//                                     radius: 55,
//                                     backgroundImage: profileImage != null
//                                         ? FileImage(profileImage!)
//                                         : (imageUrl != null
//                                             ? NetworkImage(imageUrl!)
//                                             : const AssetImage('assets/images/goldimg.png'))
//                                             as ImageProvider,
//                                     backgroundColor: Colors.amber.shade100,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 24),

//                               // Profile Form Fields
//                               _buildStyledTextField("Name", name ?? '', (val) => name = val, Icons.person),
//                               _buildStyledTextField("Username", username ?? '', (val) => username = val, Icons.alternate_email),
//                               _buildStyledTextField("Mobile", mobile ?? '', (val) => mobile = val, Icons.phone_android),
//                               _buildStyledTextField("Address", address ?? '', (val) => address = val, Icons.home),
//                               _buildStyledTextField("Aadhar Number", aadharNumber ?? '', (val) => aadharNumber = val, Icons.credit_card),
//                               _buildStyledTextField("Account No", accountNo ?? '', (val) => accountNo = val, Icons.account_balance),
//                               _buildStyledTextField("IFSC", ifsc ?? '', (val) => ifsc = val, Icons.code),

//                               const SizedBox(height: 30),

//                               // Save Profile Button
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton.icon(
//                                   icon: Icon(isEdit ? Icons.save : Icons.person_add, color: Colors.white),
//                                   label: Text(
//                                     isEdit ? "Update Profile" : "Create Profile",
//                                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
//                                   ),
//                                   onPressed: saveProfile,
//                                   style: ElevatedButton.styleFrom(
//                                     padding: const EdgeInsets.symmetric(vertical: 16),
//                                     backgroundColor: Colors.amber.shade800,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                     elevation: 6,
//                                     shadowColor: Colors.amber,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Schemes Section
//                   if (userSchemes.isNotEmpty || isEdit) ...[
//                     const SizedBox(height: 32),
//                     Row(
//                       children: [
//                         Icon(Icons.card_membership, color: Colors.amber.shade800, size: 28),
//                         const SizedBox(width: 12),
//                         const Text(
//                           'Your Schemes',
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         const Spacer(),
//                         ElevatedButton.icon(
//                           onPressed: _addNewScheme,
//                           icon: const Icon(Icons.add, color: Colors.white),
//                           label: const Text('Add Scheme', style: TextStyle(color: Colors.white)),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.amber.shade800,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
                    
//                     if (userSchemes.isEmpty)
//                       Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(32),
//                           child: Column(
//                             children: [
//                               Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
//                               const SizedBox(height: 16),
//                               Text(
//                                 'No schemes found',
//                                 style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'Click "Add Scheme" to create your first scheme',
//                                 style: TextStyle(color: Colors.grey.shade500),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     else
//                       ...userSchemes.asMap().entries.map((entry) {
//                         int index = entry.key;
//                         Map<String, dynamic> scheme = entry.value;
//                         return _buildSchemeCard(scheme, index);
//                       }).toList(),
//                   ],
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildStyledTextField(
//     String label,
//     String initialValue,
//     Function(String) onChanged,
//     IconData icon,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         initialValue: initialValue,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.amber.shade800),
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.amber.shade800),
//           filled: true,
//           fillColor: Colors.white,
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.amber.shade300),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.amber.shade800, width: 2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//         onChanged: onChanged,
//         validator: (value) => value == null || value.isEmpty ? "Please enter $label" : null,
//       ),
//     );
//   }
// }