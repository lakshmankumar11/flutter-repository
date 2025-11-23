import 'package:flutter/material.dart';
import 'package:gold_purchase_app/admin/pages/createNewAdmin/new_admin_create.dart';
import 'package:gold_purchase_app/components/profilepages/v-1/ProfilePagec.dart';
import '../../../utils/logout.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;

    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Admin Profile',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),

      endDrawer: Drawer(
        backgroundColor: Colors.amber.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Center(
                child: Text(
                  'My Account',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        
            ListTile(
              leading: const Icon(Icons.logout,
              color: Colors.amber),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogoutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout,
              color: Colors.amber),
              title: const Text("Create Admin"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewAdminCreatePage()),
                );
              },
            ),


          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 20),
          ProfilePagec(),
          ],
        ),
      ),
    );
  }
}
