import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/inventory_model.dart';
import '../../widgets/manager_scaffold.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _selectedBranch = 'ALL';
  String _selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Inventory Management',
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildInventoryList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final items = _getMockInventory();
    final lowStock = items.where((i) => i.isLowStock).length;
    final critical = items.where((i) => i.isCritical).length;

    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Total Items', '${items.length}', Icons.inventory_2, AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('Low Stock', '$lowStock', Icons.warning, AppColors.warning),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('Critical', '$critical', Icons.error, AppColors.error),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Stock opname')),
              );
            },
            icon: const Icon(Icons.checklist),
            label: const Text('Stock Opname'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.background,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedBranch,
              decoration: const InputDecoration(labelText: 'Cabang'),
              items: ['ALL', 'Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBranch = v!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: ['ALL', 'Kopi', 'Susu', 'Gula', 'Sirup', 'Lainnya']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    final items = _getMockInventory();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildInventoryCard(items[index]);
      },
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isCritical
              ? AppColors.error.withOpacity(0.5)
              : item.isLowStock
                  ? AppColors.warning.withOpacity(0.5)
                  : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(item).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(item.category),
              color: _getStatusColor(item),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${item.branchName} • ${item.category}',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: item.stockPercentage / 100,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(_getStatusColor(item)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.currentStock} ${item.unit}',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(item),
                ),
              ),
              Text(
                'Min: ${item.minStock}',
                style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMuted),
              ),
              if (item.isLowStock)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.isCritical ? 'CRITICAL' : 'LOW',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(item),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(InventoryItem item) {
    if (item.isCritical) return AppColors.error;
    if (item.isLowStock) return AppColors.warning;
    return AppColors.success;
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'kopi':
        return Icons.coffee;
      case 'susu':
        return Icons.water_drop;
      case 'gula':
        return Icons.grain;
      default:
        return Icons.inventory_2;
    }
  }

  List<InventoryItem> _getMockInventory() {
    return [
      InventoryItem(
        id: 'INV001',
        name: 'Kopi Arabica',
        category: 'Kopi',
        unit: 'kg',
        currentStock: 5,
        minStock: 10,
        maxStock: 50,
        branchId: 'BR001',
        branchName: 'Dago',
        lastUpdated: DateTime.now(),
      ),
      InventoryItem(
        id: 'INV002',
        name: 'Susu Full Cream',
        category: 'Susu',
        unit: 'liter',
        currentStock: 25,
        minStock: 20,
        maxStock: 100,
        branchId: 'BR001',
        branchName: 'Dago',
        lastUpdated: DateTime.now(),
      ),
      InventoryItem(
        id: 'INV003',
        name: 'Gula Pasir',
        category: 'Gula',
        unit: 'kg',
        currentStock: 8,
        minStock: 15,
        maxStock: 50,
        branchId: 'BR001',
        branchName: 'Dago',
        lastUpdated: DateTime.now(),
      ),
      InventoryItem(
        id: 'INV004',
        name: 'Sirup Vanilla',
        category: 'Sirup',
        unit: 'botol',
        currentStock: 12,
        minStock: 10,
        maxStock: 30,
        branchId: 'BR002',
        branchName: 'Dipatiukur',
        lastUpdated: DateTime.now(),
      ),
    ];
  }
}
