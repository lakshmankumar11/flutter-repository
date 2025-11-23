import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GoldPriceChart extends StatelessWidget {
  GoldPriceChart({Key? key}) : super(key: key);

  // Dummy 7-day gold price data
  final List<double> goldPrices = [5915, 5920, 5910, 5925, 5932, 5918, 5922];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '📈 7-Day Gold Price Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade900,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt() % days.length],
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, _) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text('₹${value.toInt()}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ),
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.amber.shade100),
                  ),
                  minY: 5900,
                  maxY: 5940,
                  lineBarsData: [
                    LineChartBarData(
                      spots: goldPrices
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                          .toList(),
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.amber.shade700,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.amber.shade100.withOpacity(0.3),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
