import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_purchase_app/components/MarqueeWidget/MarqueeWidget.dart';
import 'package:gold_purchase_app/components/buygoldpages/schemes/SchemePage.dart';
import 'package:gold_purchase_app/components/collections/collection_main.dart';
import 'carousel_banner.dart';
import 'home_promo_panel.dart';
import '../profilepages/v-1/profile_page_main.dart';
import '../history/history_page.dart';
import './SubaGoldAppOverview.dart';
import '../MyPlans/MyPlansPage.dart';
import './gold_price_page.dart';
import './silver_price_page.dart';
import '../../utils/refresh_helpers.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    handleGlobalRefresh(context);
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: () => handleGlobalRefresh(context),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Column(
            children: [
              GoldPriceCard(),
              const SizedBox(height: 12),
              SilverPriceCard(),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarqueeWidget(
                text: 'marquee_text'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.deepOrange,
                ),
                velocity: 30,
                blankSpace: 80,
              ),
              const SizedBox(height: 20),
              Text(
                'welcome_text'.tr,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'explore_collections'.tr,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
              ),
            ],
          ),
          const SizedBox(height: 54),
          SwiperBanner(),
          const SizedBox(height: 44),
          HomePromoPanel(),
          const SizedBox(height: 24),
          SchemeSection(),
          const SizedBox(height: 44),
          SubaGoldAppOverview(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _changeLanguage(Locale locale) {
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    // Pages for bottom navigation
    List<Widget> pages = [
      _buildHomeTab(),
      MyPlansPage(),
      MainCollectionsPage(),
      OrderHistoryPage(),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber.shade100,
        centerTitle: true,
        title: Text(
          'app_name'.tr,
          style: TextStyle(
            color: Colors.amber.shade900,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'en') _changeLanguage(const Locale('en', 'US'));
              if (value == 'ta') _changeLanguage(const Locale('ta', 'IN'));
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'en', child: Text('english'.tr)),
              PopupMenuItem(value: 'ta', child: Text('tamil'.tr)),
            ],
            icon: Icon(Icons.language, color: Colors.amber.shade900),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: Colors.amber.shade900,
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              _buildNavItem(Icons.home_rounded, 'home'.tr, 0),
              _buildNavItem(Icons.favorite_rounded, 'my_plans'.tr, 1),
              _buildNavItem(Icons.star_rounded, 'collections'.tr, 2),
              _buildNavItem(Icons.history_rounded, 'history'.tr, 3),
              _buildNavItem(Icons.person_rounded, 'profile'.tr, 4),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: _currentIndex == index ? 26 : 22,
        color: _currentIndex == index ? Colors.amber.shade900 : Colors.grey.shade600,
      ),
      label: label,
    );
  }
}
