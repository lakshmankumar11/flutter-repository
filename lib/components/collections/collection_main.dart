import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './gold_collections/gold_collections_main.dart';
import './silver_collections/silver_collections_main.dart';

class MainCollectionsPage extends StatefulWidget {
  const MainCollectionsPage({super.key});

  @override
  State<MainCollectionsPage> createState() => _MainCollectionsPageState();
}

class _MainCollectionsPageState extends State<MainCollectionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Color getBackgroundColor(int index) {
    return index == 0 ? Colors.amber.shade50 : Colors.grey.shade200;
  }

  Color getTextColor(int index) {
    return index == 0 ? Colors.black : Colors.white;
  }

  Color getTabIndicatorColor(int index) {
    return index == 0 ? Colors.orange : Colors.black;
  }

  Color getAppBarColor(int index) {
    return index == 0 ? Colors.amber : Colors.grey;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTabIndex = _tabController.index;

    return Scaffold(
      backgroundColor: getBackgroundColor(currentTabIndex),
      appBar: AppBar(
        title: Text(
          'our_jewellery_collections'.tr,
          style: TextStyle(color: getTextColor(currentTabIndex)),
        ),
        centerTitle: true,
        backgroundColor: getAppBarColor(currentTabIndex),
        iconTheme: IconThemeData(color: getTextColor(currentTabIndex)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: getTextColor(currentTabIndex),
          unselectedLabelColor: Colors.grey.shade200,
          indicatorColor: getTabIndicatorColor(currentTabIndex),
          tabs: [
            Tab(text: 'gold'.tr),
            Tab(text: 'silver'.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GoldCollectionsMainPage(),
          SilverCollectionsMainPage(),
        ],
      ),
    );
  }
}
