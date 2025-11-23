import 'package:flutter/material.dart';
import 'package:gold_purchase_app/admin/pages/CustomerSchemesList/customers_schemes_main.dart';
import 'package:gold_purchase_app/admin/pages/CustomersHistory/customer_history_main.dart';
import 'package:gold_purchase_app/admin/pages/collection_handlling/collection_main.dart';
import 'package:gold_purchase_app/admin/pages/customersLists/users_list_main.dart';
import 'pages/adminHomepage/home_page.dart';       // <-- new import
import './pages/adminProfile/admin_profile_page.dart';   // <-- new import

class AdminMainDashboard extends StatefulWidget {
  const AdminMainDashboard({super.key});

  @override
  State<AdminMainDashboard> createState() => _AdminMainDashboardState();
}

class _AdminMainDashboardState extends State<AdminMainDashboard> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AdminHomeInnerPage(),             // <-- index 0
    UserListPage(),                   // <-- index 1
    UserPaymentHistoryMainPage(),    // <-- index 2
    UserSchemePlanPageList(),        // <-- index 3
    CollectionhandlingPage(),        // <-- index 4
    AdminProfilePage(),              // <-- index 5
  ];

  final List<String> _titles = [
    'Home',
    'All Users',
    'User History',
    'User Scheme Plans',
    'Collection Details',
    'Profile',
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
    BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
    BottomNavigationBarItem(icon: Icon(Icons.currency_exchange), label: 'Plans'),
    BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Collection'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final Duration _transitionDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AnimatedContainer(
          duration: _transitionDuration,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          child: Center(
            child: Text(
              _titles[_selectedIndex],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: _transitionDuration,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[700],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
