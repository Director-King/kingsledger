import 'package:flutter/material.dart';
import 'package:kings_ledger/models/transaction_model.dart';
import 'package:kings_ledger/theme/app_theme.dart';
import 'package:intl/intl.dart';

class SmsTriggerSheet extends StatefulWidget {
  final TransactionModel transaction;
  final Function(String, bool)? onConfirm;
  final VoidCallback? onDismiss;

  const SmsTriggerSheet({
    super.key,
    required this.transaction,
    this.onConfirm,
    this.onDismiss,
  });

  static Future<void> show(BuildContext context, TransactionModel transaction) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SmsTriggerSheet(transaction: transaction),
    );
  }

  @override
  State<SmsTriggerSheet> createState() => _SmsTriggerSheetState();
}

class _SmsTriggerSheetState extends State<SmsTriggerSheet> {
  late String selectedCategory;
  bool isSplit = false;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'icon': Icons.restaurant},
    {'name': 'Fuel', 'icon': Icons.local_gas_station},
    {'name': 'TeraSoko', 'icon': Icons.storefront, 'isBusiness': true},
    {'name': 'Rent', 'icon': Icons.home},
    {'name': 'Utilities', 'icon': Icons.bolt},
    {'name': 'Subscriptions', 'icon': Icons.subscriptions},
    {'name': 'Groceries', 'icon': Icons.shopping_cart},
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.transaction.category;
    // ensure the smart guess category is in the list or just select the first if not found
    if (!categories.any((c) => c['name'] == selectedCategory)) {
      selectedCategory = 'Food'; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: 'Ksh ', decimalDigits: 0);
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            height: 6,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 32),
          
          Text(
            'NEW TRANSACTION DETECTED',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            formatCurrency.format(widget.transaction.amount),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Smart Guess Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, color: AppTheme.primary, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Smart Guess: ${widget.transaction.category}?',
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Category Grid (Showing first 4 for simplicity like the design)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4, // From the design there are 4 prominent categories
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = selectedCategory == cat['name'];
              final isBusiness = cat['isBusiness'] == true;
              
              return InkWell(
                onTap: () => setState(() => selectedCategory = cat['name'] as String),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primary.withOpacity(0.15) 
                            : isBusiness ? AppTheme.primary.withOpacity(0.05) : Colors.white10,
                        border: Border.all(
                          color: isSelected 
                              ? AppTheme.primary 
                              : isBusiness ? AppTheme.primary.withOpacity(0.5) : Colors.white10,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        cat['icon'] as IconData,
                        color: isSelected || isBusiness ? AppTheme.primary : AppTheme.textLight,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat['name'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected || isBusiness ? AppTheme.primary : AppTheme.textMuted,
                        fontWeight: isSelected || isBusiness ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Split Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.call_split, color: AppTheme.textMuted, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Split Transaction',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textLight),
                      ),
                      Text(
                        'Divide into multiple categories',
                        style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isSplit,
                  activeColor: AppTheme.primary,
                  onChanged: (val) {
                    setState(() => isSplit = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Actions
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (widget.onConfirm != null) {
                  widget.onConfirm!(selectedCategory, isSplit);
                } else {
                  Navigator.pop(context); // default action
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.backgroundDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enableFeedback: true, // haptic feedback
              ),
              child: const Text('Confirm Categorization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              if (widget.onDismiss != null) {
                widget.onDismiss!();
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Dismiss', style: TextStyle(color: AppTheme.textMuted)),
          ),
        ],
      ),
    );
  }
}
