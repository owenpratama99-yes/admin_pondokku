import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class PredictiveAnalyticsScreen extends StatelessWidget {
  const PredictiveAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Predictive Analytics',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildForecastCards(),
            const SizedBox(height: 24),
            _buildSalesForecast(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildStaffingRecommendation()),
                const SizedBox(width: 20),
                Expanded(child: _buildInventoryPrediction()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastCards() {
    return Row(
      children: [
        Expanded(child: _buildForecastCard('Next Week Revenue', 'Rp 32M', '+8%', AppColors.success)),
        const SizedBox(width: 16),
        Expanded(child: _buildForecastCard('Peak Hours', '14:00-16:00', 'Weekdays', AppColors.info)),
        const SizedBox(width: 16),
        Expanded(child: _buildForecastCard('Staff Needed', '18 people', 'Next week', AppColors.warning)),
      ],
    );
  }

  Widget _buildForecastCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.outfit(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesForecast() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Sales Forecast (Next 7 Days)',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.infoSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, size: 14, color: AppColors.info),
                    const SizedBox(width: 4),
                    Text(
                      'AI Powered',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 50),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(7, (i) => FlSpot(i.toDouble(), 4 + (i * 0.3))),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: List.generate(7, (i) => FlSpot(i.toDouble(), 3.5 + (i * 0.25))),
                    isCurved: true,
                    color: AppColors.textMuted,
                    barWidth: 2,
                    dashArray: [5, 5],
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffingRecommendation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Staffing Recommendation',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStaffingItem('Monday', 5, 'Morning', AppColors.success),
          _buildStaffingItem('Tuesday', 6, 'Afternoon', AppColors.info),
          _buildStaffingItem('Wednesday', 5, 'Morning', AppColors.success),
          _buildStaffingItem('Thursday', 7, 'All Day', AppColors.warning),
          _buildStaffingItem('Friday', 8, 'All Day', AppColors.error),
        ],
      ),
    );
  }

  Widget _buildStaffingItem(String day, int count, String shift, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count staff',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            shift,
            style: GoogleFonts.outfit(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryPrediction() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inventory Prediction',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Items need restock soon',
            style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          _buildInventoryItem('Kopi Arabica', '3 days', AppColors.error),
          _buildInventoryItem('Susu Full Cream', '5 days', AppColors.warning),
          _buildInventoryItem('Gula Pasir', '7 days', AppColors.info),
          _buildInventoryItem('Sirup Vanilla', '10 days', AppColors.success),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(String item, String timeLeft, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Restock in $timeLeft',
                  style: GoogleFonts.outfit(fontSize: 12, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
