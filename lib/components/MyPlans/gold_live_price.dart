import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gold_price_chart.dart';
import '../../providers/metal_rate_provider.dart';

class GoldLivePrice extends StatefulWidget {
  const GoldLivePrice({Key? key}) : super(key: key);

  @override
  State<GoldLivePrice> createState() => _GoldLivePriceState();
}

class _GoldLivePriceState extends State<GoldLivePrice> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<GoldRateProvider>(context, listen: false).fetchMetalPrices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final goldProvider = Provider.of<GoldRateProvider>(context);
    final goldPrice = goldProvider.gold999Rate;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade100,
            Colors.amber.shade50,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: goldProvider.fetchMetalPrices,
        color: Colors.amber.shade800,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GoldPriceChart(),

                Text(
                  '💰 Live Gold Price',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Updated every few minutes (pull to refresh)',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),

                // Main Price Card or Spinner
                goldProvider.isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: CircularProgressIndicator(
                          color: Colors.amber.shade800,
                          strokeWidth: 3,
                        ),
                      )
                    : goldPrice == null
                        ? Text("Error loading price")
                        : AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 16,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                            child: Column(
                              children: [
                                Icon(Icons.currency_rupee_rounded,
                                    color: Colors.amber.shade800, size: 50),
                                const SizedBox(height: 8),
                                AnimatedSwitcher(
                                  duration: Duration(milliseconds: 500),
                                  transitionBuilder: (child, anim) =>
                                      FadeTransition(opacity: anim, child: child),
                                  child: Text(
                                    '₹ ${goldPrice.toStringAsFixed(2)} / gram',
                                    key: ValueKey(goldPrice),
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade900,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '24K Gold (999 purity)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),

                const SizedBox(height: 30),

                // Card Slider
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (_, __) => SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final stats = [
                        {
                          'title': 'Today\'s Price',
                          'value': goldPrice != null
                              ? '₹ ${goldPrice.toStringAsFixed(2)}'
                              : '₹ -',
                          'icon': Icons.today,
                        },
                        {
                          'title': 'Weekly Avg',
                          'value': '₹ 5,915.80',
                          'icon': Icons.bar_chart_rounded,
                        },
                        {
                          'title': 'Monthly Trend',
                          'value': '📈 Stable',
                          'icon': Icons.show_chart,
                        },
                        {
                          'title': 'Buy/Sell Diff',
                          'value': '₹ 30',
                          'icon': Icons.currency_exchange_rounded,
                        },
                      ];

                      final item = stats[index];
                      return Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Icon(item['icon'] as IconData, color: Colors.amber.shade700, size: 30),

                            SizedBox(height: 12),
                             Text(
        item['value'] as String,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.amber.shade900,
        ),
                            ),
                            SizedBox(height: 6),
                            Text(
        item['title'] as String,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Manual refresh button
                goldProvider.isLoading
                    ? SizedBox.shrink()
                    : ElevatedButton.icon(
                        onPressed: goldProvider.fetchMetalPrices,
                        icon: Icon(Icons.refresh),
                        label: Text("Refresh Now"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.amber.shade800,
                          elevation: 3,
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
