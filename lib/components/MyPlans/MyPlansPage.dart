import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 Add GetX for translation
import 'package:gold_purchase_app/components/MyPlans/schemes_page.dart';

class MyPlansPage extends StatefulWidget {
  const MyPlansPage({Key? key}) : super(key: key);

  @override
  State<MyPlansPage> createState() => _MyPlansPageState();
}

class _MyPlansPageState extends State<MyPlansPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Animate the opacity for page load
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.amber.shade700;

    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: Text('my_plans'.tr), // 👈 Translated title
        centerTitle: true,
        elevation: 4,
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: SchemesPage(),
        ),
      ),
    );
  }
}
