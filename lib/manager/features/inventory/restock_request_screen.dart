import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class RestockRequestScreen extends StatefulWidget {
  const RestockRequestScreen({super.key});

  @override
  State<RestockRequestScreen> createState() => _RestockRequestScreenState();
}

class _RestockRequestScreenState extends State<RestockRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBranch;
  final List<Map<String, dynamic>> _selectedItems = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Request Restock',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBranchSelector(),
                  const SizedBox(height: 24),
                  if (_selectedBranch != null) ...[
                    _buildItemSelector(),
                    const SizedBox(height: 24),
                    if (_selectedItems.isNotEmpty) ...[
                      _buildSelectedItems(),
                      const SizedBox(height: 24),
                    ],
                    _buildActions(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranchSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedBranch,
      decoration: const InputDecoration(
        labelText: 'Cabang *',
        prefixIcon: Icon(Icons.store),
      ),
      items: ['Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
          .map((b) => DropdownMenuItem(value: b, child: Text(b)))
          .toList(),
      onChanged: (v) => setState(() => _selectedBranch = v),
      validator: (v) => v == null ? 'Pilih cabang' : null,
    );
  }

  Widget _buildItemSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Item',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: _getAvailableItems().map((item) {
              return ListTile(
                title: Text(item['name']),
                subtitle: Text('Stock: ${item['stock']} ${item['unit']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                  onPressed: () => _addItem(item),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item yang Direquest',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ..._selectedItems.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item['name'],
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Qty',
                    suffixText: item['unit'],
                    isDense: true,
                  ),
                  onChanged: (v) => item['qty'] = v,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle, color: AppColors.error),
                onPressed: () => setState(() => _selectedItems.remove(item)),
              ),
            ],
          ),
        )),
      ],
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
            onPressed: _isLoading || _selectedItems.isEmpty ? null : _submit,
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
                : const Text('Kirim Request'),
          ),
        ),
      ],
    );
  }

  void _addItem(Map<String, dynamic> item) {
    if (!_selectedItems.any((i) => i['id'] == item['id'])) {
      setState(() => _selectedItems.add({...item, 'qty': ''}));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request restock berhasil dikirim'),
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
            content: Text('Gagal mengirim request: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getAvailableItems() {
    return [
      {'id': 'INV001', 'name': 'Kopi Arabica', 'stock': 5, 'unit': 'kg'},
      {'id': 'INV002', 'name': 'Susu Full Cream', 'stock': 25, 'unit': 'liter'},
      {'id': 'INV003', 'name': 'Gula Pasir', 'stock': 8, 'unit': 'kg'},
      {'id': 'INV004', 'name': 'Sirup Vanilla', 'stock': 12, 'unit': 'botol'},
    ];
  }
}
