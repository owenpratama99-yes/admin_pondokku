import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class StockOpnameScreen extends StatefulWidget {
  const StockOpnameScreen({super.key});

  @override
  State<StockOpnameScreen> createState() => _StockOpnameScreenState();
}

class _StockOpnameScreenState extends State<StockOpnameScreen> {
  final Map<String, TextEditingController> _controllers = {};
  String? _selectedBranch;
  bool _isLoading = false;

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Stock Opname',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildBranchSelector(),
                if (_selectedBranch != null) ...[
                  const SizedBox(height: 24),
                  _buildStockList(),
                  const SizedBox(height: 24),
                  _buildActions(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.infoSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Input jumlah stock aktual untuk setiap item. Sistem akan otomatis menghitung selisih.',
              style: GoogleFonts.outfit(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedBranch,
      decoration: const InputDecoration(
        labelText: 'Pilih Cabang *',
        prefixIcon: Icon(Icons.store),
      ),
      items: ['Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
          .map((b) => DropdownMenuItem(value: b, child: Text(b)))
          .toList(),
      onChanged: (v) => setState(() => _selectedBranch = v),
    );
  }

  Widget _buildStockList() {
    final items = _getMockItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Item',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildStockItem(item)),
      ],
    );
  }

  Widget _buildStockItem(Map<String, dynamic> item) {
    final id = item['id'] as String;
    _controllers.putIfAbsent(id, () => TextEditingController());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  item['category'],
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System',
                  style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMuted),
                ),
                Text(
                  '${item['system']} ${item['unit']}',
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 120,
            child: TextField(
              controller: _controllers[id],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Aktual',
                suffixText: item['unit'],
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => context.pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Batal'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Simpan Stock Opname'),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stock opname berhasil disimpan'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getMockItems() {
    return [
      {'id': 'INV001', 'name': 'Kopi Arabica', 'category': 'Kopi', 'system': 15, 'unit': 'kg'},
      {'id': 'INV002', 'name': 'Susu Full Cream', 'category': 'Susu', 'system': 25, 'unit': 'liter'},
      {'id': 'INV003', 'name': 'Gula Pasir', 'category': 'Gula', 'system': 20, 'unit': 'kg'},
      {'id': 'INV004', 'name': 'Sirup Vanilla', 'category': 'Sirup', 'system': 12, 'unit': 'botol'},
    ];
  }
}
