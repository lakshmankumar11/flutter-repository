import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../adminApis/controllers/user_list_profile_controller.dart';
import '../../adminApis/controllers/gold_sales_controller.dart';
import '../../adminApis/models/user_list_profile_model.dart';
import '../customersLists/users_list_main.dart';

class AdminStatsPage extends StatefulWidget {
  const AdminStatsPage({super.key});


  @override
  State<AdminStatsPage> createState() => _AdminStatsPageState();
}

class _AdminStatsPageState extends State<AdminStatsPage> {
  final AdminUserController  userController = Get.find<AdminUserController >();
  final GoldSalesController goldController = Get.put(GoldSalesController());

  final RxInt totalUsers = 0.obs;
  final RxInt recentUsers = 0.obs;

  int visibleRecentUserCount = 3;
  final Set<String> expandedUserIds = {};

  @override
void initState() {
  super.initState();

  if (!userController.hasFetched) {
    userController.loadUsers();
  }

  if (!goldController.hasFetched) {
    goldController.fetchGoldSalesData();
  }
}


  Widget buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserDetails(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text("Username: ${user.username}"),
        Text("Mobile: ${user.mobile}"),
        Text("Role: ${user.role}"),
        Text("Aadhar Number: ${user.aadharNumber}"),
        Text("Account No: ${user.accountNo}"),
        Text("IFSC: ${user.ifsc}"),
        Text("Wallet: ₹${user.wallet}"),
        Text("Address: ${user.address}"),
        if (user.referrerId != null && user.referrerId!.isNotEmpty)
          Text("Referrer ID: ${user.referrerId}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      totalUsers.value = userController.userList.length;

      List<UserModel> sortedUsers =
          userController.userList
              .where((user) => user.createdAt.isNotEmpty)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      recentUsers.value = sortedUsers.length;

      final goldData = goldController.goldSalesData.value;

      return goldController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "📊 Admin Overview",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildStatCard(
                          "Total Users",
                          "${totalUsers.value}",
                          Icons.people,
                          Colors.blue,
                        ),
                        buildStatCard(
                          "New Users",
                          "${recentUsers.value}",
                          Icons.person_add,
                          Colors.green,
                        ),
                        buildStatCard(
                          "Total Gold Sale Grams",
                          "${goldData?.totalGrams ?? 0}g",
                          Icons.star,
                          Colors.amber,
                        ),
                        buildStatCard(
                          "Total Gold Sale₹",
                          "₹${goldData?.totalAmount ?? 0}",
                          Icons.attach_money,
                          Colors.orange,
                        ),
                        buildStatCard(
                          "This Month Sale Grams",
                          "${goldData?.thisMonthGrams ?? 0}g",
                          Icons.calendar_today,
                          Colors.teal,
                        ),
                        buildStatCard(
                          "This Month Sale ₹",
                          "₹${goldData?.thisMonthAmount ?? 0}",
                          Icons.monetization_on,
                          Colors.purple,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "🧑‍💻 Recent Users",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visibleRecentUserCount.clamp(
                      0,
                      sortedUsers.length,
                    ),
                    itemBuilder: (context, index) {
                      final user = sortedUsers[index];
                      final createdDate = DateFormat(
                        'dd MMM yyyy – hh:mm a',
                      ).format(DateTime.parse(user.createdAt).toLocal());
                      final isExpanded = expandedUserIds.contains(user.id);

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isExpanded ? Colors.blue[50] : Colors.white,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text("Joined: $createdDate"),
                                trailing: IconButton(
                                  icon: Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isExpanded
                                          ? expandedUserIds.remove(user.id)
                                          : expandedUserIds.add(user.id);
                                    });
                                  },
                                ),
                              ),
                              if (isExpanded) buildUserDetails(user),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  if (visibleRecentUserCount < sortedUsers.length)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const UserListPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.people),
                        label: const Text("View All Users"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                ],
              ),
            );
    });
  }
}
