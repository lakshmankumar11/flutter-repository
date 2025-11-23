import 'package:flutter/material.dart';

class GoldSliderPage extends StatelessWidget {
  final List<Map<String, String>> goldItems = [
    {
      "title": "Gold Chain",
      "image": "assets/images/banner.jpg",
    },
    {
      "title": "Gold Ring",
      "image": "assets/images/banner1.jpg",
    },
    {
      "title": "Gold Necklace",
      "image": "assets/images/banner.jpg",
    },
    {
      "title": "Gold Bracelet",
      "image": "assets/images/banner1.jpg",
    },
    {
      "title": "Gold Bangle",
      "image": "assets/images/banner.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Top Picks for You",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: goldItems.length,
              itemBuilder: (context, index) {
                final item = goldItems[index];
                return Container(
                  width: 140,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 235, 244, 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          item["image"]!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item["title"]!,
                          style: TextStyle(fontWeight: FontWeight.w600,color:const Color.fromARGB(255, 17, 17, 16)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
