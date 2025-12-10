import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hospital_microgrid/widgets/metric_card.dart';

class AIPredictionPage extends StatefulWidget {
  const AIPredictionPage({super.key});

  @override
  State<AIPredictionPage> createState() => _AIPredictionPageState();
}

class _AIPredictionPageState extends State<AIPredictionPage> {
  static const predictionData = [
    {'hour': '0', 'predicted': 2400.0, 'actual': 2400.0, 'confidence': 98},
    {'hour': '2', 'predicted': 2210.0, 'actual': 2290.0, 'confidence': 97},
    {'hour': '4', 'predicted': 2290.0, 'actual': 2000.0, 'confidence': 96},
    {'hour': '6', 'predicted': 2000.0, 'actual': 2181.0, 'confidence': 95},
    {'hour': '8', 'predicted': 2181.0, 'actual': 2500.0, 'confidence': 94},
    {'hour': '10', 'predicted': 2500.0, 'actual': 2100.0, 'confidence': 93},
    {'hour': '12', 'predicted': 2100.0, 'actual': 2800.0, 'confidence': 92},
  ];

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: const Color(0xFF6366F1),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: 16,
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Machine learning-powered 24-hour forecasting',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.7) : const Color(0xFF0F172A).withOpacity(0.7),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          // Prediction Metrics
          if (isMobile)
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  MetricCard(
                    icon: Icons.psychology,
                    label: 'Model Accuracy',
                    value: '96.2%',
                    change: '+2.1%',
                    gradientColors: const [
                      Color(0xFF6366F1),
                      Color(0xFF06B6D4),
                    ],
                  ),
                  const SizedBox(width: 12),
                  MetricCard(
                    icon: Icons.trending_up,
                    label: '24h Forecast',
                    value: '2.45 MW',
                    change: '+3.2%',
                    gradientColors: const [
                      Color(0xFF06B6D4),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  const SizedBox(width: 12),
                  MetricCard(
                    icon: Icons.warning_amber,
                    label: 'Peak Alert',
                    value: '3.2 MW',
                    change: 'at 14:00',
                    gradientColors: const [
                      Color(0xFF8B5CF6),
                      Color(0xFF6366F1),
                    ],
                  ),
                  const SizedBox(width: 12),
                  MetricCard(
                    icon: Icons.bolt,
                    label: 'Recommended Load',
                    value: '2.1 MW',
                    change: '-8.5%',
                    gradientColors: const [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 4;
                if (constraints.maxWidth < 1200) crossAxisCount = 2;
                
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
              MetricCard(
                icon: Icons.psychology,
                label: 'Model Accuracy',
                value: '96.2%',
                change: '+2.1%',
                gradientColors: const [
                  Color(0xFF6366F1),
                  Color(0xFF06B6D4),
                ],
              ),
              MetricCard(
                icon: Icons.trending_up,
                label: '24h Forecast',
                value: '2.45 MW',
                change: '+3.2%',
                gradientColors: const [
                  Color(0xFF06B6D4),
                  Color(0xFF8B5CF6),
                ],
              ),
              MetricCard(
                icon: Icons.warning_amber,
                label: 'Peak Alert',
                value: '3.2 MW',
                change: 'at 14:00',
                gradientColors: const [
                  Color(0xFF8B5CF6),
                  Color(0xFF6366F1),
                ],
              ),
              MetricCard(
                icon: Icons.bolt,
                label: 'Recommended Load',
                value: '2.1 MW',
                change: '-8.5%',
                gradientColors: const [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ],
              ),
                  ],
                );
              },
            ),
          const SizedBox(height: 24),
          // Prediction Chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '24-Hour Prediction vs Actual',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  height: isMobile ? 320 : 400,
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 500,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white.withOpacity(0.1),
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < predictionData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '${predictionData[value.toInt()]['hour']}h',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }
                              return Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${(value / 1000).toStringAsFixed(1)}k',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (predictionData.length - 1).toDouble(),
                      minY: 0,
                      maxY: 3000,
                      lineBarsData: [
                        LineChartBarData(
                          spots: predictionData.asMap().entries.map((e) {
                            return FlSpot(
                              e.key.toDouble(),
                              e.value['predicted'] as double,
                            );
                          }).toList(),
                          isCurved: true,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          dashArray: [5, 5],
                        ),
                        LineChartBarData(
                          spots: predictionData.asMap().entries.map((e) {
                            return FlSpot(
                              e.key.toDouble(),
                              e.value['actual'] as double,
                            );
                          }).toList(),
                          isCurved: true,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00E5FF), Color(0xFF006064)],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              return LineTooltipItem(
                                '${touchedSpot.y.toInt()}',
                                TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Insights and Recommendations
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1000) {
                return Column(
                  children: [
                    _buildInsightsCard(),
                    const SizedBox(height: 24),
                    _buildRecommendationsCard(),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildInsightsCard(),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildRecommendationsCard(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildInsightsCard() {
    final insights = [
      {
        'title': 'Peak Load Expected',
        'description': '3.2 MW at 14:00 - prepare battery discharge',
      },
      {
        'title': 'Solar Generation Optimal',
        'description': 'Expected 2.8 MW between 10:00-16:00',
      },
      {
        'title': 'Grid Demand Low',
        'description': 'Opportunity to charge batteries at 02:00-06:00',
      },
    ];

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Insights',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...insights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF06B6D4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight['title'] as String,
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            insight['description'] as String,
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.6)
                                  : const Color(0xFF0F172A).withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    final recommendations = [
      {
        'title': 'Optimize Battery Charging',
        'description': 'Charge during low-demand hours to maximize efficiency',
      },
      {
        'title': 'Shift Non-Critical Loads',
        'description': 'Move maintenance tasks to 02:00-06:00 window',
      },
      {
        'title': 'Prepare for Peak Hours',
        'description': 'Ensure 85% battery charge before 12:00',
      },
    ];

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...recommendations.map((recommendation) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recommendation['title'] as String,
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            recommendation['description'] as String,
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.6)
                                  : const Color(0xFF0F172A).withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

