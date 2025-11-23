import 'package:flutter/material.dart';

class SilverSliderPage extends StatelessWidget {
  final List<Map<String, String>> silverItems = [
    {
      "title": "Silver Chain",
      "image": "assets/images/banner1.jpg",
    },
    {
      "title": "Silver Ring",
      "image": "assets/images/banner.jpg",
    },
    {
      "title": "Silver Bracelet",
      "image": "assets/images/goldcoin.jpeg",
    },
    {
      "title": "Silver Bangle",
      "image": "assets/images/goldbanner.jpg",
    },
    {
      "title": "Silver Anklet",
      "image": "assets/images/banner1.jpg",
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
              "Top Silver Picks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: silverItems.length,
              itemBuilder: (context, index) {
                final item = silverItems[index];
                return Container(
                  width: 140,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
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
                          style: TextStyle(fontWeight: FontWeight.w600),
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
