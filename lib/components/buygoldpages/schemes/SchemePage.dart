import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/components/MyPlans/CreateSchemePage.dart';
import '../../../controller/schemes_controller.dart';

class SchemeSection extends StatefulWidget {
  const SchemeSection({super.key});

  @override
  State<SchemeSection> createState() => _SchemeSectionState();
}

class _SchemeSectionState extends State<SchemeSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> predefinedSchemes = [
    {
      "type": "flexi_plan",
    },
    {
      "type": "fixed_plan",
    },
  ];

  @override
  void initState() {
    super.initState();

    Get.find<SchemeController>().loadSchemesForUser();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (_pageController.hasClients) {
          _currentPage++;
          _pageController.animateToPage(
            _currentPage % predefinedSchemes.length,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String getFriendlySchemeType(String schemeType) {
    const schemeTypeMap = {
      'flexi_plan': 'flexible_gold_plan',
      'fixed_plan': 'fixed_gold_plan',
    };
    return (schemeTypeMap[schemeType] ?? schemeType.replaceAll('_', ' '))
        .tr;
  }

  String getSchemeDescription(String schemeType) {
    return schemeType == 'flexi_plan'
        ? 'flexible_gold_plan_desc'.tr
        : 'fixed_gold_plan_desc'.tr;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SchemeController>();

    return SizedBox(
      height: 320,
      child: PageView.builder(
        controller: _pageController,
        itemCount: predefinedSchemes.length,
        itemBuilder: (context, index) {
          final scheme = predefinedSchemes[index];
          final schemeType = scheme['type'] ?? '';
          final friendlyTitle = getFriendlySchemeType(schemeType);
          final description = getSchemeDescription(schemeType);

          return Padding(
            key: ValueKey(schemeType),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              final isJoined =
                  controller.schemes.any((s) => s.schemeType == schemeType);

              return SchemeCard(
                title: friendlyTitle,
                description: description,
                isJoined: isJoined,
                onJoin: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          title: Text('create_scheme'.tr),
                          backgroundColor: Colors.amber.shade700,
                        ),
                        body: const SafeArea(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(16),
                            child: CreateSchemeForm(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }
}

class SchemeCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isJoined;
  final VoidCallback onJoin;

  const SchemeCard({
    super.key,
    required this.title,
    required this.description,
    required this.isJoined,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFECB3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 16.5,
              color: Colors.grey.shade900,
              height: 1.5,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton.icon(
              onPressed: isJoined ? null : onJoin,
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              label: Text(
                isJoined ? 'already_joined'.tr : 'join_now'.tr,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isJoined ? Colors.grey.shade400 : Colors.black,
                foregroundColor: Colors.amber,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
